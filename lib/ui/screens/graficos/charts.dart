import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_web/controler/firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../models/usuario.dart';
import '../../../models/ejercicio.dart';
import 'fileSave.dart';

class Charts extends StatefulWidget {
  final Usuario alumno;
  final int meses;
  final String tipoEjercicio;
  final String dificultad;

  const Charts({Key? key, required this.alumno, required this.meses, required this.tipoEjercicio, required this.dificultad}) : super(key: key);
  
  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {

  late GlobalKey<SfCartesianChartState> _cartesianChartKey;
  late final Future<List<Ejercicio>> data;
  bool isButtonActive = false;
  
  @override
  initState(){
    super.initState();
    _cartesianChartKey = GlobalKey();
    data = FirestoreHelper().getEjerciciosParametros(widget.alumno, widget.tipoEjercicio, widget.meses, widget.dificultad);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alumno.nombre + " " + widget.alumno.apellidos,  style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: [
          ElevatedButton(
            child: const Text('Exportar como PDF'),
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent,
              shape: RoundedRectangleBorder( //to set border radius to button
                borderRadius: BorderRadius.circular(0)
              ),
            ),
            onPressed: () {
              if(isButtonActive){
                _renderPdf();
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    duration: Duration(milliseconds: 2000),
                    content: Text('No hay gráfica que exportar'),
                  )
                );
              }
              
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Ejercicio>>(
          future: data,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Press button to start.');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(),);
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if(snapshot.data!.isEmpty){
                  return Text("El alumno no ha realizado ninguna actividad con las características deseadas");
                }else{
                  isButtonActive = true;
                  return _buildLineChart(snapshot.data!);
                }
                
            }
          }
        )
      ),
    );
  }


  SfCartesianChart _buildLineChart(List<Ejercicio> list) {

    return SfCartesianChart(
      key: _cartesianChartKey,
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Ejercicios ' + widget.tipoEjercicio + ' del alumno ' + widget.alumno.nombre + ' '+ widget.alumno.apellidos),
      legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(),
      series: _getDefaultLineSeries(list),
      tooltipBehavior: TooltipBehavior(enable: true, format: 'point.y series.name el día point.x'
      ),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<Ejercicio, DateTime>> _getDefaultLineSeries(List<Ejercicio> list) {
    return <LineSeries<Ejercicio, DateTime>>[
                LineSeries<Ejercicio, DateTime>(
                  animationDuration: 2500,
                  dataSource:  list,
                  width: 2,
                  name: 'Aciertos',
                  xValueMapper: (Ejercicio ejercicio, _) => ejercicio.dateFin,
                  yValueMapper: (Ejercicio ejercicio, _) => ejercicio.aciertos,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
                LineSeries<Ejercicio, DateTime>(
                  animationDuration: 2500,
                  dataSource:  list,
                  width: 2,
                  name: 'Errores',
                  xValueMapper: (Ejercicio ejercicio, _) => ejercicio.dateFin, 
                  yValueMapper: (Ejercicio ejercicio, _) => ejercicio.errores,
                  markerSettings: const MarkerSettings(isVisible: true),
                ),
                LineSeries<Ejercicio, DateTime>(
                  animationDuration: 2500,
                  dataSource:  list,
                  width: 2,
                  name: 'Letras no encontradas',
                  xValueMapper: (Ejercicio ejercicio, _) => ejercicio.dateFin, 
                  yValueMapper: (Ejercicio ejercicio, _) => ejercicio.letrasCorrectas! - ejercicio.aciertos,
                  markerSettings: const MarkerSettings(isVisible: true),
                )
    ];
  }


  Future<void> _renderPdf () async {
    final ui.Image data = await  _cartesianChartKey.currentState!.toImage(pixelRatio : 3.0);
    final ByteData? bytes = await data.toByteData(format : ui.ImageByteFormat.png);
    final Uint8List imageBytes = bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    final PdfBitmap bitmap = PdfBitmap(imageBytes);
    final PdfDocument document = PdfDocument();
    document.pageSettings.size = Size(bitmap.width.toDouble(), bitmap.height.toDouble());
    //Change the page orientation to landscape
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    page.graphics.drawImage(bitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
    await FileSaveHelper.saveAndLaunchFile(document.save(), 'cartesian_chart.pdf');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        duration: Duration(milliseconds: 2000),
        content: Text('La gráfica ha sido exportada como un documento PDF'),
      )
    );
  }

}