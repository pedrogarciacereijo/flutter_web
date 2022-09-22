import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_web/models/usuario.dart';
import 'package:flutter_web/controler/firestore.dart';
import 'package:flutter_web/textos.dart';
import 'package:flutter_web/widgets.dart';
import 'vista_usuario.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final Future<List<Usuario>> data;
  late final String admin;

  // Esta lista contiene los datos de los usuarios que serán mostrados al filtrar
  List<Usuario> _foundUsers = [];

  @override
  initState() {
    super.initState();
    data = loadData();
    admin = (FirebaseAuth.instance.currentUser)?.email ?? "";

  }
 
  Future<List<Usuario>> loadData() async{
    List<Usuario> list = await FirestoreHelper().getAlumnos();
    _foundUsers = list;
    return list;
  }


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
        actions: [
          Align(
            alignment: Alignment.center,
            child: Text("Bienvenido "+ admin + "   ", textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
          ),
          buildButtonAboutUs(context),
          buildButtonCerrarSesion(context)
        ],
      ),
      body: Container(
        color: Colors.white60,
        
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
                      child: Column(
                        children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Row(children: [
                            Expanded(flex: 1, child: Container(color: Colors.transparent)),
                            Expanded(flex: 1, child: 
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.all(Radius.circular(60))
                                ),
                                child: _buildSearchBar()
                              )
                            ),
                            Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          ]),
                          Expanded(
                            flex: 10,
                            child: Container(
                              child: FutureBuilder<List<Usuario>>(
                                      future: data,
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                            return Center(child: Text('Press button to start.'),);
                                          case ConnectionState.active:
                                          case ConnectionState.waiting:
                                            return Center(child: CircularProgressIndicator(),);
                                          case ConnectionState.done:
                                            if (snapshot.hasError){
                                              return Center(child: Text('Error: ${snapshot.error}'));
                                            }
                                            
                                            return _buildVistaAlumnos(_foundUsers);
                                        }
                                      }, 
                              ),
                            ) 
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(color: Colors.transparent, child: _buildButtonAddAlumno(),)
                          ),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        ],
                      ),
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
        backgroundColor: Colors.white70,
        actions: [
          buildButtonAboutUsMobile(context),
          buildButtonCerrarSesionMobile(context)
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
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
                        Flexible(
                          child: Container(
                            color: Colors.white,

                            child: _buildSearchBar()
                          ),
                        ),
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        Expanded(
                          flex: 10,
                          child: FutureBuilder<List<Usuario>>(
                            future: data,
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return Center(child: Text('Press button to start.'),);
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                  return Center(child: CircularProgressIndicator(),);
                                case ConnectionState.done:
                                  if (snapshot.hasError){
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  }
                                  
                                  return _buildVistaAlumnos(_foundUsers);
                              }
                            }, 
                          ),
                        ),
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        Expanded(
                          flex: 1,
                          child: Container(color: Colors.transparent, child: _buildButtonAddAlumno(),)
                        ),
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                      

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
      )
    );           
  }


  _buildSearchBar() {
    return TextField(
      textAlign: TextAlign.center,
      onChanged: (value) => _runFilter(value),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Búsqueda por nombre', 
        suffixIcon: Icon(Icons.search)
      ),
    );
  }

  // esta función se llama cada vez que se cambia el texto a filtrar
  Future<void> _runFilter(String enteredKeyword) async{
    List<Usuario> results = [];
    if (enteredKeyword.isEmpty) {
      // si el campo de búsqueda está vacío, se muestran todos los usuarios
      results = await data;
    } else {
      results = await data;
      results = results
          .where((user) =>
              user.nombre.toLowerCase().contains(enteredKeyword.toLowerCase()) || 
              user.apellidos.toLowerCase().contains(enteredKeyword.toLowerCase())
          )
          .toList();
      // se usa toLowerCase para hacerlo case-sensitive
    }

    // Se refresca la UI
    setState(() {
      _foundUsers = results;
    });
  }

  Widget _alumnoListTile(Usuario alumno){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(5),
          dense: true,
          onTap: () async {

          },
          title: Text(
            alumno.nombre + " " + alumno.apellidos,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(alumno.email),
          trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VistaAlumno(alumno: alumno)),
                  );
                }, icon: const Icon(Icons.visibility), tooltip: "Ver datos"),
                IconButton(onPressed: () {
                    _showDeleteDialog(context, alumno);
                }, icon: const Icon(Icons.delete), tooltip: "Eliminar usuario"),
              ],
            ),
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

  Widget _buildVistaAlumnos(List<Usuario> list){
    List<Widget> items = _createList(list);
    return Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: items
        )
    );
  }

  _buildButtonAddAlumno(){
    return ElevatedButton(
      child: Text("Crear nuevo usuario", style: TextStyle(color: Colors.black)),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: Colors.black)
              )
          )
      ),
      onPressed: () {_showAddUserDialog(context);}
    );
  }

  Future<void> _showAddUserDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => _buildAddDialog(),
    );
  }

  Widget _buildAddDialog() {
    return AlertDialog(
      title: Center(child: Text("Crea un nuevo alumno")),
      content:
          _buildAddUsuario(),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent
            ),
            child: Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
        }),
        ElevatedButton(
          child: Text("Aceptar"),
          onPressed: () {
            addAlumno(_nombre.text, _apellidos.text, _email.text);
          }
        ),
        
      ],
    );
  }

  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _apellidos = TextEditingController();
  final TextEditingController _email = TextEditingController();

  _buildAddUsuario() {
    return Container(
      child: SingleChildScrollView(
        child: Column(children: [
          Row(children: [
            Expanded(flex: 2, child:  Center(child: Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold)))),
            Expanded(flex: 2, child: TextField(controller: _nombre,))
          ],),
          Row(children: [
            Expanded(flex: 2, child:  Center(child: Text("Apellidos", style: TextStyle(fontWeight: FontWeight.bold)))),
            Expanded(flex: 2, child: TextField(controller: _apellidos,))
          ],),
          Row(children: [
            Expanded(flex: 2, child:  Center(child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold)))),
            Expanded(flex: 2, child: TextField(controller: _email,))
          ],),
          
        ]),
      )
    );
  }

  void addAlumno(String nombre, String apellidos, String email) async{
    if((nombre.isEmpty)||(apellidos == "")||(email == "")){
      _showMyDialog(context);
    }else{
      Usuario alumno = Usuario(nombre, apellidos, email);
      bool aux = await FirestoreHelper().addUsuario(alumno);
      if(aux){
        setState(() {
          _foundUsers.add(alumno);
        });
        _runFilter("");
        Navigator.of(context).pop();
      }else{
        Navigator.of(context).pop();
        _showErrorDialog(context);
      }
    }

  }

  void deleteAlumno(Usuario alumno) async{
    bool aux = await FirestoreHelper().deleteUsuario(alumno);
    if(aux){
      setState(() {
        _foundUsers.remove(alumno);
      });
      _runFilter("");
      Navigator.of(context).pop();
    }else{
      Navigator.of(context).pop();
      _showErrorDialog(context);
    }
    
  }

  Future<void> _showDeleteDialog(BuildContext context, Usuario alumno) async {
    return showDialog<void>(
      context: context,
      builder: (_) => _buildDeleteDialog(alumno),
    );
  }

  Widget _buildDeleteDialog(Usuario alumno) {
    return AlertDialog(
      title: Center(child: Text("¿Estás seguro de que deseas eliminar el usuario ?")),
      content:
          Text("El usuario "+ alumno.nombre + " "+ alumno.apellidos +" y todos sus datos serán eliminados y no habrá vuelta atrás"),
      actions: <Widget>[
        ElevatedButton(
            child: Text("Cancelar"),
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent
            ),
            onPressed: () {
              Navigator.of(context).pop();
        }),
        ElevatedButton(
          child: Text("Aceptar"),
          onPressed: () {
            deleteAlumno(alumno);
          }
        ),
        
      ],
    );
  }

  Future<void> _showErrorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => _buildErrorDialog(),
    );
  }

  Widget _buildErrorDialog() {
    return AlertDialog(
      title: Center(child: Text("Ha ocurrido un error")),
      content:
          Text("Comprueba que todos los datos de la operación están correctos e inténtalo de nuevo, o ponte en contacto con nosotros para que lo solucionemos"),
      actions: <Widget>[
        ElevatedButton(
            child: Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();
        }),

      ],
    );
  }

  Widget _buildAlertDialog() {
    return AlertDialog(
      title: Text('Faltan datos'),
      content:
          Text("Comprueba los datos antes de continuar"),
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