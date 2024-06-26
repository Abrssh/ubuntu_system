import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdministratorDatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  Future<String> checkIfUserExist(String userId) {
    try {
      return userCollection.where("uid", isEqualTo: userId).get().then(
          (value) => value.docs.isNotEmpty
              ? value.docs.first.get("userType")
              : "false");
    } catch (e) {
      debugPrint("CheckIfUserExist Error: $e");
      return Future.value("false");
    }
  }
}
