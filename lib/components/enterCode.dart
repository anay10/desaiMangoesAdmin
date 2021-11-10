import 'package:desai_mangoes_admin/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterCode extends StatelessWidget {
  const EnterCode({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var db = FirebaseAuth.instance;
    Color primaryColor = Color.fromARGB(255, 255, 130, 67);
    Color secondaryColor = Colors.black54; //Color(0xff232c51);
    Color logoGreen = Colors.deepPurple;
    TextEditingController numberController = TextEditingController();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text("Verify Phone Number", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.width * 0.6,),
              _buildTextField(numberController, Icons.phone_android, "Enter OTP"),
              SizedBox(height: 10,),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: () async {
                  showDialog(context: context, builder: (_) => AlertDialog(
                    title: Text("Confirm Submission"),
                    actions: [
                      TextButton(onPressed: (){}, child: TextButton(
                        child: Text("No"),
                        onPressed: (){Navigator.of(context).pop();},
                      )),
                      TextButton(onPressed: (){}, child: TextButton(
                        child: Text("Yes"),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await db.verifyPhoneNumber(phoneNumber: numberController.text,
                              verificationCompleted: (PhoneAuthCredential credential) {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signUpPage()));
                              },
                              verificationFailed: (FirebaseAuthException e) {
                                Fluttertoast.showToast(msg: "Verification Failed!: " + e.toString());
                              },
                              codeSent: (String verificationId, int? resendToken) {
                                  PhoneAuthCredential credential = PhoneAuthProvider
                                      .credential(verificationId: verificationId, smsCode: numberController.text);
                              },
                              codeAutoRetrievalTimeout: (String verificationId) {});
                        },
                      )),
                    ],
                  ));
                },
                color: logoGreen,
                child: Text('Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildFooterLogo(),
              )
            ],
          ),
        ),
      ),
    );
  }
  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    bool obscure = false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(40)),
      child: TextField(
        obscureText: obscure,
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(),
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
}
