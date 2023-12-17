import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:verduleria/servicios/caja.services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CajasTotalesScreen extends StatefulWidget {
  @override
  _CajasTotalesScreenState createState() => _CajasTotalesScreenState();
}

class _CajasTotalesScreenState extends State<CajasTotalesScreen> {
  DateTime _selectedDate = DateTime.now();
  final CajaService _cajaService = CajaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cajas Totales'),
        backgroundColor: Colors.lightGreen[200],
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _cajaService.getProductosEnFecha(_selectedDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Error obteniendo productos'));
            } else {
              List<Map<String, dynamic>> cajasTotales = snapshot.data!;

              if (cajasTotales.isEmpty) {
                return Center(
                  child: Text(
                    'No hay datos para la fecha seleccionada',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                );
              }

              return charts.BarChart(
                _createSeries(cajasTotales),
                animate: true,
                animationDuration: Duration(milliseconds: 500),
                barRendererDecorator: charts.BarLabelDecorator<String>(),
                domainAxis: charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 12,
                    ),
                  ),
                ),
                primaryMeasureAxis: charts.NumericAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 12,
                    ),
                  ),
                ),
                behaviors: [
                  charts.ChartTitle(
                    'Fechas',
                    behaviorPosition: charts.BehaviorPosition.bottom,
                    titleStyleSpec: charts.TextStyleSpec(fontSize: 16),
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                  ),
                  charts.ChartTitle(
                    'Monto Total',
                    behaviorPosition: charts.BehaviorPosition.start,
                    titleStyleSpec: charts.TextStyleSpec(fontSize: 16),
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  List<charts.Series<BarChartData, String>> _createSeries(
    List<Map<String, dynamic>> cajasTotales,
  ) {
    List<BarChartData> data = [];

    for (int i = 0; i < cajasTotales.length; i++) {
      dynamic fecha = cajasTotales[i]['fecha'];
      DateTime date;

      if (fecha is Timestamp) {
        date = fecha.toDate();
      } else if (fecha is String) {
        date = DateTime.parse(fecha); // Puedes ajustar el formato según sea necesario
      } else {
        continue;
      }

      dynamic montoTotal = cajasTotales[i]['montoTotal'];
      if (montoTotal != null) {
        double amount = montoTotal.toDouble();
        data.add(BarChartData(_formattedDate(date), amount));
      }
    }

    return [
      charts.Series<BarChartData, String>(
        id: 'CajasTotales',
        domainFn: (BarChartData sales, _) => sales.date,
        measureFn: (BarChartData sales, _) => sales.amount,
        data: data,
      ),
    ];
  }

  String _formattedDate(DateTime date) {
    return DateFormat('d/M/yyyy').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    )) ?? _selectedDate;

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class BarChartData {
  final String date;
  final double amount;

  BarChartData(this.date, this.amount);
}
