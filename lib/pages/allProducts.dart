import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desai_mangoes_admin/pages/prodPage.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  Color primaryColor = Color(0x002244);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Tap on a product for more", style: TextStyle(color: Colors.teal),),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("products").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
                children: snapshot.data!.docs.map((e) => InkWell(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ProdPage(prodData: e)));},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white24
                      ),
                      child: Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height/ 6,
                          child: Center(child: Text(e.get("name"), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),))
                      ),

                    ),
                  ),
                )).toList()
            );
          },
        ),
      ),
    );
  }
}
