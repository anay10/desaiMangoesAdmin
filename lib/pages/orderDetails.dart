import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desai_mangoes_admin/pages/statusUpdate.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final String orderDocId;

  OrderDetails({Key? key, required this.orderDocId}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Map<String, dynamic> orderDetails = {};
  bool detailsFetched = false;

  _infoRowBuilder(String label, String content) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
            label,
            style: TextStyle(
                color: Colors.teal, fontSize: 16, fontWeight: FontWeight.w800),
          )),
          Flexible(
              flex: 3,
              child: Text(content,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)))
        ],
      ),
    );
  }

  _getOrderDetails() async {
    try {
      var orderSnapshot = await (FirebaseFirestore.instance
          .collection("orders")
          .doc(widget.orderDocId)
          .get());
      orderDetails = orderSnapshot.data()!;
      print(orderDetails);
      print("Details");
      setState(() {
        detailsFetched = true;
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getOrderDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x002244),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: (!detailsFetched)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _infoRowBuilder("Name", orderDetails["name"]),
                      SizedBox(
                        height: 10,
                      ),
                      _infoRowBuilder(
                              "Address",
                                  orderDetails["address"]["city"] +
                                  ", "+
                                  orderDetails["address"]["country"] +
                                  ", "+
                                  orderDetails["address"]["residence"] +
                                  ", "+
                                  orderDetails["address"]["zipcode"]),
                      SizedBox(height: 10,),
                      _infoRowBuilder("Order ID", orderDetails["orderID"]),
                      SizedBox(height: 10,),
                      _infoRowBuilder("Payment", orderDetails["status"]),
                      SizedBox(height: 10,),
                      _infoRowBuilder("Payment ID", orderDetails["paymentID"]),
                      SizedBox(height: 10,),
                      _infoRowBuilder("Status", orderDetails["deliverystat"]),
                      SizedBox(height: 20,),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        elevation: 0,
                        minWidth: double.maxFinite,
                        height: 50,
                        onPressed: () {
                          //open order status update page
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => StatusUpdate(orderDocID: widget.orderDocId)));
                        },
                        color: Colors.teal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.update),
                            SizedBox(width: 10),
                            Text('Update Order Status',
                                style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        textColor: Colors.white,
                      )
                    ],
                  ),
                )),
    );
  }
}
