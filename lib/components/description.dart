import 'dart:io';

import 'package:desai_mangoes_admin/pages/home.dart';
import 'package:desai_mangoes_admin/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'product_form.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DescriptionBox extends StatefulWidget {
  final String prodName;
  final int prodQuantity;
  final String prodUnit;
  final double prodPrice;
  final String prodImage;
  final String prodCategory;
  final bool prodFeat;

  const DescriptionBox(
      {Key? key,
      required this.prodName,
      required this.prodQuantity,
      required this.prodUnit,
      required this.prodPrice,
      required this.prodImage,
      required this.prodFeat,
      required this.prodCategory})
      : super(key: key);

  @override
  _DescriptionBoxState createState() => _DescriptionBoxState();
}

class _DescriptionBoxState extends State<DescriptionBox> {
  Color primaryColor = Color(0x002244);
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  TextEditingController descriptionController = TextEditingController();

  _DescriptionBoxState();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
          child: Column(
            children: <Widget>[
              Text(
                "Enter Description of Product",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: height * 0.70,
                width: double.maxFinite, //width * 0.85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 100,
                    decoration: InputDecoration(
                      hintMaxLines: 100,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.teal,
                    onPressed: () {
                      _showDialog();
                    },
                    // => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductForm())),
                    child: Icon(Icons.check),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Confirm Submission"),
              content: new Text("Proceed to add product?"),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () async {
                    List<String> splitList = widget.prodName.split(' ');
                    List<String> indexList = [];
                    for (int i = 0; i < splitList.length; i++) {
                      for (int j = 0; j < splitList[i].length + 1; j++) {
                        indexList
                            .add(splitList[i].substring(0, j).toLowerCase());
                      }
                    }
                    Navigator.of(context).pop();
                    try {
                      var snapshot = await _storage
                          .ref()
                          .child(this.widget.prodName)
                          .putFile(File(this.widget.prodImage));
                      var downloadURL = await snapshot.ref.getDownloadURL();
                      Map<String, dynamic> newProd = {
                        "name": this.widget.prodName.trim(),
                        "price": this.widget.prodPrice.toString(),
                        "description": descriptionController.text.trim(),
                        "qty": this.widget.prodQuantity.toString().trim(),
                        "unit": this.widget.prodUnit.trim(),
                        "url": downloadURL,
                        "feat": (this.widget.prodFeat) ? true : false,
                        "category" : widget.prodCategory.trim(),
                        "searchIndex": indexList
                      };
                      var docID =
                          (await db.collection("products").add(newProd)).id;
                      String childName = "products/" + docID.toString();

                      if (this.widget.prodFeat) {
                        await db
                            .collection("featured")
                            .doc(docID)
                            .set({"id": docID});
                      }
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                      Fluttertoast.showToast(msg: "Product Added Successfully");
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                )
              ],
            ));
  }
}
