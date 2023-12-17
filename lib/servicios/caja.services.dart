import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CajaService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> ingresarRegistro(
      String nombre, int valor, DateTime selectedDate) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    await db.collection('caja').add({
      'nombre': nombre,
      'valor': valor,
      'fecha': formattedDate,
    });
  }

  Future<List<Map<String, dynamic>>> getProductosEnFecha(
      DateTime? selectedDate) async {
    if (selectedDate == null) return [];

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
        .collection('caja')
        .where('fecha', isEqualTo: formattedDate)
        .get();

    return querySnapshot.docs
        .map((doc) => {...doc.data()! as Map<String, dynamic>, 'id': doc.id})
        .toList();
  }

  Future<void> eliminarProducto(String productId) async {
    await db.collection('caja').doc(productId).delete();
  }

  Future<void> guardarTotalCaja(DateTime fecha) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(fecha);

    double montoTotal = await _calcularMontoTotalEnFecha(fecha);

    await db.collection('cajas').add({
      'fecha': formattedDate,
      'montoTotal': montoTotal,
    });
  }

  Future<double> _calcularMontoTotalEnFecha(DateTime fecha) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(fecha);

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
        .collection('caja')
        .where('fecha', isEqualTo: formattedDate)
        .get();

    double total = 0.0;
    for (var doc in querySnapshot.docs) {
      total += (doc.data()!['valor'] ?? 0).toDouble();
    }

    return total;
  }
}
