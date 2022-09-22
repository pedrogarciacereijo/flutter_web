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
  final CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');

  // Create a CollectionReference called ejercicios that references the firestore collection
  final CollectionReference ejercicios = FirebaseFirestore.instance.collection('ejercicios');

  // Create a CollectionReference called ejercicios that references the firestore collection
  final CollectionReference superadmins = FirebaseFirestore.instance.collection('superadmins');

  // Create a FirebaseAuth called auth that references the firebaseAuth instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  

  Stream<QuerySnapshot> getStream() {
    return admins.snapshots();
  }

  Future<bool> addAdmin(Admin admin) async{
    bool aux = false;

    await admins.doc(admin.email).get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists){
             print('El administrador ya existe en la base de datos');      
          }else{
            print('El administrador no existe en la base de datos');
            // Call the user's CollectionReference to add a new user
            await admins.doc(admin.email).set(admin.toJson())
                .then((value) async{
                  print("Admin añadido");
                  aux = true;
                })
                .catchError((error) => print("Error al añadir admin: $error"));
          }
    });
    print(aux);
    return aux;

  }

  Future<Admin> getAdmin() async{

    final email = (FirebaseAuth.instance.currentUser)?.email;
    Admin admin = Admin(email: email!, nombre: '', apellidos: '', alumnos: []);

    await admins.doc(email).get().then((DocumentSnapshot documentSnapshot) {
      Admin admin = convertAdmin(documentSnapshot.data());
    });
    return admin;
  }

  Future<List<Usuario>> getAlumnos() async{
    List<dynamic> listaEmails = [];
    List<dynamic> alumnosMap = [];
    List<Usuario> listaAlumnos = [];
    
    final email = (FirebaseAuth.instance.currentUser)?.email;

    print("Buscando alumnos pertenecientes a al profesor " + email!);
    
    await admins.where('email', isEqualTo: email).limit(1).get().then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);
      print('El profesor existe en la base de datos');
      for (var doc in querySnapshot.docs) {
        listaEmails = doc.get('alumnos');
        
        print("Lista de correos de alumnos bajo supervisión del profesor actual:");
        
        for (var email in listaEmails){
          print(email.toString());
        } 
        
      } 
    });
    for (var email in listaEmails){
          await usuarios.where('email', isEqualTo: email).limit(1).get().then((QuerySnapshot querySnapshot) {
            print('El alumno con correo ' + email + ' existe en la base de datos');
            for (var doc in querySnapshot.docs) {
              Usuario alumno = convertAlumno(doc.data());
              print(alumno.toString());
              listaAlumnos.add(alumno);
            } 
          });
    }
    return listaAlumnos;
  }

  Future<List<Admin>> getAdmins() async{
    List<dynamic> listaDocs = [];
    List<Admin> listaAdmins = [];

    print("Buscando admins");
    
    await admins.get().then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);
      for (var doc in querySnapshot.docs) {
        Admin admin = Admin(
          nombre: doc.get('nombre'),
          apellidos: doc.get('apellidos'),
          email: doc.get('email'),
          alumnos: List.from(doc.get('alumnos')),
        );
        listaAdmins.add(admin);
      } 
      print("Lista generada");
    });
    
    return listaAdmins;
  }
    

    


  Future<List<Ejercicio>> getEjercicios(Usuario alumno) async {
    List<Ejercicio> listaEjercicios = [];
    Ejercicio ejercicio;
    await ejercicios.where('idUsuario', isEqualTo: alumno.email).get().then((QuerySnapshot querySnapshot) {
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

  Future<List<Ejercicio>> getEjerciciosParametros(Usuario alumno, String tipoEjercicio, int tiempoMeses, String dificultad) async {
    List<Ejercicio> listaEjercicios = [];
    Ejercicio ejercicio;

    var now = DateTime.now();
    var prevMonth = DateTime(now.year, now.month - tiempoMeses, now.day);
    print(prevMonth.toString());

    
    await ejercicios.where('idUsuario', isEqualTo: alumno.email)
        .where('dateFin', isGreaterThan: prevMonth)
        .orderBy('dateFin')
        .get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc.get('dificultad') == dificultad && doc.get('tipoEjercicio')== tipoEjercicio){
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
            
      }
    });
    
    
    return listaEjercicios;
  }

  Future<bool> addUsuario(Usuario usuario) async{
    bool aux = false;

    await usuarios.doc(usuario.email).get().then((DocumentSnapshot documentSnapshot) async {
          if (documentSnapshot.exists){
            print('El usuario ya existe en la base de datos');      
          }else{
            print('El usuario no existe en la base de datos');
            // Call the user's CollectionReference to add a new user
            await usuarios.doc(usuario.email).set(usuario.toJson())
              .then((value) async {
                print("Usuario añadido");
                addAlumnoToAdmin(usuario);
                aux = true;
              })
              .catchError((error){
                print("Error al añadir usuario: $error");
              });
          }
    });
    print(aux);
    return aux;
  }

  Future<void> addAlumnoToAdmin(Usuario usuario) async{
    List<dynamic> listaEmails = [];
    List<String> listaAlumnos = [];
    final email = (FirebaseAuth.instance.currentUser)?.email;
    String referenceId;
    
    await admins.doc(email).update({
      "alumnos": FieldValue.arrayUnion([usuario.email]),
    });
  }

  Future<bool> deleteUsuario(Usuario usuario) async{
    bool aux = false;

    await usuarios.doc(usuario.email).delete()
      .then((value) {
        aux = true;
        print("Usuario" + usuario.email +" eliminado");
        deleteEjercicios(usuario);
        deleteAlumnoFromAdmin(usuario);
      })
      .catchError((error) => print("Error al eliminar usuario: $error"));
    return aux;
  }

  void deleteUsuario2(Usuario usuario) async {
    await usuarios.doc(usuario.email).delete()
      .then((value) {
        print("Usuario" + usuario.email +" eliminado");
        deleteEjercicios(usuario);
      })
      .catchError((error) => print("Error al eliminar usuario: $error"));
  }


  Future<bool> deleteAdmin(Admin admin) async {
    bool aux = false;
    List<Usuario> alumnos = await getAlumnos();

    await admins.doc(admin.email).delete()
      .then((value) async{
        aux = true;
        print("Admin " + admin.email+" eliminado");
        for(var alumno in alumnos){
          deleteUsuario2(alumno);
        }

      })
      .catchError((error) => print("Error al eliminar admin: $error"));
    return aux;
  }

  Future<void> deleteAlumnoFromAdmin(Usuario usuario) async{
    List<dynamic> listaEmails = [];
    List<String> listaAlumnos = [];
    final email = (FirebaseAuth.instance.currentUser)?.email;
    String referenceId;
    
    await admins.doc(email).update({
      "alumnos": FieldValue.arrayRemove([usuario.email]),
    });
  }

  Future<void> deleteEjercicios(Usuario alumno) async{
    
    await ejercicios.where('idUsuario', isEqualTo: alumno.email).get().then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
            var id = doc.id;
            print(id);
            await doc.reference.delete().then(
              (doc) => print("Ejercicio " + id +" eliminado" ),
              onError: (e) => print("Error eliminando ejercicio $e"),
            );
        }
    });
  }




  void updateUsuario(Usuario usuario) async {
    await usuarios.doc(usuario.email).update(usuario.toJson());
  }



  Future<bool> comprobarAdminAutorizado(String email) async {
    // Comprueba si existe el admin en la base de datos antes de permitirle iniciar sesión
    bool aux = false;
    await admins.doc(email).get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print('El admin existe en la base de datos');
            aux = true;
          }
          else{
            print('El admin no existe en la base de datos');
          }
        });
    return aux;
  }

  Future<bool> comprobarSuperadmin(String email) async {
    // Comprueba si existe el admin en la base de datos antes de permitirle iniciar sesión
    bool aux = false;
    await superadmins.doc(email).get().then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print('El usuario es superadmin');
            aux = true;
          }
          else{
            print('El usuario no es superadmin');
          }
        });
    return aux;
  }

}
