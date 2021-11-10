import 'package:desai_mangoes_admin/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desai_mangoes_admin/pages/orders.dart';
import 'package:desai_mangoes_admin/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'imageUploader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:desai_mangoes_admin/components/product_form.dart';
import 'package:provider/provider.dart';
import 'package:desai_mangoes_admin/pages/allProducts.dart';
import 'package:desai_mangoes_admin/pages/search.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  build(BuildContext context) {
    Color primaryColor = Color(0x002244);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                userInfo(),
                InkWell(
                  onTap: () {
                    imageUrl = "";
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProductForm()));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    shadowColor: Colors.white,
                    elevation: 4,
                    child: Container(
                      width: 300,
                      height: 100,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Add new Product",
                            style: GoogleFonts.brawler(
                                color: Colors.black54, fontSize: 20),
                          )),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));},
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    shadowColor: Colors.white,
                    elevation: 4,
                    child: Container(
                      width: 300,
                      height: 100,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Search a Product",
                            style: GoogleFonts.brawler(
                                color: Colors.black54, fontSize: 20),
                          )),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AllProducts()));},
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    shadowColor: Colors.white,
                    elevation: 4,
                    child: Container(
                      width: 300,
                      height: 100,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "View all Products",
                            style: GoogleFonts.brawler(
                                color: Colors.black54, fontSize: 20),
                          )),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Orders()));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    shadowColor: Colors.white,
                    elevation: 4,
                    child: Container(
                      width: 300,
                      height: 100,
                      child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Orders",
                            style: GoogleFonts.brawler(
                                color: Colors.black54, fontSize: 20),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    //return ProductForm();
  }
}

class userInfo extends StatefulWidget {
  const userInfo({Key? key}) : super(key: key);

  @override
  _userInfoState createState() => _userInfoState();
}

class _userInfoState extends State<userInfo> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String documentId = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong",
              style: TextStyle(color: Colors.white));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist",
              style: TextStyle(color: Colors.white));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Welcome, ${data['username']}",
                    style: GoogleFonts.dawningOfANewDay(
                        color: Colors.white, fontSize: 35)),
              ));
        }

        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("loading", style: TextStyle(color: Colors.black)),
            ));
      },
    );
  }
}
