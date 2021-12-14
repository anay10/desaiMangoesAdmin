import 'package:desai_mangoes_admin/pages/prodPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchString = "";
  Color primaryColor = Color(0x002244);
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text("Search for a Product", style: TextStyle(color: Colors.teal),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.white24,
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      searchString = value.toLowerCase();
                    });
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {searchController.clear();
                      if(!mounted) return;
                      setState(() {
                        searchString = "";
                      });
                      },
                    ),
                    hintText: "Search for a product",
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: StreamBuilder(
                stream: (searchString.isEmpty)
                    ?FirebaseFirestore.instance.collection("default").snapshots()
                    :FirebaseFirestore.instance.collection("products").where("searchIndex", arrayContains: searchString).snapshots(),
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
                                height: MediaQuery.of(context).size.height/ 7,
                                child: Center(child: Text(e.get("name"), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),))
                            ),

                          ),
                        ),
                      )).toList()
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
