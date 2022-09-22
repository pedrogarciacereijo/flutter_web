import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web/textos.dart';

import '../../../controler/authentication.dart';

class RecuperarPassword extends StatelessWidget {
  final TextEditingController _email = TextEditingController();

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

  Widget _mobileUsersView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child:Column(children: [
                    SizedBox(height: 72.0),
                    mensaje(),
                    SizedBox(height: 16.0),
                    email(),
                    SizedBox(height: 36.0),
                    recuperarPasswordButton(context),
                    iniciarSesionLabel(context)
                  ]),
                ),
              ),
            ),
          ),
      );
  }

  @override
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
                    SizedBox(height: 72.0),
                    mensaje(),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                        Expanded(flex: 3, child: email()),
                        Expanded(flex: 1, child: Container(color: Colors.transparent)),
                      ]
                    ),
                    SizedBox(height: 36.0),
                    recuperarPasswordButton(context),
                    iniciarSesionLabel(context)
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

  Widget mensaje(){
    return Text(
      Textos.recuperarPass,
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

  void _recuperarPassword({required String email, required BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    try {
      await AuthenticationHelper().recuperarPassword(email);
      Flushbar(
        title: "Correo enviado",
        message:
        'Sigue las instrucciones del correo para recuperar tu contraseña',
        duration: Duration(seconds: 20),
      ).show(context);
    } catch (e) {
      print("Forgot Password Error: $e");
      String exception = AuthenticationHelper().getExceptionText(e as Exception);
      Flushbar(
        title: "Error",
        message: exception,
        duration: Duration(seconds: 10),
      ).show(context);
    }
  }

  Widget recuperarPasswordButton(BuildContext context){
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
          _recuperarPassword(email: _email.text, context: context);
        },
        child: Text('RECUPERAR CONTRASEÑA', style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget iniciarSesionLabel(BuildContext context){
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

}