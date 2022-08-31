import 'package:flutter/material.dart';
import 'package:flutter_web/models/firestore.dart';
import '../../models/ejercicio.dart';
import 'graficos/default_line_chart.dart';

class Charts extends StatefulWidget {
  final String referenceId;
  final int meses;
  final String tipoEjercicio;

  const Charts({Key? key, required this.referenceId, required this.meses, required this.tipoEjercicio}) : super(key: key);
  
  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {

  late final Future<List<Ejercicio>> data;
  
  initState(){
    super.initState();
    data = FirestoreHelper().getEjerciciosParametros(widget.referenceId, widget.tipoEjercicio, widget.meses);
  }
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
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
                return Text('Awaiting result...');
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                return SyncfusionChart(data: snapshot.data!);
            }
          }
        )
      ),
    );
  }
}