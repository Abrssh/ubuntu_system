import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdministratorDatabaseService {
  final CollectionReference administratorCollection =
      FirebaseFirestore.instance.collection("administrator");

  Future<String> checkIfAdministratorExist(String userId) {
    try {
      return administratorCollection.where("uid", isEqualTo: userId).get().then(
          (value) => value.docs.isNotEmpty ? value.docs.first.id : "false");
    } catch (e) {
      debugPrint("CheckIfProfileExist Error: $e");
      return Future.value("false");
    }
  }
}
