import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:desai_mangoes_admin/components/updatePicture.dart';
import 'package:desai_mangoes_admin/components/featuredStatus.dart';
import 'package:desai_mangoes_admin/components/updateDescription.dart';
import 'package:desai_mangoes_admin/components/updateprice_qty.dart';

class UpdatePage extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> prodData;

  const UpdatePage({Key? key, required this.prodData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0x002244);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Select the field to update",
          style: TextStyle(color: Colors.teal),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 50, 20, 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 2, color: Colors.teal)),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdatePicture(
                                  prodID: prodData.id,
                                  prodName: prodData["name"],
                                )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(30)),
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height / 8,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Product Picture",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FeaturedStatus(prodID: prodData.id,)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(30)),
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height / 8,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Featured Status",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateDescription(prodID: prodData.id)));},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(30)),
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height / 8,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Product Description",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PriceNQty(prodID: prodData.id)));},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(30)),
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height / 8,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Product Price & Qty.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // InkWell(
                //   onTap: () {},
                //   child: Container(
                //     decoration: BoxDecoration(
                //         color: Colors.teal,
                //         borderRadius: BorderRadius.circular(30)),
                //     width: double.maxFinite,
                //     height: MediaQuery.of(context).size.height / 8,
                //     child: Container(
                //       alignment: Alignment.center,
                //       child: Text(
                //         "Product Quantity",
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white,
                //             fontSize: 20),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
