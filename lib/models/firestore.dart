// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web/models/usuario.dart';
//Import the Admin model
import '../models/admin.dart';

class FirestoreHelper{
  // Create a CollectionReference called admins that references the firestore collection
  final CollectionReference admins = FirebaseFirestore.instance.collection('admins');

  // Create a CollectionReference called ejercicios that references the firestore collection
  final CollectionReference ejercicios = FirebaseFirestore.instance.collection('ejercicios');

  Stream<QuerySnapshot> getStream() {
    return admins.snapshots();
  }

  Future<void> addAdmin(Admin admin) {
    // Call the user's CollectionReference to add a new user
    return admins.doc((FirebaseAuth.instance.currentUser)?.uid).set(admin.toJson())
        .then((value) => print("Admin añadido"))
        .catchError((error) => print("Error al añadir admin: $error"));

  }

  List<Usuario> getAlumnos(){
    List<Usuario> listaAlumnos = [];
    List<dynamic> alumnosMap = [];
    admins.doc((FirebaseAuth.instance.currentUser)?.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        print('Document exists on the database');
        alumnosMap = data['alumnos'];
        listaAlumnos = convertAlumnos(alumnosMap);
      }
    });
    return listaAlumnos;

  }


}
