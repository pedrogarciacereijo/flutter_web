// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/models/usuario.dart';
import 'package:flutter_web/ui/screens/vistaAlumnos.dart';

import '../../models/admin.dart';
import '../../models/firestore.dart';
import 'charts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final Future<List<Usuario>> data;
  late final List<Usuario> data2;

  DateTime pre_backpress = DateTime.now();

  
  Widget _article(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        color: Colors.cyanAccent,
        child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam elementum dolor eget lorem euismod rutrum.',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

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
    print('Lista de alumnos creada');
    return result;
  }

  

  String? _selectedItemUsuario;
  Widget _dropdownUsuario(List<Usuario> list){
    List<DropdownMenuItem<String>> items = _createList(list);
    final dropdown = DropdownButton(
      items: items,
      hint: Text("Elige un alumno"),
      value: _selectedItemUsuario,
      onChanged: (String? value) => setState(() {
        _selectedItemUsuario = value ?? "";
      }),
    );
    print("DropdownButton creado");
    return dropdown;
  }

  int? _selectedItemTiempo;
  Widget _dropdownTiempo(){
    List<DropdownMenuItem<int>> items = [
      DropdownMenuItem(
          value: 1,
          child: Text('Último mes'),
      ),
      DropdownMenuItem(
          value: 3,
          child: Text('Últimos 3 meses'),
      ),
      DropdownMenuItem(
          value: 6,
          child: Text('Últimos 6 meses'),
      )

    ];
    final dropdown = DropdownButton(
      items: items,
      hint: Text("Elige el tiempo"),
      value: _selectedItemTiempo,
      onChanged: (int? value) => setState(() {
        _selectedItemTiempo = value ?? 1;
      }),
    );
    return dropdown;
  }

  String? _selectedItemTipo;
  Widget _dropdownTipo(){
    List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(
          value: 'ejercicioLetras',
          child: Text('Diferenciar Letras'),
      ),
      DropdownMenuItem(
          value: 'ejercicioDesplazamiento',
          child: Text('Encontrar con Desplazamiento'),
      )

    ];
    final dropdown = DropdownButton(
      items: items,
      hint: Text("Elige el tipo de ejercicio"),
      value: _selectedItemTipo,
      onChanged: (String? value) => setState(() {
        _selectedItemTipo = value ?? "";
      }),
    );
    return dropdown;
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: Text('Faltan datos'),
      content:
          Text("Elige un alumno, un periodo de tiempo y un ejercicio antes de continuar"),
      actions: <Widget>[
        TextButton(
            child: Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => _buildAlertDialog(),
    );
  }

  
  initState() {
    super.initState();
    data = FirestoreHelper().getAlumnos();
  }

  

  @override
  Widget build(BuildContext context) {

    
    return WillPopScope(
        onWillPop: onWillPop,
        child: Container(
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
                      Column(
                        children: [
                          FutureBuilder<List<Usuario>>(
                            future: data,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return Text('Press button to start.');
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                  return Text('Awaiting result...');
                                case ConnectionState.done:
                                  if (snapshot.hasError){
                                    return Text('Error: ${snapshot.error}');
                                  }
                                    
                                  return _dropdownUsuario(snapshot.data!);
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _dropdownTiempo(),
                              _dropdownTipo()
                            ]
                          ),
                          TextButton(
                            onPressed: (){
                              if((_selectedItemUsuario == null)||(_selectedItemTiempo == null)||(_selectedItemTipo == null)){
                                _showMyDialog(context);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Charts(referenceId: _selectedItemUsuario!, meses:  _selectedItemTiempo!, tipoEjercicio: _selectedItemTipo!)
                                  )
                                );
                              }
                              
                            }, child: Text("Ver datos")
                          )
                        ]
                      ),
                    ],
                  ),
                ],
              )),
        )
    );
  }
}