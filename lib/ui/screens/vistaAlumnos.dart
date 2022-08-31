import 'package:flutter/material.dart';
import 'package:flutter_web/ui/screens/charts.dart';

import '../../models/usuario.dart';

class VistaAlumnos extends StatefulWidget {
  final List<Usuario> list;

  const VistaAlumnos({Key? key, required this.list}) : super(key: key);

  @override
  _VistaAlumnosState createState() => _VistaAlumnosState();
}

class _VistaAlumnosState extends State<VistaAlumnos> {

  List<DropdownMenuItem<String>> _createList(List<Usuario> list){
    print("Creating List");
    
    List<DropdownMenuItem<String>> result = [];
    for (var alumno in list){
      result.add(
        DropdownMenuItem(
          value: alumno.referenceId,
          child: Text(alumno.nombre),
        )
      ) ;
      print(alumno.toJson());
    }
    return result;
  }

  String? _selectedItem;
  Widget Dropdown(List<Usuario> list){
    List<DropdownMenuItem<String>> items = _createList(list);
    final dropdown = DropdownButton(
      items: items,
      hint: Text("Elige un alumno"),
      value: _selectedItem,
      onChanged: (String? value) => setState(() {
        _selectedItem = value ?? "";
      }),
    );
    print("object");
    return dropdown;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blueGrey, Colors.blueGrey.shade900],
                stops: [0.8, 1.0]),
          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      Text(
                        "ELIGE UN ALUMNO PARA CONSULTAR SUS DATOS",
                        style: TextStyle(
                            fontFamily: "Comix-Loud",
                            color: Colors.white,
                            fontSize: 15.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25.0),
                      Dropdown(widget.list),
                      
                    ]  
                  ),
                ],
              ),
              
          )
        );
  }


}
