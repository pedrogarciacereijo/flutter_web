
import 'package:flutter/material.dart';
import 'package:flutter_web/models/ejercicio.dart';
import 'package:flutter_web/ui/screens/graficos/pdf.dart';
import 'package:flutter_web/models/usuario.dart';

import '../../../controler/authentication.dart';
import '../../../controler/firestore.dart';
import '../../../textos.dart';
import '../../../widgets.dart';
import '../autenticacion/iniciarSesion.dart';
import '../graficos/charts.dart';

class VistaAlumno extends StatefulWidget {
  final Usuario alumno;

  const VistaAlumno({Key? key, required this.alumno}) : super(key: key);
  
  @override
  _VistaAlumnoState createState() => _VistaAlumnoState();
}

class _VistaAlumnoState extends State<VistaAlumno> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            return _webUsersView();
          } else {
            return _mobileUsersView();
          }
        }
    );
  }

  Widget _webUsersView(){
    return Scaffold(
      appBar: AppBar(
        title: Text(Textos.nombreAplicacion, style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: [
          buildButtonAboutUs(context),
          buildButtonCerrarSesion(context)
        ],
      ),
      body: Container(
        color: Colors.white,
        
        child: Row(
          children: [
            Expanded(flex: 1, child: Container(color: Colors.transparent)),
            Expanded(
              flex: 10,
              child: Column(children: [
                Expanded(flex: 1, child: Container(color: Colors.transparent)),
                Expanded(flex: 10, child: 
                    Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colores.colorPrincipal,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                      ),
                      child: Column(children: [
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        Expanded(flex: 2, child: SingleChildScrollView(
                          child: buildDatos(widget.alumno),
                        )),
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        Expanded(flex: 2, child: Row(children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Expanded(flex: 2, child: 
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                            child: _dropdownTiempo())
                          ),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        ]),),
                        Expanded(flex: 2, child: Row(children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Expanded(flex: 2, child: 
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                            child: _dropdownTipo())
                          ),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        ]),),
                        Expanded(flex: 2, child: Row(children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Expanded(flex: 2, child: 
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                            child: _dropdownDificultad())
                          ),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          
                        ]),),
                        Expanded(flex: 2, child: Row(children: [
                            Expanded(flex: 1, child: Container(color: Colors.transparent)),
                            Expanded(flex: 1, child: 
                              buildDescargarInforme(),
                            ),
                            Expanded(flex: 1, child: 
                              buildVerGraficas(),
                            ),
                            Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          ]),),
                        Expanded(flex: 2, child: Container(color: Colors.transparent)),
                      

                      ]),
                    )
                  ),
                ),
                
                Expanded(flex: 1, child: Container(color: Colors.transparent)),
              ],)
            ),
            Expanded(flex: 1, child: Container(color: Colors.transparent)),
          ], 
        )
      ),
    );
  }

  Widget _mobileUsersView(){
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(Textos.nombreAplicacion1, style: TextStyle(color: Colors.black)),
            Text(Textos.nombreAplicacion2, style: TextStyle(color: Colors.black))
          ],
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white70,
        actions: [
          buildButtonAboutUsMobile(context),
          buildButtonCerrarSesionMobile(context)
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(flex: 1, child: Container(color: Colors.transparent)),
            Expanded(
              flex: 10,
              child: Column(children: [
                Expanded(flex: 1, child: Container(color: Colors.transparent)),
                Expanded(flex: 10, child: 
                    Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colores.colorPrincipal,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(children: [
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        Expanded(flex: 3, child: SingleChildScrollView(
                          child: buildDatos(widget.alumno),
                        )),
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        Expanded(flex: 2, child: Row(children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Expanded(flex: 3, child: 
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                            child: _dropdownTiempo())
                          ),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        ]),),
                        Expanded(flex: 2, child: Row(children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Expanded(flex: 3, child: 
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                            child: _dropdownTipo())
                          ),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        ]),),
                        Expanded(flex: 2, child: Row(children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Expanded(flex: 3, child: 
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                            child: _dropdownDificultad())
                          ),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          
                        ]),),
                        Expanded(flex: 2, child: Row(children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Expanded(flex: 3, child: 
                              buildDescargarInforme(),
                            ),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          
                        ]),),
                        Expanded(flex: 2, child: Row(children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Expanded(flex: 3, child: 
                              buildVerGraficas(),
                            ),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          
                        ]),),
                        Expanded(flex: 2, child: Container(color: Colors.transparent)),
                      

                      ]),
                    )
                  ),
                ),
                
                Expanded(flex: 1, child: Container(color: Colors.transparent)),
              ],)
            ),
            Expanded(flex: 1, child: Container(color: Colors.transparent)),
          ], 
        )
      ),
    );
  }

  Widget buildDatos(Usuario alumno){
      return Column(
        children: [
          Text(
            alumno.nombre + " " + alumno.apellidos,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Text(
            alumno.email,
            style: TextStyle(color: Colors.white),
          )
        ],
      );
  }

  Widget buildVerGraficas(){
    return ElevatedButton(
      child: Text('Ver grafica de resultados', style: TextStyle(color: Colors.black)),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.black)
              )
          )
      ),
      onPressed: () {
        if((_selectedItemDificultad == null)||(_selectedItemTiempo == null)||(_selectedItemTipo == null)){
          _showMyDialog(context);
        } else {
          Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Charts(alumno: widget.alumno, meses: _selectedItemTiempo!, tipoEjercicio: _selectedItemTipo!, dificultad: _selectedItemDificultad!,)));
        }
      },
    );
  }

  Widget buildDescargarInforme() {
    return ElevatedButton(
      child: Text('Descargar informe de resultados', style: TextStyle(color: Colors.black),),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.black)
              )
          )
      ),
      onPressed: () async {
        if((_selectedItemDificultad == null)||(_selectedItemTiempo == null)||(_selectedItemTipo == null)){
          _showMyDialog(context);
        } else {
          List<Ejercicio> data = await FirestoreHelper().getEjerciciosParametros(widget.alumno, _selectedItemTipo!, _selectedItemTiempo!, _selectedItemDificultad!);
          if(data.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                duration: Duration(milliseconds: 2000),
                content: Text('El usuario no ha realizado ejercicios que cumplan con las características deseadas'),
              )
            );
          }else{
            Pdf(widget.alumno, data, _selectedItemTiempo!, _selectedItemTipo!, _selectedItemDificultad!).generatePDF();
          }
          
        }
      },
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
      ),
      DropdownMenuItem(
          value: 12,
          child: Text('Últimos 12 meses'),
      )
    ];
    final dropdown = DropdownButton(
      isExpanded: true,
      items: items,
      hint: Text("Elige el tiempo"),
      value: _selectedItemTiempo,
      onChanged: (int? value) => setState(() {
        _selectedItemTiempo = value ?? 1;
      }),
    );
    return dropdown;
  }

  String? _selectedItemDificultad;
  Widget _dropdownDificultad(){
    List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(
          value: 'Fácil',
          child: Text('Fácil'),
      ),
      DropdownMenuItem(
          value: 'Normal',
          child: Text('Normal'),
      ),
      DropdownMenuItem(
          value: 'Díficil',
          child: Text('Díficil'),
      )
    ];
    final dropdown = DropdownButton(
      isExpanded: true,
      items: items,
      hint: Text("Elige la dificultad"),
      value: _selectedItemDificultad,
      onChanged: (String? value) => setState(() {
        _selectedItemDificultad = value ?? "";
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
      isExpanded: true,
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
  
}
