import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  FirebaseAuth firebaseAuth;
  String _uid = "";
  AuthService({required this.firebaseAuth});

  Stream<User?> get authStateChanges => firebaseAuth.idTokenChanges();

  Future<String>LogInWithEmail(String email, String password) async {
    try{
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _uid = firebaseAuth.currentUser!.uid;
      return "done";
    }
    catch(e){
      return e.toString();
    }
  }

  Future<String>SignUp(String email, String password) async {
    try{
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      _uid = firebaseAuth.currentUser!.uid;
      return "done";
    }
    catch(e){
      return e.toString();
    }
  }

  String getUID(){
    return _uid;
  }

  void setUID(String id){
    _uid = id;
  }
}