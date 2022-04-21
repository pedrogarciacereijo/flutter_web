// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web/models/usuario.dart';
//Import the Admin model
import '../models/admin.dart';
import 'ejercicio.dart';

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

  Future<List<Usuario>> getAlumnos() async{
    List<Usuario> listaAlumnos = [];
    List<dynamic> alumnosMap = [];
    admins.doc((FirebaseAuth.instance.currentUser)?.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        print('Document exists on the database');
        alumnosMap = data['alumnos'];
        listaAlumnos = convertAlumnos(alumnosMap);
        for (var alumno in listaAlumnos){
          print(alumno.toString());
        }
      }
    });
    return listaAlumnos;

  }

  Future<List<Ejercicio>> getEjercicios(String referenceId) async {
    List<Ejercicio> listaEjercicios = [];
    Ejercicio ejercicio;
    await ejercicios.where('idUsuario', isEqualTo: referenceId).get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
            print(doc.id);
            ejercicio = Ejercicio(doc.get('idUsuario'), 
                    dateInicio: DateTime.parse(doc.get('dateInicio').toDate().toString()), dateFin: DateTime.parse(doc.get('dateFin').toDate().toString()), 
                    tipoEjercicio: doc.get('tipoEjercicio'), dificultad: doc.get('dificultad'),
                    errores: doc.get('errores'), aciertos: doc.get('aciertos'), letrasCorrectas: doc.get('letrasCorrectas'));

            print("Ejercicio " + ejercicio.idUsuario + 
            ejercicio.dateInicio.toString() + ejercicio.dateFin.toString() + 
            ejercicio.tipoEjercicio + ejercicio.dificultad! + ejercicio.errores.toString() + ejercicio.aciertos.toString() + ejercicio.letrasCorrectas.toString());
            listaEjercicios.add(ejercicio);
        }
    });

    return listaEjercicios;
  }


}
