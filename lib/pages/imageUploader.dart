import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

String imageUrl = "";

class ImageUploader extends StatefulWidget {
  const ImageUploader({Key? key}) : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  final Color primaryColor = Color.fromARGB(255, 255, 130, 67);
  final Color secondaryColor = Colors.black54; //Color(0xff232c51);
  final Color logoGreen = Colors.deepPurple;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          (imageUrl.isNotEmpty)
              // ? Image.network(
              //     imageUrl,
              //     width: 300,
              //     height: 200,
              //   )
              ?Image.file(
              File(imageUrl),
              width: 300,
              height: 200,
              )
              : Container(
                  child: Container(
                      alignment: Alignment.center,
                      child: Text("Select an image")),
                  width: 300,
                  height: 200,
                  color: Colors.white,
                ),
          SizedBox(height: 20,),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 0,
            minWidth: double.maxFinite,
            height: 50,
            onPressed: () => _uploadImage(),
            color: Colors.teal,
            child: Text('Upload',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  _uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final picker = ImagePicker();
    XFile image;
    //get permission
    Permission.photos.request();
    var _permissionStatus = await Permission.photos.status;
    //select image
    if (_permissionStatus.isGranted) {
      image = (await picker.pickImage(source: ImageSource.gallery))!;
      var imageURL = File(image.path);
      if (image != null) {
      //   var snapshot =
      //       await _storage.ref().child("products/image1").putFile(imageURL);
      //   var downloadURL = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = imageURL.path;
        });
      } else {
        print("image not selected");
      }
    } else {
      print("permission not granted");
    }
    //upload image to firebase
  }
}
