import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web/ui/screens/vistas/vista_superadmin.dart';


import 'ui/screens/vistas/home_page.dart';
import 'ui/screens/autenticacion/iniciarSesion.dart';
import 'ui/screens/autenticacion/registrarse.dart';
import 'ui/screens/autenticacion/recuperarPassword.dart';



Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD30lFa5dk8U0_m6kJW2QBfw_gGaNYxDxU",
      appId: "1:937489487620:web:6ffb389632656953fe2251",
      messagingSenderId: "937489487620",
      projectId: "tfg-pedrogarciacereijo",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final appTitle = 'Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith( dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}, ),
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/iniciarSesion',
      routes: {
        '/iniciarSesion': (context) => IniciarSesionScreen(),
        '/homePage': (context) => HomePage(),
        '/vistaSuperadmin': (context) => VistaSuperadmin(),
        '/registrarse': (context) => RegistrarseScreen(),
        '/recuperarPassword': (context) => RecuperarPassword(),
      },
    );
  }
}