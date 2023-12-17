// homeadm.dart
import 'package:flutter/material.dart';
import 'package:verduleria/servicios/auth.service.dart';

class HomeAdmin extends StatelessWidget {
  final AuthService _authService;

  HomeAdmin({required AuthService authService}) : _authService = authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel administrador'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              // Cerrar sesión al hacer clic en el botón de cerrar sesión
              await _authService.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenido, Administrador'),
            // Agrega aquí elementos específicos para la vista de administrador según tus necesidades
          ],
        ),
      ),
    );
  }
}
