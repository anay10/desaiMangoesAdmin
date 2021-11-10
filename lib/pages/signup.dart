import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desai_mangoes_admin/pages/home.dart';
import 'package:desai_mangoes_admin/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

final Color primaryColor = Color.fromARGB(255, 255, 130, 67);
final Color secondaryColor = Colors.black54; //Color(0xff232c51);
final Color logoGreen = Colors.deepPurple;



enum validatorTypes{Uname, Pword, CPword, Cnumber, E_mail}

class signUpPage extends StatefulWidget {
  const signUpPage({Key? key}) : super(key: key);

  @override
  _signUpPageState createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    bool obscure = false;
    if (controller == passwordController || controller == confirmPasswordController) obscure = true;
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
    if(nameController.text.isEmpty || passwordController.text.isEmpty || numberController.text.isEmpty || EmailController.text.isEmpty)
      return "All fields are important and cannot be left empty";
    if(passwordController.text.length < 6)
      return "Password Cannot be less than 6 characters";
    if(passwordController.text.length > 10)
      return "Password Cannot be more than 10 characters";
    if(passwordController.text != confirmPasswordController.text)
      return "Passwords do not match please confirm again";
    if(numberController.text.length != 10)
      return "Invalid Contact Number";
    if((double.tryParse(numberController.text))!.isNaN)
      return "Invalid Contact Number";
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(EmailController.text))
      return "Invalid Email Address";
    return "valid";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(     appBar: AppBar(
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
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style:
                  GoogleFonts.openSans(color: Colors.white, fontSize: 22),
                ),
                SizedBox(height: 20),
                _buildTextField(
                    nameController, Icons.account_circle, 'Username'),
                SizedBox(height: 20),
                _buildTextField(passwordController, Icons.lock, 'Password'),
                SizedBox(height: 20),
                _buildTextField(confirmPasswordController, Icons.lock, 'Confirm Password'),
                SizedBox(height: 20),
                _buildTextField(numberController, Icons.phone, 'Contact Number'),
                SizedBox(height: 20),
                _buildTextField(EmailController, Icons.email, 'Email Address'),
                SizedBox(height: 30),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () async {
                    String msg = _validateForm();
                    if(msg != "valid"){
                      Fluttertoast.showToast(msg: msg);
                    }
                    else{
                      final email = EmailController.text.trim();
                      final password = passwordController.text.trim();
                      final number = numberController.text.trim();
                      final username = nameController.text.trim();

                      var msg = await context.read<AuthService>().SignUp(email, password);
                      if(msg == "done"){
                        var FireUser = FirebaseAuth.instance.currentUser;
                        if(FireUser != null)
                          await FirebaseFirestore.instance.collection("users").doc(FireUser.uid).set({
                            'uid': FireUser.uid,
                            'email': email,
                            'number': number,
                            'username': username,
                          });
                      }
                      else{
                        Fluttertoast.showToast(msg: msg);
                      }

                    // .then((value)async{
                    // User? _user = FirebaseAuth.instance.currentUser;
                    //
                    // await FirebaseFirestore.instance.collection("users").doc(_user!.uid).set({
                    // 'uid': _user!.uid,
                    // 'email': email,
                    // 'number': number,
                    // 'username': username
                    // });
                    // });

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                    }
                  },
                  color: logoGreen,
                  child: Text('Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
                //SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                          child: Text(
                            "Already have an account? ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400),
                          )),
                      Flexible(
                          child: InkWell(
                            onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));},
                            child: Text(
                              "click here to Log In",
                              style: TextStyle(
                                  color: logoGreen,
                                  fontSize: 12.0,
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
}


