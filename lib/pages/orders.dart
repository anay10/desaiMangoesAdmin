import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desai_mangoes_admin/pages/orderDetails.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  int processingOrderNumber = 0;
  int toBeDeliveredNumber = 0;
  bool statusUpdated = false;
  _getOrdersStatus()async{
   try{
     var pendingOrders = await FirebaseFirestore.instance.collection("orders").where('iscompleted', isEqualTo: false).get();
     pendingOrders.docs.forEach((element) {
       if(element.get("deliverystat") == "processing"){processingOrderNumber++;}
       if(element.get("deliverystat") == "transit" || element.get("deliverystat") == "shipped"){toBeDeliveredNumber++;}
     });
     setState(() {
       statusUpdated = true;
     });
   }catch(e){
     print("ERROR: $e");
   }
  }
  Color primaryColor = Color(0x002244);
  @override
  void initState() {
    // TODO: implement initState
    _getOrdersStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text("Orders", style: TextStyle(color: Colors.teal),),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: Row(
                  children: [
                    Text("Processing: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 16),),
                    (!statusUpdated)?Text("...", style: TextStyle(color: Colors.white, fontSize: 16),)
                        :Text("$processingOrderNumber", style: TextStyle(color: Colors.white, fontSize: 16),),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.2,),
                    Text("Transit: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 16),),
                    (!statusUpdated)?Text("...", style: TextStyle(color: Colors.white, fontSize: 16),)
                        :Text("$toBeDeliveredNumber", style: TextStyle(color: Colors.white, fontSize: 16),)
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("orders").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                      children: snapshot.data!.docs.map((e){
                        var tileColor = Colors.white24;
                        if(!e.get("iscompleted")){
                          tileColor = Colors.red;
                        }
                        return InkWell(
                        onTap: (){
                         try{
                           print("Debug" + e.id);
                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetails(orderDocId: e.id)));
                         }catch(error){
                           print("order exception: $error");
                         }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: tileColor
                            ),
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: MediaQuery.of(context).size.height/ 6,
                                child: Center(child: Text(e.get("orderID"), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),))
                            ),
                          ),
                        ),
                      );}).toList()
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
