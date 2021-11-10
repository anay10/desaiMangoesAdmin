import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:desai_mangoes_admin/pages/updatePage.dart';

class ProdPage extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> prodData;

  Future<String> _featStatus()async{
    try{
      var userDocRef = FirebaseFirestore.instance.collection("featured").doc(prodData.id);
      var doc = await userDocRef.get();
      if (!doc.exists) {
        return "false";
      } else {
        return "true";
      }
    }
    catch(e){
      print(e.toString());
      return "false";
    }
  }

  const ProdPage({Key? key, required this.prodData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0x002244);
    String productImage = prodData["url"];
    //var height = MediaQuery.of(context).size.height;
    bool isFeatured = (_featStatus().toString() == "true");
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(prodData: prodData,)));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.update, color: Colors.teal),
                              Text(
                                " Update Product",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => new AlertDialog(
                                  title: new Text("Confirm Delete"),
                                  content:
                                      new Text("Proceed to delete product?"),
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
                                        Navigator.of(context).pop();
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection("products")
                                              .doc(prodData.id)
                                              .delete();
                                          await FirebaseFirestore.instance
                                              .collection("featured")
                                              .get()
                                              .then((QuerySnapshot querySnapshot) {
                                            querySnapshot.docs.forEach((doc) async {
                                              if(doc["id"] == prodData.id){
                                                await FirebaseFirestore.instance.collection("featured").doc(doc.id).delete();
                                                print(doc["id"]);
                                              }
                                            });
                                          });
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Product deleted successfully");
                                          Navigator.of(context).pop();
                                        } catch (e) {}
                                      },
                                    )
                                  ],
                                ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Delete Product ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(Icons.close, color: Colors.teal)
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              (productImage.isNotEmpty)
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Image.network(
                        productImage,
                        width: 300,
                        height: 200,
                      ),
                    )
                  : Container(
                      width: 300,
                      height: 200,
                      child: CircularProgressIndicator(
                        color: Colors.teal,
                      ),
                    ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        prodData["name"],
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                    (prodData["feat"] == "true")?Icon(Icons.favorite, color: Colors.pink,) : Icon(Icons.favorite_border, color: Colors.teal)
                  ],
                ),
              ),
              Divider(
                color: Colors.white24,
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Description",
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                        child: Text(prodData["description"],
                            style: TextStyle(color: Colors.white))),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Price",
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                        child: Text("${prodData["price"]}₹",
                            style: TextStyle(color: Colors.white))),
                  ),
                  Text(
                    "Quantity",
                    style: TextStyle(color: Colors.teal),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(prodData["qty"], style: TextStyle(color: Colors.white)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(prodData["unit"], style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Category", style: TextStyle(color: Colors.teal)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(prodData["category"], style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
