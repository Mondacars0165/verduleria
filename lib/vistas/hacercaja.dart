import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verduleria/servicios/caja.services.dart';

class HacerCajaScreen extends StatefulWidget {
  @override
  _HacerCajaScreenState createState() => _HacerCajaScreenState();
}

class _HacerCajaScreenState extends State<HacerCajaScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  final CajaService _cajaService = CajaService();

  static DateTime? selectedDate;
  bool cajaCerrada = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Caja de ${selectedDate != null ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}" : ""}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openForm(context),
          ),
        ],
        backgroundColor: Colors.lightGreen[200],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cajaService.getProductosEnFecha(selectedDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error obteniendo productos'));
          } else {
            List<Map<String, dynamic>> productos = snapshot.data!;

            if (productos.isEmpty) {
              return Center(
                child: Text(
                  'No hay productos para la fecha seleccionada',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      var producto = productos[index];
                      return ListTile(
                        title: Text(producto['nombre'] ?? ''),
                        subtitle: Text(
                          NumberFormat.currency(
                            symbol: '\$',
                            decimalDigits: 2,
                          ).format(producto['valor'] ?? 0),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _cajaService.eliminarProducto(producto['id']);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
                ),
                BottomAppBar(
                  child: Container(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future:
                                _cajaService.getProductosEnFecha(selectedDate),
                            builder: (context, snapshot) {
                              double montoTotal =
                                  _calcularMontoTotal(snapshot.data ?? []);
                              return Text(
                                'Monto Total: ${NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(montoTotal)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: cajaCerrada
                              ? null
                              : () async {
                                  await _cajaService.guardarTotalCaja(selectedDate!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Datos guardados correctamente'),
                                    ),
                                  );
                                  setState(() {
                                    cajaCerrada = true;
                                  });
                                },
                          child: Text('Guardar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _openForm(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Registro'),
          content: Column(
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: valorController,
                decoration: InputDecoration(labelText: 'Valor'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                String nombre = nombreController.text.trim();
                double valorDouble =
                    double.tryParse(valorController.text) ?? 0.0;
                int valor = valorDouble.round(); // Convertir a entero

                if (nombre.isNotEmpty && valor > 0) {
                  await _cajaService.ingresarRegistro(
                    nombre,
                    valor,
                    selectedDate!,
                  );

                  nombreController.clear();
                  valorController.clear();

                  setState(() {});

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Registro ingresado correctamente'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Completa todos los campos antes de ingresar el registro'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Agregar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        )) ??
        selectedDate!;

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        cajaCerrada = false; // Reiniciar el estado al seleccionar una nueva fecha
      });
    }
  }

  double _calcularMontoTotal(List<Map<String, dynamic>> productos) {
    double total = 0.0;
    for (var producto in productos) {
      total += producto['valor'] ?? 0.0;
    }
    return total;
  }
}
