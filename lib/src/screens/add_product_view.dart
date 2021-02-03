import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/services/crud.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String productName, productDescription, searchKey;
  final auth = FirebaseAuth.instance;

  CrudMethods crudObj = new CrudMethods();

  var _productController = TextEditingController();
  var _descController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill in the  product name";
                  }

                  return null;
                },
                controller: _productController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: 'Product Name'),
                onChanged: (value) {
                  this.productName = value;
                  this.searchKey = value[0];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill in the product description";
                  }

                  return null;
                },
                controller: _descController,
                textCapitalization: TextCapitalization.words,
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.start,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
                onChanged: (value) {
                  this.productDescription = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 45,
                width: 130,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text('Add'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Fluttertoast.showToast(
                          msg: "New Product Added",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      Map<String, dynamic> productData = {
                        'Product Name': this.productName,
                        'Product Description': this.productDescription,
                        'Search Key': this.searchKey
                      };
                      crudObj
                          .addProducts(productData)
                          .then((result) {})
                          .catchError((e) {
                        print(e);
                      }).whenComplete(() {
                        //_productController.clear();
                        //_descController.clear();

                        Navigator.of(context).pop();
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
