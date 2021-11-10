import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:desai_mangoes_admin/pages/home.dart';
import 'package:desai_mangoes_admin/pages/imageUploader.dart';
import 'package:desai_mangoes_admin/components/description.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({Key? key}) : super(key: key);

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  Color primaryColor = Color(0x002244);
  bool value = false;
  int rval = -1;
  int quantityVal = 0;
  int categoryVal = 0;
  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productQuantityCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);}, //=> Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => HomePage())),
          icon: Icon(Icons.arrow_back_ios),
        ),
        //title: Text("Enter Product Information", style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Text(
                "Enter Product Details",
                style: TextStyle(color: Colors.deepOrange, fontSize: 30, fontWeight: FontWeight.bold),
              ),
              ImageUploader(),
              _buildTextField(
                  productNameCtrl, Icons.account_box_outlined, "Product Name"),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Expanded(
                  //   child: _buildTextField(productQuantityCtrl,
                  //       Icons.shopping_basket_outlined, "Quantity"),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: _buildTextField(productQuantityCtrl,
                        Icons.shopping_basket_outlined, "Quantity"),
                  ),
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text("In",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 25,
                                fontWeight: FontWeight.bold))),
                  ),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: DropdownButton<int>(
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                "Dozen",
                                style: TextStyle(color: Colors.black),
                              ),
                              value: 0,
                            ),
                            DropdownMenuItem(
                              child: Text("Quintal",
                                  style: TextStyle(color: Colors.black)),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Unit",
                                  style: TextStyle(color: Colors.black)),
                              value: 2,
                            ),
                          ],
                          value: quantityVal,
                          onChanged: (val) {
                            setState(() {
                              quantityVal = val!;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white24
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text("Select a category", style: TextStyle(color: Colors.white, fontSize: 20),)),
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: DropdownButton<int>(
                              items: [
                                DropdownMenuItem(
                                  child: Text(
                                    "Pulp",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: 0,
                                ),
                                DropdownMenuItem(
                                  child: Text("Mangoes",
                                      style: TextStyle(color: Colors.black)),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("Cordial",
                                      style: TextStyle(color: Colors.black)),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text("Juice",
                                      style: TextStyle(color: Colors.black)),
                                  value: 3,
                                ),
                                DropdownMenuItem(
                                  child: Text("Kokam",
                                      style: TextStyle(color: Colors.black)),
                                  value: 4,
                                ),
                              ],
                              value: categoryVal,
                              onChanged: (val) {
                                setState(() {
                                  categoryVal = val!;
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(productPriceCtrl, FontAwesomeIcons.rupeeSign,
                  "Product Price"),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Featured Product?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Flexible(
                      child: Checkbox(
                          value: this.value,
                          onChanged: (_value) {
                            setState(() {
                              this.value = _value!;
                            });
                          }),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 0,
                  minWidth: 150,
                  height: 50,
                  onPressed: () {
                    String formStatus = _validateForm();
                    if(formStatus == "valid"){
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        String pUnit = "";
                        String pCat = "";
                        if (quantityVal == 0)
                          pUnit = "Dozen";
                        else if (quantityVal == 1) pUnit = "Quintal";
                        else if (quantityVal == 2) pUnit = "Unit";

                        if (categoryVal == 0)
                          pCat = "Pulp";
                        else if (categoryVal == 1) pCat = "Mangoes";
                        else if (categoryVal == 2) pCat = "Cordial";
                        else if (categoryVal == 3) pCat = "Juice";
                        else if (categoryVal == 4) pCat = "Kokam";

                        return DescriptionBox(
                            prodName: productNameCtrl.text,
                            prodImage: imageUrl,
                            prodPrice: double.parse(productPriceCtrl.text),
                            prodQuantity: int.parse(productQuantityCtrl.text),
                            prodUnit: pUnit,
                            prodCategory: pCat,
                            prodFeat: value
                        );
                      }));

                    }
                    else{
                      Fluttertoast.showToast(msg: formStatus);
                    }
                  },
                  color: Colors.blueGrey,
                  child: Text('Next',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
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
          color: Colors.white24,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(40)),
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
            //prefix: Icon(icon, color: Colors.white,),
            border: InputBorder.none),
      ),
    );
  }

  _validateForm(){
    if (productNameCtrl.text.isEmpty ||
        productQuantityCtrl.text.isEmpty ||
        productPriceCtrl.text.isEmpty ||
        quantityVal == -1)
      return "All fields are important and cannot be left empty";
    double pricevalid = double.parse(productPriceCtrl.text);
    int qtyvalid = int.parse(productQuantityCtrl.text);
    // print(pricevalid);
    // print(qtyvalid);
    if (qtyvalid.isNaN)
      return "Invalid Number in Quantity field";
    if (pricevalid.isNaN)
      return "Invalid Number in Price field";
    if (imageUrl.isEmpty) return "Invalid Number in Quantity field";
    return "valid";
  }
}
