import 'package:flutter/material.dart';
import 'package:flutter_web/textos.dart';

import '../../../controler/authentication.dart';
import '../../../controler/firestore.dart';


class IniciarSesionScreen extends StatefulWidget {
  @override
  _IniciarSesionScreenState createState() => _IniciarSesionScreenState();
}

class _IniciarSesionScreenState extends State<IniciarSesionScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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

  Widget _mobileUsersView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(children: [
                        SizedBox(height: 24.0),
                        tituloMobile(),
                        SizedBox(height: 24.0),
                        email(),
                        SizedBox(height: 24.0),
                        password(),
                        SizedBox(height: 12.0),
                        loginButton(),
                        forgotLabel(),
                        signUpLabel()
                  ]),
                ),
              ),
            ),
          ),
      );
  }

  @override
  Widget _webUsersView() {

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
                        SizedBox(height: 24.0),
                        titulo(),
                        SizedBox(height: 24.0),
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
                        loginButton(),
                        forgotLabel(),
                        signUpLabel()
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

  Widget titulo(){
    return Text(
      Textos.nombreAplicacion,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 40
      )
    );
  }

  Widget tituloMobile(){
    return Text(
      Textos.nombreAplicacion,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 40
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

  Widget loginButton(){
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
          comprobarSuperadmin();
        },
        child: Text('INICIAR SESIÓN', style: TextStyle(color: Colors.black)),
      ),
    );
  }
  
  Widget forgotLabel(){
    return TextButton(
      child: Text(
        '¿Olvidaste tu contraseña?',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/recuperarPassword');
      },
    );
  }
   

  Widget signUpLabel(){
    return TextButton(
      child: Text(
        'Crea una cuenta',
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/registrarse');
      },
    );
  }

  void adminAutorizadoInicioSesion() async{
    bool aux = await FirestoreHelper().comprobarAdminAutorizado(_email.text);
    AuthenticationHelper().iniciarSesion(email: _email.text, password: _password.text).then((result){
      if (result == null) {
        print(aux);
        if (aux){
          Navigator.pushNamed(context, '/homePage');
        }else{
          AuthenticationHelper().cerrarSesion();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Este administrador no está autorizado para iniciar sesión. Si ya tenías una cuenta, es posible que el superadministrador te haya dado de baja",
            style: TextStyle(fontSize: 16),
          ),
        ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            result,
            style: TextStyle(fontSize: 16),
          ),
        ));
      }
    });
  }

  void comprobarSuperadmin() async{
      bool aux = await FirestoreHelper().comprobarSuperadmin(_email.text);
      if(aux){
        AuthenticationHelper().iniciarSesion(email: _email.text, password: _password.text).then((result){
        if (result == null) {
          Navigator.pushNamed(context, '/vistaSuperadmin');
        } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            result,
            style: TextStyle(fontSize: 16),
          ),
        ));
      }
    });
      }else{
        adminAutorizadoInicioSesion();
      }
      
  }

}

