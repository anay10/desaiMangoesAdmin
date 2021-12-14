import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatusUpdate extends StatefulWidget {
  final String orderDocID;

  const StatusUpdate({Key? key, required this.orderDocID}) : super(key: key);

  @override
  _StatusUpdateState createState() => _StatusUpdateState();
}

class _StatusUpdateState extends State<StatusUpdate> {
  String orderStatus = "";
  int statusMenu = 0;
  bool statusFetched = false;
  Color statusColor = Colors.white;

  _getOrderStatusInfo() async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderDocID)
        .get()
        .then((value){
          orderStatus = value.data()!["deliverystat"];
          setState(() {
            statusFetched = true;
            if(orderStatus == "processing"){
              statusColor = Colors.red;
            }
            else if(orderStatus == "dispatched"){
              statusColor = Colors.yellow;
            }
            else if(orderStatus == "transit"){
              statusColor = Colors.yellow;
            }
            else if(orderStatus == "shipped"){
              statusColor = Colors.green;
            }
          });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getOrderStatusInfo();
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
        child: Center(
          child: Column(
            children: [
              (!statusFetched)?CircularProgressIndicator()
              : Row(
                children: [
                  SizedBox(width: 20,),
                  Text("Current Status: ", style: TextStyle(color: Colors.teal, fontSize: 16)),
                  SizedBox(width: 10,),
                  Text(this.orderStatus, style: TextStyle(color: this.statusColor, fontSize: 16)),
                ],
              ),
              SizedBox(height: 10,),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: () {
                  //cancel order
                  _dialogBuilder("Confirm Order Cancellation", "Proceed to Cancel the Order?");
                },
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.cancel),
                    SizedBox(width: 10),
                    Text('Cancel Order',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
                textColor: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Row(
                  children: [
                    Text("Change Status to: ", style: TextStyle(color: Colors.teal, fontSize: 16)),
                    SizedBox(width: 10,),
                    DropdownButton<int>(items: [
                      DropdownMenuItem(
                        child: Text("dispatched", style: TextStyle(color: Colors.white, fontSize: 16)),
                        value: 0,
                      ),
                      DropdownMenuItem(
                        child: Text("transit", style: TextStyle(color: Colors.white, fontSize: 16)),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("shipped", style: TextStyle(color: Colors.white, fontSize: 16)),
                        value: 2,
                      ),
                    ],
                      value: this.statusMenu,
                      onChanged: (val){
                        this.statusMenu = val!;
                      },
                      dropdownColor: Colors.black54,
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: () {
                  //update order status
                  _dialogBuilder("Confirm Order Status Update", "Proceed to Update Order Status?");
                },
                color: Colors.teal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check),
                    SizedBox(width: 10),
                    Text('Update Order Status',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _dialogBuilder(String _title, String _subtitle){
    showDialog(context: context, builder: (_)=> new AlertDialog(
      title: Text(_title),
      content: Text(_subtitle),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text("No")),
        TextButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text("Yes")),
      ],
    ));
  }
}
