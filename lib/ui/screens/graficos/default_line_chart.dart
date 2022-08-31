import 'package:flutter/material.dart';
import 'package:flutter_web/models/ejercicio.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SyncfusionChart extends StatelessWidget {
  final List<Ejercicio> data;

  final DateFormat formatter = DateFormat('dd-MM-yyyy - kk:mm');
  String titulo = '';

  SyncfusionChart({required this.data});

  void getTitulo(){
    Ejercicio ejercicioAux = data[0];

    if(ejercicioAux.tipoEjercicio != null){
      titulo = ejercicioAux.tipoEjercicio.split('ejercicio')[1];
      print('Titulo gráfica: ' + titulo);
    } 

  }

  SfCartesianChart _buildLineChart() {

    getTitulo(); 

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Ejercicios ' + titulo ),
      legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(),
      series: _getDefaultLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<Ejercicio, DateTime>> _getDefaultLineSeries() {
    return <LineSeries<Ejercicio, DateTime>>[
                LineSeries<Ejercicio, DateTime>(
                  animationDuration: 2500,
                  dataSource:  data,
                  width: 2,
                  name: 'Aciertos',
                  xValueMapper: (Ejercicio ejercicio, _) => ejercicio.dateFin,
                  yValueMapper: (Ejercicio ejercicio, _) => ejercicio.aciertos,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
                LineSeries<Ejercicio, DateTime>(
                  animationDuration: 2500,
                  dataSource:  data,
                  width: 2,
                  name: 'Errores',
                  xValueMapper: (Ejercicio ejercicio, _) => ejercicio.dateFin, 
                  yValueMapper: (Ejercicio ejercicio, _) => ejercicio.errores,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
                LineSeries<Ejercicio, DateTime>(
                  animationDuration: 2500,
                  dataSource:  data,
                  width: 2,
                  name: 'Letras no encontradas',
                  xValueMapper: (Ejercicio ejercicio, _) => ejercicio.dateFin, 
                  yValueMapper: (Ejercicio ejercicio, _) => ejercicio.letrasCorrectas! - ejercicio.aciertos,
                  markerSettings: const MarkerSettings(isVisible: true),
                )
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: Container(
            child: _buildLineChart()
          )
        )
    );
  }

}