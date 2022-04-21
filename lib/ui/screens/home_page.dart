// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/models/usuario.dart';

import '../../models/admin.dart';
import '../../models/firestore.dart';
import 'charts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Usuario>> _listaAlumnos;

  initState(){
    super.initState();
    _listaAlumnos = FirestoreHelper().getAlumnos();
  }

  DateTime pre_backpress = DateTime.now();

  Future<bool> onWillPop() async{
    final timegap = DateTime.now().difference(pre_backpress);
    final cantExit = timegap >= Duration(seconds: 2);
    pre_backpress = DateTime.now();
    if(cantExit){
      //show snackbar
      final snack = SnackBar(content: Text('Press Back button again to Exit'),duration: Duration(seconds: 2),);
      ScaffoldMessenger.of(context).showSnackBar(snack);
      return false; // false will do nothing when back press
    }else{
      SystemNavigator.pop();
      return true;   // true will exit the app
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
    return result;
  }

  List<DropdownMenuItem<String>> getDropdownItems(){
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text('Pedro'),value: 'q4nyjBKcUKglnrvobR4pqfGmQpm2'),
      DropdownMenuItem(child: Text('Ejemplo1'),value: '1'),
      DropdownMenuItem(child: Text('Ejemplo2'),value: '2'),
    ];
    return menuItems;
  }

  String? _selectedItem;
  Widget _withHint(List<Usuario> list){
    List<DropdownMenuItem<String>> items = getDropdownItems();
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
                          FutureBuilder(
                            future: _listaAlumnos,
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<List<Usuario>> snapshot,
                            ) {
                              if (snapshot.connectionState == ConnectionState.waiting) { 
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    Visibility(
                                      visible: snapshot.hasData,
                                      child: Text(
                                        "snapshot.data",
                                        style: const TextStyle(color: Colors.black, fontSize: 24),
                                      ),
                                    )
                                  ],
                                );
                              } else if (snapshot.connectionState == ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return const Text('Error');
                                } else if (snapshot.hasData) {
                                  return _withHint(snapshot.data!);
                                } else {
                                  return const Text('Empty data');
                                }
                              } else {
                                return Text('State: ${snapshot.connectionState}');
                              }
                            },
                          ),
                            
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Charts(referenceId: 'q4nyjBKcUKglnrvobR4pqfGmQpm2')
                                )
                              );
                              }, child: Text("Ver datos"))
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