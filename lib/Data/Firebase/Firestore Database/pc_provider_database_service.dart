import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';

class PcProviderDatabaseService {
  final CollectionReference pcProviderCollection =
      FirebaseFirestore.instance.collection("pcProvider");

  Future<bool> createPcProviderAccount(PcProvider pcProvider) {
    try {
      return pcProviderCollection.doc().set({
        "uid": pcProvider.uid,
        "firstName": pcProvider.firstName,
        "lastName": pcProvider.lastName,
        "birthDate": Timestamp.fromDate(pcProvider.birthDate),
        "govtId": pcProvider.govtId,
        "country": pcProvider.country,
        "state": pcProvider.state,
        "city": pcProvider.city,
        "streetAddress": pcProvider.streetaddress,
        "email": pcProvider.email,
        "phoneNumber": pcProvider.phoneNumber,
        "team": pcProvider.team,
        "zipCode": pcProvider.zipCode,
        "formStatus": pcProvider.formstatus,
        "formHistory": pcProvider.formHistory,
        "accountStatus": pcProvider.accountStatus,
        "totalAmountEarned": pcProvider.totalAmountEarned,
        "PersonalAmountEarned": pcProvider.personalAmountEarned
      }).then((value) => true);
    } catch (e) {
      debugPrint("CreatePcProviderAccount Error: $e");
      return Future.value(false);
    }
  }
}
