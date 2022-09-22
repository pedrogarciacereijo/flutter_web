import 'package:flutter/material.dart';
import 'package:flutter_web/controler/authentication.dart';
import 'package:flutter_web/controler/firestore.dart';

import '../../../controler/firestore.dart';
import '../../../textos.dart';
import '../vistas/home_page.dart';

class RegistrarseScreen extends StatefulWidget {
  @override
  _RegistrarseScreenState createState() => _RegistrarseScreenState();
}

class _RegistrarseScreenState extends State<RegistrarseScreen>{
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            return _webUsersView(context);
          } else {
            return _mobileUsersView(context);
          }
        }
    );
  }

  Widget _webUsersView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Row(children: [
                Expanded(flex: 1, child: Container(color: Colors.transparent)),
                Expanded(flex: 3, child: Container(
                  decoration: BoxDecoration(
                    color: Colores.colorPrincipal,
                    borderRadius: BorderRadius.all(Radius.circular(60)),
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
                    SizedBox(height: 48.0),
                    mensaje(),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        Expanded(flex: 3, child: email()),
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                      ]
                    ),
                    SizedBox(height: 24.0),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        Expanded(flex: 3, child: password()),
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                      ]
                    ),
                    SizedBox(height: 12.0),
                    registrarseButton(),
                    iniciarSesionLabel()
                    ]),
                )),
                Expanded(flex: 1, child: Container(color: Colors.transparent)),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _mobileUsersView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 48.0),
                mensaje(),
                SizedBox(height: 16.0),
                email(),
                SizedBox(height: 24.0),
                password(),
                SizedBox(height: 12.0),
                registrarseButton(),
                iniciarSesionLabel()
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget mensaje(){
    return Text(
      Textos.registrarse,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20
      )
    );
  }

  Widget email(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.black,
          ), // icon is 48px widget.
        ),
        filled: true,
        fillColor: Colors.white, 
        hintStyle: TextStyle(
          color: Colors.black,
        ),
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Widget password(){
    return TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _password,
      //validator: Validator.validatePassword,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.black,
          ), // icon is 48px widget.
        ),
        filled: true,
        fillColor: Colors.white, 
        hintStyle: TextStyle(
          color: Colors.black,
        ), // icon is 48px widget.
        hintText: 'Contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  Widget registrarseButton(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
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
          adminAutorizadoRegistro();
        },
        child: Text('REGISTRARSE', style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget iniciarSesionLabel(){
    return TextButton(
      child: Text(
        'Si ya tienes una cuenta, inicia sesión',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/iniciarSesion');
      },
    );
  }

  void adminAutorizadoRegistro() async{
    bool aux = await FirestoreHelper().comprobarAdminAutorizado(_email.text);
    print(aux);
    if(aux){
      AuthenticationHelper().registrarse(email: _email.text, password: _password.text).then((result) {
        if (result == null) {
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              result,
              style: TextStyle(fontSize: 16),
            ),
          ));
        }
      });
          
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Este administrador no está autorizado para registrarse. Para crear una cuenta, necesitas que un superadministrador te dé de alta anteriormente",
            style: TextStyle(fontSize: 16),
          ),
        ));
      }
  }


}