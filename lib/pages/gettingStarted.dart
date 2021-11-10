import 'package:flutter/material.dart';
import 'package:desai_mangoes_admin/pages/login.dart';
//import 'package:desai_mangoes_admin/components/phoneverification.dart';

Color primaryColor = Color.fromARGB(255, 255, 130, 67);
Color secondaryColor = Color(0x5072A7);
Color logoGreen = Colors.deepPurple;

class gettingStarted extends StatelessWidget {
  const gettingStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "images/splashImage.png",
              height: 220,
            ),
            SizedBox(
              height: 20,
            ),
            Text("Welcome to Desai e-Store !",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 20,),
            Text("A one-stop portal for FRESH mangoes, traditional taste of Kokan and more",
            textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              elevation: 0,
              height: 50,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => LoginPage()));//LoginPage here
              },
              color: logoGreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Get Started',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.arrow_forward)
                ],
              ),
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
