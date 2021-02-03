import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  addUsers(user, docId) async {
    return await db.collection('Users').doc(docId).set(user).catchError((e) {
      print(e);
    });
  }

  Future<void> addProducts(productData) async {
    if (isLoggedIn()) {
      db.collection('Products').add(productData).catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged in');
    }
  }

  getData() async {
    return db.collection('Products').orderBy('Product Name').snapshots();
  }

  updateProduct(selectedDoc, newValues) async {
    return await db
        .collection('Products')
        .doc(selectedDoc)
        .update(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteProduct(docID) async {
    return await db.collection('Products').doc(docID).delete().catchError((e) {
      print(e);
    });
  }
}
