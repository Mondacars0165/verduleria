import 'package:flutter/material.dart';
import 'package:verduleria/servicios/productos.services.dart';
import 'package:verduleria/vistas/verproductos.dart';
import 'package:verduleria/vistas/agregarproductos.dart';
import 'package:verduleria/vistas/eliminarproductos.dart';
import 'package:verduleria/vistas/preciounitarios.dart';
import 'package:verduleria/vistas/hacercaja.dart';
import 'package:verduleria/vistas/historial.dart';
import 'package:verduleria/servicios/auth.service.dart';

class HomeNRM extends StatelessWidget {
  final AuthService _authService;
  final ProductosService _productosService;

  HomeNRM({
    required AuthService authService,
    required ProductosService productosService,
  })  : _authService = authService,
        _productosService = productosService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menú Principal',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
        backgroundColor: Colors.lightGreen[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildMenuButton(
                    context,
                    'Ingresar Compras',
                    Icons.add_shopping_cart,
                    IngresarComprasScreen(),
                  ),
                  SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'Ver Compras Realizadas',
                    Icons.shopping_basket,
                    VerProductosScreen(productosService: _productosService),
                  ),
                  SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'Eliminar Compras',
                    Icons.delete,
                    EliminarProductoScreen(productosService: _productosService),
                  ),
                  SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'Precios',
                    Icons.monetization_on,
                    PreciosUnitariosScreen(productosService: _productosService),
                  ),
                  SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'Hacer Caja',
                    Icons.attach_money,
                    HacerCajaScreen(),
                  ),
                  SizedBox(height: 20),
                  _buildMenuButton(
                    context,
                    'Historial de Cajas',
                    Icons.history,
                    CajasTotalesScreen (), // Este es el botón existente
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    String title,
    IconData iconData,
    Widget screen,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.lightGreen[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.all(16.0),
      ),
      child: Column(
        children: [
          Icon(iconData, size: 40, color: Colors.black),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
