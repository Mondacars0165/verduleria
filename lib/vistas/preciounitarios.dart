import 'package:flutter/material.dart';
import 'package:verduleria/servicios/productos.services.dart';

class AppState {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  double _porcentajeGanancia = 0.0;

  double get porcentajeGanancia => _porcentajeGanancia;

  setPorcentajeGanancia(double porcentaje) {
    _porcentajeGanancia = porcentaje;
  }
}

class PreciosUnitariosScreen extends StatefulWidget {
  final ProductosService _productosService;

  PreciosUnitariosScreen({required ProductosService productosService})
      : _productosService = productosService;

  @override
  _PreciosUnitariosScreenState createState() => _PreciosUnitariosScreenState();
}

class _PreciosUnitariosScreenState extends State<PreciosUnitariosScreen> {
  final AppState _appState = AppState();

  late double _porcentajeGanancia;
  late double _precioVenta;

  @override
  void initState() {
    super.initState();
    _porcentajeGanancia = _appState.porcentajeGanancia;
    _precioVenta = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Precios',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _mostrarDialogoPorcentajeGanancia();
              },
            ),
          ],
        ),
        backgroundColor: Colors.lightGreen[200],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Ganancia: $_porcentajeGanancia%',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: widget._productosService.getProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List productos = snapshot.data as List;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 15,
                dataRowHeight: 50,
                headingRowHeight: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                columns: [
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.lightGreen[100],
                      child: Center(
                        child: Text('Fecha', style: TextStyle(fontSize: 19)),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.lightGreen[100],
                      child: Center(
                        child: Text('Nombre', style: TextStyle(fontSize: 19)),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.lightGreen[100],
                      child: Center(
                        child: Text('Valor Venta', style: TextStyle(fontSize: 19)),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.lightGreen[100],
                      child: Center(
                        child: Text('Unidad', style: TextStyle(fontSize: 19)),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.lightGreen[100],
                      child: Center(
                        child: Text('Valor Compra', style: TextStyle(fontSize: 19)),
                      ),
                    ),
                  ),
                ],
                rows: productos.map((producto) {
                  String nombre = producto?['nombre'] ?? 'Nombre no disponible';
                  String fecha =
                      producto?['fechaIngreso'] ?? 'Fecha no disponible';
                  String unidad = producto?['unidad'] ?? 'Unidad no disponible';
                  int cantidad = producto?['cantidad'] ?? 0;
                  int valor = producto?['valor'] ?? 0;
                  double precioUnitario = cantidad > 0 ? valor / cantidad : 0;
                  double precioVenta =
                      precioUnitario * (1 + _porcentajeGanancia / 100);

                  return DataRow(
                    cells: [
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(fecha, style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(nombre, style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(precioVenta.toStringAsFixed(2),
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(unidad, style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Text(precioUnitario.toStringAsFixed(2),
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _mostrarDialogoPorcentajeGanancia() async {
    TextEditingController porcentajeController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Configurar Ganancia (%)'),
          content: TextField(
            controller: porcentajeController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Porcentaje'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                double porcentaje =
                    double.tryParse(porcentajeController.text) ?? 0.0;
                _appState.setPorcentajeGanancia(porcentaje);
                setState(() {
                  _porcentajeGanancia = porcentaje;
                });
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
