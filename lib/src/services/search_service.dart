import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  searchByName(String searchField) {
    return db
        .collection('Products')
        .orderBy('Product Name')
        .where('Search Key',
            isEqualTo: searchField.substring(0, 1).toLowerCase())
        .get();
  }
}
