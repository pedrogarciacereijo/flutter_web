import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'ui/screens/home_page.dart';
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
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: IniciarSesionScreen(),
      initialRoute: '/iniciarSesion',
      routes: {
        '/homePage': (context) => HomePage(),
        '/iniciarSesion': (context) => IniciarSesionScreen(),
        '/registrarse': (context) => RegistrarseScreen(),
        '/recuperarPassword': (context) => RecuperarPassword(),
      },
    );
  }
}