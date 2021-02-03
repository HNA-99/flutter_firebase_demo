import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/services/search_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).toLowerCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docChanges.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['Product Name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }

    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Text('Search Products'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.search),
                  iconSize: 20,
                  onPressed: () {},
                ),
                contentPadding: EdgeInsets.only(left: 25),
                hintText: 'Search by product name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
          GridView.count(
            padding: EdgeInsets.only(left: 10, right: 10),
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            primary: false,
            shrinkWrap: true,
            children: tempSearchStore.map((element) {
              return buildResultCard(element);
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget buildResultCard(data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Container(
        child: Center(
          child: Text(
            data['Product Name'],
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
