import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PriceNQty extends StatefulWidget {
  final String prodID;

  const PriceNQty({Key? key, required this.prodID}) : super(key: key);

  @override
  _PriceNQtyState createState() => _PriceNQtyState();
}

class _PriceNQtyState extends State<PriceNQty> {
  int num = 1;
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController qtyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (num == 1) _getInitialData();
    Color primaryColor = Color(0x002244);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Update Price and Quantity", style: TextStyle(color: Colors.teal),),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: _buildTextField(
                          priceCtrl, FontAwesomeIcons.rupeeSign, "Edit Price")),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.teal),
                      child: InkWell(
                        onTap: ()async{
                          var validator = double.tryParse(priceCtrl.text);
                          if(validator == null){
                            Fluttertoast.showToast(msg: "Price must be a number");
                            return;
                          }
                          showDialog(context: context, builder: (_) => new AlertDialog(
                            title: new Text("Confirm Update"),
                            content:
                            new Text("Proceed to Update Price?"),
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
                                    await FirebaseFirestore.instance.collection("products").doc(widget.prodID).update({"price" : priceCtrl.text.trim()});
                                    Fluttertoast.showToast(msg: "Price Updated Successfully");
                                    setState(() {
                                      _getInitialData();
                                    });
                                  }catch(e){
                                    print(e.toString());
                                  }
                                },
                              )
                            ],
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Update"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: _buildTextField(
                          qtyCtrl, FontAwesomeIcons.bitbucket, "Edit Qty.")),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.teal),
                      child: InkWell(
                        onTap: ()async{
                          var validator = int.tryParse(qtyCtrl.text);
                          if(validator == null){
                            Fluttertoast.showToast(msg: "Quantity must be a number");
                            return;
                          }
                          showDialog(context: context, builder: (_) => new AlertDialog(
                            title: new Text("Confirm Update"),
                            content:
                            new Text("Proceed to Update Quantity?"),
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
                                    await FirebaseFirestore.instance.collection("products").doc(widget.prodID).update({"qty" : qtyCtrl.text.trim()});
                                    Fluttertoast.showToast(msg: "Price Updated Successfully");
                                    setState(() {
                                      _getInitialData();
                                    });
                                  }catch(e){
                                    print(e.toString());
                                  }
                                },
                              )
                            ],
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Update"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
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
          color: Colors.white24, borderRadius: BorderRadius.circular(40)),
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

  _getInitialData() async {
    num = num - 1;
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.prodID)
          .get();
      String priceval = await snapshot.get("price");
      String qtyval = await snapshot.get("qty");
      setState(() {
        priceCtrl.text = priceval;
        qtyCtrl.text = qtyval;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
