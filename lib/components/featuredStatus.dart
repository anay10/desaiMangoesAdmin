import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeaturedStatus extends StatefulWidget {
  final String prodID;
  const FeaturedStatus({Key? key, required this.prodID}) : super(key: key);

  @override
  _FeaturedStatusState createState() => _FeaturedStatusState();
}

class _FeaturedStatusState extends State<FeaturedStatus> {
  bool isFeatured = false;
  @override
  Widget build(BuildContext context) {
    _getFeatured();
    Color primaryColor = Color(0x002244);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 250,),
              (!isFeatured)
              ?Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("This product is not featured", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Do you want to feature it?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),),
                      SizedBox(width: 10,),
                      InkWell(onTap: (){_addFeature();},child: Text("yes", style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),))
                    ],
                  )
                ],
              ):
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("This product is featured", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    alignment: Alignment.center,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Do you want to remove it?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),),
                        SizedBox(width: 10,),
                        InkWell(
                            onTap: (){_removeFeature();},
                            child: Text("yes", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  _getFeatured()async{
    try{
      var snapshot = await FirebaseFirestore.instance.collection("products").doc(widget.prodID).get();
      String currentFeatStatus = await snapshot.get("feat");
      if (!mounted) return;
      if(currentFeatStatus == "true"){
        setState(() {
          this.isFeatured = true;
        });
      }
    }catch(e){
      print(e.toString());
    }
  }

  _removeFeature()async{
    try{
      await FirebaseFirestore.instance.collection("products").doc(widget.prodID).update({
        "feat" : "false"
      });

      await FirebaseFirestore.instance
          .collection("featured")
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          if(doc["id"] == widget.prodID){
            await FirebaseFirestore.instance.collection("featured").doc(doc.id).delete();
            print(doc["id"]);
          }
        });
      });
      if(!mounted) return;
      setState(() {
        this.isFeatured = false;
      });
    }catch(e){
      print(e.toString());
    }
  }

  _addFeature()async{
    try{
      await FirebaseFirestore.instance.collection("products").doc(widget.prodID).update({"feat" : "true"});
      await FirebaseFirestore.instance.collection("featured").add({"id" : widget.prodID});
      if(!mounted) return;
      setState(() {
        this.isFeatured = true;
      });
    }
    catch(e){
      print(e.toString());
    }
  }
}