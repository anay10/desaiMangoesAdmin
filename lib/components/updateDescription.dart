import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateDescription extends StatefulWidget {
  final String prodID;
  const UpdateDescription({Key? key, required this.prodID}) : super(key: key);

  @override
  _UpdateDescriptionState createState() => _UpdateDescriptionState();
}

class _UpdateDescriptionState extends State<UpdateDescription> {
  int num = 1;
  String initialText = "";
  String toUpdate = "";
  TextEditingController descriptionCtrl = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
   _getInitText();
    print(this.initialText + "a");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(num == 1)
      _getInitText();
    var height = MediaQuery.of(context).size.height;
    Color primaryColor = Color(0x002244);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.70,
              width: double.maxFinite,//width * 0.85,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descriptionCtrl,
                  keyboardType: TextInputType.multiline,
                  maxLines: 100,
                  decoration: InputDecoration(
                    hintMaxLines: 100,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height*0.02),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: ()async{
                  showDialog(context: context, builder: (_) => new AlertDialog(
                    title: new Text("Confirm Update"),
                    content:
                    new Text("Proceed to Update Description?"),
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
                          try{
                            Center(child: CircularProgressIndicator(color: Colors.teal,));
                            await FirebaseFirestore.instance.collection("products").doc(widget.prodID).update({"description" : descriptionCtrl.text.trim()});
                            Fluttertoast.showToast(msg: "Description Updated Successfully");
                            Navigator.pop(context);
                          }catch(e){
                            print(e.toString());
                          }
                        },
                      )
                    ],
                  ));
                },
                color: Colors.teal,
                child: Text('Upload',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getInitText() async {
    num = num - 1;
    var snapshot = await FirebaseFirestore.instance.collection("products").doc(widget.prodID).get();
    String toReturn = await snapshot.get("description");
    if(!mounted) return;
    setState(() {
      //this.initialText = toReturn;
      descriptionCtrl.text = toReturn;
    });
  }
}
