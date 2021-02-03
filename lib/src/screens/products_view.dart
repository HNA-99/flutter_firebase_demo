import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/screens/add_product_view.dart';
import 'package:flutter_firebase_demo/src/services/crud.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String productName, productDescription;
  final auth = FirebaseAuth.instance;

  CrudMethods crudObj = new CrudMethods();

  Stream products;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    crudObj.getData().then((results) {
      setState(() {
        products = results;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text('Products'),
        automaticallyImplyLeading: false,
      ),
      body: _productsList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: Colors.white,
          backgroundColor: Colors.red[700],
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => AddProductScreen()));
          }),
    );
  }

  Widget _productsList() {
    if (products != null) {
      return StreamBuilder<QuerySnapshot>(
          stream: products,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              CircularProgressIndicator();
            } else {
              return ListView.separated(
                padding: EdgeInsets.all(6.0),
                itemBuilder: (context, i) {
                  return ListTile(
                    onTap: () {
                      updateDialog(context, snapshot.data.docs[i].id)
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "Product Updated",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text('Select Action '),
                              children: [
                                // SimpleDialogOption(
                                //   onPressed: () {

                                //   },
                                //   child: Text(
                                //     'Update',
                                //     style: TextStyle(fontSize: 17),
                                //   ),
                                // ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    crudObj.deleteProduct(
                                        snapshot.data.docs[i].id);

                                    Fluttertoast.showToast(
                                        msg: "Product Deleted",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    title: Text(snapshot.data.docs[i].data()['Product Name']),
                    subtitle: Text(
                        snapshot.data.docs[i].data()['Product Description']),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.docs.length,
              );
            }
            return Center(child: Text('Loading, please wait...'));
          });
    } else {
      return Center(child: Text('Loading, please wait...'));
    }
  }

  Future<bool> updateDialog(BuildContext context, selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Update Product ',
              style: TextStyle(fontSize: 15),
            ),
            content: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill in product name";
                      }

                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: 'Product Name'),
                    style: TextStyle(fontSize: 14),
                    onChanged: (value) {
                      this.productName = value;
                    },
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill in product description";
                      }

                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: 'Product Description',
                    ),
                    style: TextStyle(fontSize: 14),
                    onChanged: (value) {
                      this.productDescription = value;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Map<String, dynamic> products = {
                      'Product Name': this.productName,
                      'Product Description': this.productDescription,
                    };

                    crudObj
                        .updateProduct(selectedDoc, products)
                        .catchError((e) {
                      print(e);
                    });

                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
