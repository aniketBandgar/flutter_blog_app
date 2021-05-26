import 'package:cloud_firestore/cloud_firestore.dart';

class Crud {
  Future<void> addData(Map<String, String> blogMap) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('blogs').add(blogMap).catchError((error) {
      print("Failed to add user: $error");
    });
  }
}
