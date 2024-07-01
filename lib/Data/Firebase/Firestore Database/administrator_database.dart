import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/administrator.dart';

class AdministratorDatabaseService {
  final CollectionReference administratorCollection =
      FirebaseFirestore.instance.collection("administrator");

  List<Administrator> _mapQuerSnapToAdministrator(QuerySnapshot querySnapshot) {
    try {
      List<Administrator> administrators = [];
      administrators.add(Administrator(
          adminDocId: querySnapshot.docs.first.id,
          // uid: querySnapshot.docs.first.get("uid"),
          uid: "",
          firstName: querySnapshot.docs.first.get("firstName"),
          lastName: querySnapshot.docs.first.get("lastName"),
          email: querySnapshot.docs.first.get("email")));
      return administrators;
    } catch (e) {
      debugPrint("MapQuerToAdministrator error: $e");
      return [];
    }
  }

  Future<List<Administrator>> getAdministrator(String email) {
    try {
      return administratorCollection
          // .where("uid", isEqualTo: uid)
          .where("email", isEqualTo: email)
          .get()
          .then(_mapQuerSnapToAdministrator);
    } catch (e) {
      debugPrint("GetAdministrator error: $e");
      return Future<List<Administrator>>.value([]);
    }
  }

  Future<bool> updateAdminUid(String uid, String email) async {
    try {
      bool alreadyUpdated = await administratorCollection
          .where("uid", isEqualTo: uid)
          .get()
          .then((value) => value.docs.isNotEmpty);
      if (alreadyUpdated) {
        // debugPrint("Already Updated");
        return Future.value(true);
      } else {
        String docId = await administratorCollection
            .where("email", isEqualTo: email)
            .get()
            .then((value) => value.docs.isNotEmpty ? value.docs.first.id : "");
        if (docId != "") {
          return administratorCollection
              .doc(docId)
              .update({"uid": uid}).then((value) => Future.value(true));
        } else {
          return Future.value(false);
        }
      }
    } catch (e) {
      debugPrint("UpdateAdminUid Error: $e");
      return Future.value(false);
    }
  }
}
