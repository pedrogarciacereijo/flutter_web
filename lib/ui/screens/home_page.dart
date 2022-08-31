// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/models/usuario.dart';
import 'package:flutter_web/ui/screens/vistaAlumnos.dart';

import '../../models/admin.dart';
import '../../controler/firestore.dart';
import '../../textos.dart';
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

  Widget _alumnoListTile(Usuario alumno){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        color: Colors.white10,
        child: ListTile(
          contentPadding: EdgeInsets.all(5),
          dense: true,
          onTap: () async {

          },
          //leading: Icon.user,
          title: Text(
            alumno.nombre + " " + alumno.apellidos,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(alumno.apellidos),
        ),
      ),
    );
  }
  
  List<Widget> _createList(List<Usuario> list){
    print("Creating List");
    
    List<Widget> result = [];
    for (var alumno in list){
      result.add(
        _alumnoListTile(alumno)
      ) ;
      print(alumno.toJson());
    }
    print('Lista de alumnos creada');
    return result;
  }

  Widget _vistaAlumnos(List<Usuario> list){
    List<Widget> items = _createList(list);
    return Scaffold(
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: items
        )
      ),
    );
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

  int? _selectedItemDificultad;
  Widget _dropdownDificultad(){
    List<DropdownMenuItem<int>> items = [
      DropdownMenuItem(
          value: 1,
          child: Text('Fácil'),
      ),
      DropdownMenuItem(
          value: 3,
          child: Text('Normal'),
      ),
      DropdownMenuItem(
          value: 6,
          child: Text('Díficil'),
      )
    ];
    final dropdown = DropdownButton(
      items: items,
      hint: Text("Elige la dificultad"),
      value: _selectedItemDificultad,
      onChanged: (int? value) => setState(() {
        _selectedItemDificultad = value ?? 1;
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
          Text("Elige una dificultad, un periodo de tiempo y un ejercicio antes de continuar"),
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

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueGrey, Colors.blueGrey.shade900],
              stops: [0.8, 1.0]),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Text(Textos.mensajeBienvenida ),
                  )
              )
            ),
            Expanded(
              flex: 1,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: FutureBuilder<List<Usuario>>(
                              future: data,
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Center(child: Text('Press button to start.'),);
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    return Center(child: Text('Awaiting result...'),);
                                  case ConnectionState.done:
                                    if (snapshot.hasError){
                                      return Center(child: Text('Error: ${snapshot.error}'));
                                    }
                                      
                                    return _vistaAlumnos(snapshot.data!);
                                }
                              }, 
                    ),
                  )
              )
            )
          ], 
        )
      );
  }
}