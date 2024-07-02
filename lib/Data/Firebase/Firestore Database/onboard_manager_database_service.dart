import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/on_boarding_manager.dart';

class OnboardingManagerDatabaseService {
  final CollectionReference onboardingManagerCollection =
      FirebaseFirestore.instance.collection("onBoardingManager");
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");

  List<OnBoardingManager> _mapQuerSnapToOnboardManager(
      QuerySnapshot querySnapshot) {
    try {
      List<OnBoardingManager> onBoardingManagers = [];
      onBoardingManagers.add(OnBoardingManager(
          uid: "",
          onBoardManDocID: querySnapshot.docs.first.id,
          firstName: querySnapshot.docs.first.get("firstName"),
          lastName: querySnapshot.docs.first.get("lastName"),
          govtId: querySnapshot.docs.first.get("govtId"),
          city: querySnapshot.docs.first.get("city"),
          address: querySnapshot.docs.first.get("address"),
          email: querySnapshot.docs.first.get("email"),
          phoneNumber: querySnapshot.docs.first.get("phoneNumber")));
      return onBoardingManagers;
    } catch (e) {
      debugPrint("MapToOnboardManager error: $e");
      return [];
    }
  }

  Future<bool?> createOnboardingManager(
      OnBoardingManager onBoardingManager) async {
    try {
      Map<String, bool> transactionReturn =
          await FirebaseFirestore.instance.runTransaction((transaction) {
        transaction.set(userCollection.doc(), {
          "userType": "onboardingmanager",
          "email": onBoardingManager.email
        });
        transaction.set(onboardingManagerCollection.doc(), {
          "email": onBoardingManager.email,
          "firstName": onBoardingManager.firstName,
          "lastName": onBoardingManager.lastName,
          "govtId": onBoardingManager.govtId,
          "phoneNumber": onBoardingManager.phoneNumber,
          "city": onBoardingManager.city,
          "address": onBoardingManager.address,
        });
        return Future.value({"val": true});
      });
      return transactionReturn["val"];
    } catch (e) {
      debugPrint("CreateOnboardManager: $e");
      return Future.value(false);
    }
  }

  Future<List<OnBoardingManager>> getOnboardingManager(
      String uid, String email) {
    try {
      return onboardingManagerCollection
          .where("email", isEqualTo: email)
          .get()
          .then(_mapQuerSnapToOnboardManager);
    } catch (e) {
      debugPrint("GetOnboardingManager error: $e");
      return Future.value([]);
    }
  }
}
