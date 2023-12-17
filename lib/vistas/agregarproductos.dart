// ingresarcompras.dart
import 'package:flutter/material.dart';
import 'package:verduleria/servicios/productos.services.dart';

class IngresarComprasScreen extends StatefulWidget {
  @override
  _IngresarComprasScreenState createState() => _IngresarComprasScreenState();
}

class _IngresarComprasScreenState extends State<IngresarComprasScreen> {
  final TextEditingController nombreController = TextEditingController();
  String unidadSeleccionada = 'Unidad'; // Valor por defecto
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController valorController = TextEditingController();

  final ProductosService _productosService = ProductosService();

  // Opciones para el DropdownButton
  final List<String> opcionesUnidad = [
    'Unidad',
    'Kilogramo',
    'Caja',
    'Saco',
    'Malla'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ingresar Compras',
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildTextField('Nombre', nombreController),
            buildDropdownButton(),
            buildTextField(
                'Cantidad', cantidadController, TextInputType.number),
            buildTextField('Valor', valorController, TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Obtén los valores del formulario
                String nombre = nombreController.text.trim();
                int cantidad = int.tryParse(cantidadController.text) ?? 0;
                int valor = int.tryParse(valorController.text) ?? 0;

                // Validación: asegúrate de que al menos el nombre, la cantidad y el valor estén llenos
                if (nombre.isNotEmpty && cantidad > 0 && valor > 0) {
                  // Ingresa el nuevo producto
                  await _productosService.ingresarProducto(
                    nombre,
                    unidadSeleccionada,
                    cantidad,
                    valor,
                  );

                  // Limpia los controladores después de ingresar el producto
                  nombreController.clear();
                  unidadSeleccionada = 'Unidad';
                  cantidadController.clear();
                  valorController.clear();

                  // Muestra un mensaje de éxito
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Producto ingresado correctamente'),
                    ),
                  );
                } else {
                  // Muestra un mensaje de error si algún campo está vacío
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Completa todos los campos antes de ingresar el producto'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              ),
              child: Text(
                'Ingresar Producto',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      [TextInputType? keyboardType]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Widget buildDropdownButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: unidadSeleccionada,
        onChanged: (String? newValue) {
          if (newValue != null) {
            // Actualiza el valor de la unidad seleccionada
            setState(() {
              unidadSeleccionada = newValue;
            });
          }
        },
        items: opcionesUnidad.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: 'Unidad',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
