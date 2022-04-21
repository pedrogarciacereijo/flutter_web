import 'package:flutter/material.dart';
import 'package:flutter_web/models/firestore.dart';
import '../../models/ejercicio.dart';
import 'ejercicio_chart.dart';

class Charts extends StatefulWidget {
  final referenceId;

  const Charts({Key? key, this.referenceId}) : super(key: key);
  
  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {

  late final Future<List<Ejercicio>> data;
  
  initState(){
    super.initState();
    data = FirestoreHelper().getEjercicios(widget.referenceId);
  }
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                return EjercicioChart(data: snapshot.data!);
            }
          }
        )
      ),
    );
  }
}