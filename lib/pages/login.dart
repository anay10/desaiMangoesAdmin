import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desai_mangoes_admin/pages/signup.dart';
import 'package:provider/provider.dart';
import 'package:desai_mangoes_admin/services/auth_service.dart';
import 'package:desai_mangoes_admin/pages/home.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
bool isLoggedIn = false;

class LoginPage extends StatelessWidget {
  final Color primaryColor = Color.fromARGB(255, 255, 130, 67);
  final Color secondaryColor = Colors.black54; //Color(0xff232c51);
  final Color logoGreen = Colors.deepPurple;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: primaryColor,
        body: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign in to Desai e-Store and continue',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 28),
                ),
                SizedBox(height: 20),
                Text(
                  'Enter your email and password below to continue to Desai e-Store and let the craving begin!',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                ),
                SizedBox(
                  height: 50,
                ),
                _buildTextField(
                    nameController, Icons.account_circle, 'Username'),
                SizedBox(height: 20),
                _buildTextField(passwordController, Icons.lock, 'Password'),
                SizedBox(height: 30),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () async {
                    String validation = _validateForm();
                    if(validation != "valid"){
                      Fluttertoast.showToast(msg: validation);
                    }
                    else
                      {
                        final email = nameController.text.trim();
                        final password = passwordController.text.trim();
                        await context.read<AuthService>().LogInWithEmail(email, password).then((value){
                          if(value == "done")
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                          else
                            Fluttertoast.showToast(msg: "Username or Password is incorrect");
                        });
                      }
                  },
                  color: logoGreen,
                  child: Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
                SizedBox(height: 20),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () {
                    //Here goes the logic for Google SignIn discussed in the next section
                    _signInWithGoogle(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(FontAwesomeIcons.google),
                      SizedBox(width: 10),
                      Text('Sign-in using Google',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                  textColor: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                          child: Text(
                        "Don't have an account?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400),
                      )),
                      Flexible(
                          child: InkWell(
                            onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> signUpPage()));},
                            child: Text(
                              "click here to Sign Up",
                              style: TextStyle(
                                  color: logoGreen,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFooterLogo(),
                )
              ],
            ),
          ),
        ));
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Image.asset(
            'images/logo.png',
            height: 40,
          ),
        ),
        Text('Desai Products',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    bool obscure = false;
    if (controller == passwordController) obscure = true;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(40)),
      child: TextField(
        obscureText: obscure,
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }
  _validateForm() {
    if(nameController.text.isEmpty || passwordController.text.isEmpty)
      return "All fields are important and cannot be left empty";
    if(passwordController.text.length < 6)
      return "Password Cannot be less than 6 characters";
    if(passwordController.text.length > 10)
      return "Password Cannot be more than 10 characters";
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(nameController.text))
      return "Invalid Email Address";
    return "valid";
  }
  _signInWithGoogle(BuildContext context) async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final User? user =
          (await firebaseAuth.signInWithCredential(credential)).user;
      if (user != null) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection("users")
            .where("id", isEqualTo: user.uid)
            .get();

        List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          //  insert the user to our collection
          FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            "uid": user.uid,
            "username": user.displayName,
            "email": user.email,
            "number": user.phoneNumber,
          });
          context.read<AuthService>().setUID(user.uid);
        }
      }
      else {
        print("invalid google user");
      }
    }
    else {
      print("invalid google user");
    }
  }
}
