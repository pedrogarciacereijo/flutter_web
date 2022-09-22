import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_web/ui/screens/vistas/aboutUs.dart';

import 'controler/authentication.dart';
import 'textos.dart';
import 'ui/screens/autenticacion/iniciarSesion.dart';

  buildButtonCerrarSesion(BuildContext context) {
    return ElevatedButton(
      child: Text("Cerrar sesión"),
      onPressed: () {_cerrarSesion(context);}, 
      style: ElevatedButton.styleFrom(
        primary: Colors.redAccent,
        shape: RoundedRectangleBorder( //to set border radius to button
            borderRadius: BorderRadius.circular(0),
        ),
      )
    
    );
    
  }

  buildButtonCerrarSesionMobile(BuildContext context) {
    return ElevatedButton(
      child: Column(children: [
        Text("Cerrar"),
        Text("sesión")
      ]),
      onPressed: () {_cerrarSesion(context);}, 
      style: ElevatedButton.styleFrom(
        primary: Colors.redAccent,
        shape: RoundedRectangleBorder( //to set border radius to button
            borderRadius: BorderRadius.circular(0),
        ),
      )
    
    );
    
  }

  void _cerrarSesion(BuildContext context) {
    AuthenticationHelper().cerrarSesion();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => IniciarSesionScreen(),
      ),
    );
  }

  buildButtonAboutUs(BuildContext context) {
    return ElevatedButton(
      child: Text("Sobre nosotros"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => AboutUs(),
          ),
        );
      }, 
      style: ElevatedButton.styleFrom(
        primary: Colores.colorPrincipal,
        shape: RoundedRectangleBorder( //to set border radius to button
            borderRadius: BorderRadius.circular(0),
        ),
      )
    );
  }

  buildButtonAboutUsMobile(BuildContext context) {
    return ElevatedButton(
      child: Column(children: [
        Text("Sobre"),
        Text("nosotros")
      ]),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => AboutUs(),
          ),
        );
      }, 
      style: ElevatedButton.styleFrom(
        primary: Colores.colorPrincipal,
        shape: RoundedRectangleBorder( //to set border radius to button
            borderRadius: BorderRadius.circular(0),
        ),
      )
    );
  }


  
