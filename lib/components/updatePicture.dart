import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desai_mangoes_admin/pages/imageUploader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdatePicture extends StatefulWidget {
  final String prodName;
  final String prodID;
  const UpdatePicture({Key? key, required this.prodName, required this.prodID}) : super(key: key);

  @override
  _UpdatePictureState createState() => _UpdatePictureState();
}

class _UpdatePictureState extends State<UpdatePicture> {
  String oldImageBuff = "";
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0x002244);
    _getImageUrl();
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            imageUrl = "";
            Navigator.pop(context);
          },
        ),
        actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 0,
                  minWidth: 50,
                  onPressed: (){
                    if(imageUrl.isNotEmpty){
                      showDialog(context: context, builder: (_) => new AlertDialog(
                        title: new Text("Confirm Update"),
                        content:
                        new Text("Proceed to Update Image?"),
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
                              if(imageUrl.isEmpty){
                                Navigator.of(context).pop();
                                return;
                              }
                              Navigator.of(context).pop();
                              String childString = "products/" + widget.prodName;
                              try {
                                var updateResult = await FirebaseStorage.instance.ref().child(childString).putFile(File(imageUrl));
                                var newImageURL = await updateResult.ref.getDownloadURL();
                                await FirebaseFirestore.instance.collection("products").doc(widget.prodID).update(
                                  {
                                    "url" : newImageURL.trim()
                                  }
                                ).then((value){
                                  imageUrl = "";
                                  oldImageBuff = "";
                                });
                                Fluttertoast.showToast(msg: "Image Updated Successfully");
                                Navigator.of(context).pop();
                              } catch (e) {
                                print(e.toString());
                              }
                            },
                          )
                        ],
                      ));
                    }
                    else{
                      Fluttertoast.showToast(msg: "Select an Image to Update");
                    }
                  },
                  color: Colors.teal,
                  child: Text('Update',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
        ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
             Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 border: Border.all(color: Colors.white, width: 2)
               ),
               child: Column(
                 children: [
                   (oldImageBuff.isEmpty)
                       ?Container(
                     margin: EdgeInsets.only(top: 20),
                     width: 300,
                     height: 200,
                     child: Center(child: CircularProgressIndicator(color: Colors.white,)),
                   ):
                   Container(
                     margin: EdgeInsets.only(top: 20),
                     width: 300,
                     height: 200,
                     child: Image.network(oldImageBuff),
                   ),
                   Container(
                     margin: EdgeInsets.symmetric(vertical: 20),
                     child: Text("Old Image", style: TextStyle(color: Colors.teal, fontSize: 20, fontWeight: FontWeight.w700),),
                   )
                 ],
               ),
             ),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2)
                ),
                child: ImageUploader(),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: MaterialButton(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(40),
              //         ),
              //         elevation: 0,
              //         minWidth: double.maxFinite,
              //         height: 50,
              //         onPressed: (){},
              //         color: Colors.teal,
              //         child: Text('Upload',
              //             style: TextStyle(color: Colors.white, fontSize: 16)),
              //         textColor: Colors.white,
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      )
    );
  }
  _getImageUrl()async{
   try{
     var snapshot = await FirebaseFirestore.instance.collection("products").doc(widget.prodID).get();
     String currentImageURL = await snapshot.get("url");
     if (!mounted) return;
     setState(() {
       oldImageBuff = currentImageURL;
     });
   }catch(e){
     print(e.toString());
   }

  }
}

