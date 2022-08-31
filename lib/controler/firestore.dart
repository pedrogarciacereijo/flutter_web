// Import the firebase_core and cloud_firestore plugin
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Import the models
import '../models/admin.dart';
import '../models/ejercicio.dart';
import '../models/usuario.dart';

class FirestoreHelper{
  // Create a CollectionReference called admins that references the firestore collection
  final CollectionReference admins = FirebaseFirestore.instance.collection('admins');

  // Create a CollectionReference called users that references the firestore collection
  final CollectionReference users = FirebaseFirestore.instance.collection('usuarios');

  // Create a CollectionReference called ejercicios that references the firestore collection
  final CollectionReference ejercicios = FirebaseFirestore.instance.collection('ejercicios');

  // Create a FirebaseAuth called auth that references the firebaseAuth instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  

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
    List<dynamic> listaCorreos = [];
    List<dynamic> alumnosMap = [];
    List<Usuario> listaAlumnos = [];
    
    final uid = (FirebaseAuth.instance.currentUser)?.uid;

    print("Buscando alumnos pertenecientes a al profesor" );
    
    await admins.where('referenceId', isEqualTo: uid).limit(1).get().then((QuerySnapshot querySnapshot) {
      print('El profesor existe en la base de datos');
      for (var doc in querySnapshot.docs) {
        listaCorreos = doc.get('alumnos');
        
        print("Lista de correos de alumnos bajo supervisión del profesor actual:");
        
        for (var correo in listaCorreos){
          print(correo.toString());
        } 
        
      } 
    });
    for (var correo in listaCorreos){
          await users.where('email', isEqualTo: correo).limit(1).get().then((QuerySnapshot querySnapshot) {
            print('El alumno con correo ' + correo + ' existe en la base de datos');
            for (var doc in querySnapshot.docs) {
              Usuario alumno = convertAlumno(doc.data());
              print(alumno.toString());
              listaAlumnos.add(alumno);
            } 
          });
    }
    

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

  Future<List<Ejercicio>> getEjerciciosParametros(String referenceId, String tipoEjercicio, int tiempoMeses) async {
    List<Ejercicio> listaEjercicios = [];
    Ejercicio ejercicio;

    var now = new DateTime.now();
    var prevMonth = new DateTime(now.year, now.month - tiempoMeses, now.day);
    print(prevMonth.toString());

    if(tipoEjercicio == ''){
      await ejercicios.where('idUsuario', isEqualTo: referenceId)
          .where('dateFin', isGreaterThan: prevMonth)
          .orderBy('dateFin')
          .get().then((QuerySnapshot querySnapshot) {
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
    } else {
      await ejercicios.where('idUsuario', isEqualTo: referenceId)
          .where('tipoEjercicio', isEqualTo: tipoEjercicio)
          /*.where('dateFin', isGreaterThanOrEqualTo: prevMonth)*/
          .get().then((QuerySnapshot querySnapshot) {
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
    }
    

    return listaEjercicios;
  }


}
