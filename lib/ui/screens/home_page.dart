// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/admin.dart';
import '../../models/firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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

  List<DropdownMenuItem<String>> getDropdownItems(){
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text('Pedro'),value: 'q4nyjBKcUKglnrvobR4pqfGmQpm2'),
      DropdownMenuItem(child: Text('Ejemplo1'),value: '1'),
      DropdownMenuItem(child: Text('Ejemplo2'),value: '2'),
    ];
    return menuItems;
  }

  final list = FirestoreHelper().getAlumnos();
  
  String dropdownValue = "";

  List<DropdownMenuItem<String>> _createList() {
    return list
        .map<DropdownMenuItem<String>>(
          (e) => DropdownMenuItem(
            value: e.referenceId,
            child: Text(e.nombre),
          ),
        )
        .toList();
  }

  String? _selectedItem;
  Widget _withHint() {
    final dropdown = DropdownButton(
      items: _createList(),
      hint: Text("Choose an item"),
      value: _selectedItem,
      onChanged: (String? value) => setState(() {
        _selectedItem = value ?? "";
      }),
    );
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
                            _withHint()
                            //TextButton(onPressed: onPressed, child: child)
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