import 'package:flutter/material.dart';
import 'package:verduleria/servicios/productos.services.dart';

class VerProductosScreen extends StatelessWidget {
  final ProductosService _productosService;

  VerProductosScreen({required ProductosService productosService})
      : _productosService = productosService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productos Comprados',
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
        future: _productosService.getProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List productos = snapshot.data as List;

            if (productos.isEmpty) {
              return Center(
                child: Text('No hay productos disponibles.'),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                dataRowHeight: 60, // Altura de las filas
                headingRowHeight: 70, // Altura de la fila de encabezado
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Borde de la tabla
                  borderRadius: BorderRadius.circular(10),
                ),
                columns: [
                  DataColumn(
                    label: Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      color: Colors.lightGreen[100],
                      child: Text('Nombre', style: TextStyle(fontSize: 19)),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 100,
                      padding: EdgeInsets.all(8),
                      color: Colors.lightGreen[100],
                      child: Text('Unidad', style: TextStyle(fontSize: 19)),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 100,
                      padding: EdgeInsets.all(8),
                      color: Colors.lightGreen[100],
                      child: Text('Cantidad', style: TextStyle(fontSize: 19)),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 100,
                      padding: EdgeInsets.all(8),
                      color: Colors.lightGreen[100],
                      child: Text('Valor', style: TextStyle(fontSize: 19)),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      color: Colors.lightGreen[100],
                      child: Text('Fecha', style: TextStyle(fontSize: 19)),
                    ),
                  ),
                ],
                rows: productos.map<DataRow>((producto) {
                  if (producto is Function) {
                    producto = producto();
                  }

                  String nombre = producto?['nombre'] ?? 'Nombre no disponible';
                  String unidad = producto?['unidad'] ?? 'Unidad no disponible';
                  int cantidad = producto?['cantidad'] ?? 0;
                  int valor = producto?['valor'] ?? 0;
                  String fecha =
                      producto?['fechaIngreso'] ?? 'Fecha no disponible';

                  return DataRow(
                    cells: [
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text(nombre, style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text(unidad, style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            cantidad.toString(),
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text(valor.toString(), style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text(fecha, style: TextStyle(fontSize: 18)),
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
}
