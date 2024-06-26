import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/user_acc.dart';

class UserDatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  Future<UserAcc> checkIfUserExist(String userId, String email) async {
    try {
      if (email != "") {
        return userCollection
            .where("email", isEqualTo: email)
            .get()
            .then((value) {
          return value.docs.isNotEmpty
              ? Future.value(UserAcc(
                  userType: value.docs.first.get("userType"),
                  docId: value.docs.first.id))
              : Future.value(UserAcc(userType: "false", docId: "false"));
        });
      }
      return userCollection.where("uid", isEqualTo: userId).get().then(
          (value) => value.docs.isNotEmpty
              ? Future.value(UserAcc(
                  userType: value.docs.first.get("userType"),
                  docId: value.docs.first.id))
              : Future.value(UserAcc(userType: "false", docId: "false")));
    } catch (e) {
      debugPrint("CheckIfUserExist Error: $e");
      return Future.value(UserAcc(docId: "false", userType: "false"));
    }
  }

  Future<bool> createUserAcc(String uid, String userType, String email) {
    try {
      return userCollection
          .doc(uid)
          .set({"uid": uid, "userType": userType, "email": email}).then(
              (value) => true);
    } catch (e) {
      debugPrint("CreateUserAccount Error: $e");
      return Future.value(false);
    }
  }

  Future<bool> updateUserAccUid(String uid, String email) async {
    try {
      bool alreadyUpdated = await userCollection
          .where("uid", isEqualTo: uid)
          .get()
          .then((value) => value.docs.isNotEmpty);
      if (alreadyUpdated) {
        // debugPrint("Already Updated");
        return Future.value(true);
      } else {
        String docId = await userCollection
            .where("email", isEqualTo: email)
            .get()
            .then((value) => value.docs.isNotEmpty ? value.docs.first.id : "");
        if (docId != "") {
          return userCollection
              .doc(docId)
              .update({"uid": uid}).then((value) => Future.value(true));
        } else {
          return Future.value(false);
        }
      }
    } catch (e) {
      debugPrint("CreateUserAccount Error: $e");
      return Future.value(false);
    }
  }
}
