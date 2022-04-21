import 'package:flutter/material.dart';
import 'package:flutter_web/models/ejercicio.dart';
import 'package:graphic/graphic.dart';

class EjercicioChart extends StatelessWidget {
  final List<Ejercicio> data;

  EjercicioChart({required this.data});

  
  @override
  Widget build(BuildContext context) {
    return Chart(data: data, 
                variables: {
                  'tipoEjercicio': Variable(
                      accessor: (Ejercicio ejercicio) => ejercicio.tipoEjercicio as String,
                  ),
                  'aciertos' : Variable(
                    accessor: (Ejercicio ejercicio) => ejercicio.aciertos as int 
                  )
                },
                elements: [IntervalElement()],
                axes: [
                  Defaults.horizontalAxis,
                  Defaults.verticalAxis,
                ],
    );
  }

}