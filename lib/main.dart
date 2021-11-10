import 'package:desai_mangoes_admin/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:desai_mangoes_admin/pages/gettingStarted.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:desai_mangoes_admin/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //FirebaseAuth.instance.signOut();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: gettingStarted(),
    // );
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_)=>AuthService(firebaseAuth: FirebaseAuth.instance),
          ),
          StreamProvider(create: (context) => context.read<AuthService>().authStateChanges, initialData: null,)
        ],
      child: MaterialApp(
        title: "App",
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // final user = context.watch<User?>();
    if(FirebaseAuth.instance.currentUser == null)
      return gettingStarted();
    return HomePage();
  }
}