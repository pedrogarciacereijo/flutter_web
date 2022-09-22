import 'package:flutter/material.dart';
import 'package:flutter_web/controler/authentication.dart';
import 'package:flutter_web/ui/screens/autenticacion/iniciarSesion.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/usuario.dart';
import '../../../controler/firestore.dart';
import '../../../textos.dart';
import '../../../widgets.dart';


class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {



  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            return Scaffold(
              appBar: _webUsersAppBar(),
              body: _body(),
            );
          } else {
            return Scaffold(
              appBar: _mobileUsersAppBar(),
              body: _body(),
            );
          }
        }
    );
  }

  AppBar _webUsersAppBar(){
    return AppBar(
      title: Text(Textos.nombreAplicacion, style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white70,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      actions: [
        buildButtonCerrarSesion(context)
      ],
    );
  }

  AppBar _mobileUsersAppBar(){
    return AppBar(
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
        buildButtonCerrarSesion(context)
      ],
    );
  }

  Widget _body(){
    return Container(
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
                    child:  Row(children: [
                      Expanded(flex: 1, child: Container(color: Colors.transparent)),
                      Expanded(flex: 2, child: SingleChildScrollView(
                        child: Center(child: Text(
                          Textos.mensajeAboutUs,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          )
                        )
                      ))),
                      Expanded(flex: 1, child: Container(color: Colors.transparent)),
                      Expanded(flex: 2, child: SingleChildScrollView(
                        child: Center(child: Text(
                          Textos.mensajeAboutUs2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          )
                        )
                      ))),
                      Expanded(flex: 1, 
                        child: Column(children: [
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          Expanded(flex: 1, child: Icon(
                            FontAwesomeIcons.twitter, color: Colors.white,
                          )),
                          Expanded(flex: 1, child: Icon(
                            Icons.phone, color: Colors.white,
                          )),
                          Expanded(flex: 1, child: Icon(
                            Icons.email, color: Colors.white,
                          )),
                          Expanded(flex: 1, child: Icon(
                            Icons.map, color: Colors.white,
                          )),
                          Expanded(flex: 1, child: Container(color: Colors.transparent)),
                          
                        ],)
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
    );
  }
  
}