// autentificacion
import 'package:firebase_auth/firebase_auth.dart';

// funciones para credenciales

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Sesión cerrada correctamente');
    } catch (e) {
      print('Error al cerrar sesión: $e');
      throw e;
    }
  }
}
