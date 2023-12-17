import 'package:flutter/material.dart';
import 'package:verduleria/servicios/productos.services.dart';

class EliminarProductoScreen extends StatefulWidget {
  final ProductosService productosService;

  EliminarProductoScreen({required this.productosService});

  @override
  _EliminarProductoScreenState createState() => _EliminarProductoScreenState();
}

class _EliminarProductoScreenState extends State<EliminarProductoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eliminar Compra',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[200],
      ),
      body: FutureBuilder(
        future: widget.productosService.getProductos(),
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
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
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
                        child: Text('Valor', style: TextStyle(fontSize: 19)),
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
                        child: Text('Cantidad', style: TextStyle(fontSize: 19)),
                      ),
                    ),
                  ),
                ],
                rows: productos.map((producto) {
                  String nombre = producto?['nombre'] ?? 'Nombre no disponible';
                  String fecha =
                      producto?['fechaIngreso'] ?? 'Fecha no disponible';
                  int cantidad = producto?['cantidad'] ?? 0;
                  int valor = producto?['valor'] ?? 0;
                  String unidad = producto?['unidad'] ?? 'Unidad no disponible';
                  String productoId = producto?['Document ID'] ?? '';

                  return DataRow(
                    cells: [
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _confirmDelete(productoId, productos);
                              },
                            ),
                          ),
                        ),
                      ),
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
                            child: Text(valor.toString(),
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
                            child: Text(cantidad.toString(),
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

  Future<void> _confirmDelete(String productoId, List productos) async {
    if (productoId.isNotEmpty) {
      bool confirmacion = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmar Eliminación'),
            content: Text('¿Estás seguro de que quieres eliminar este producto?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Eliminar'),
              ),
            ],
          );
        },
      );

      if (confirmacion == true) {
        await _handleDeleteProduct(productoId, productos);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ID del producto no disponible'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleDeleteProduct(String productoId, List productos) async {
    await widget.productosService.eliminarProducto(productoId);

    setState(() {
      productos
          .removeWhere((producto) => producto['Document ID'] == productoId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compra eliminada correctamente'),
      ),
    );
  }
}
