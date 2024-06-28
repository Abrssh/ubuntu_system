import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';

class PcProviderDatabaseService {
  final CollectionReference pcProviderCollection =
      FirebaseFirestore.instance.collection("pcProvider");

  List<PcProvider> _mapQuerSnapToPcProvider(QuerySnapshot querySnapshot) {
    try {
      // Used list so that i can use the try catch
      List<PcProvider> pcProviders = [];
      Timestamp timestamp1 = querySnapshot.docs.first.get("birthDate");
      Timestamp timestamp2 = querySnapshot.docs.first.get("createdDate");
      DateTime birthDate = timestamp1.toDate();
      DateTime createdDate = timestamp2.toDate();

      Map<String, dynamic> formHistory =
          querySnapshot.docs.first.get("formHistory");
      debugPrint("Form History: $formHistory");
      pcProviders.add(PcProvider(
          uid: querySnapshot.docs.first.get("uid"),
          pcProviderDocId: querySnapshot.docs.first.id,
          firstName: querySnapshot.docs.first.get("firstName"),
          lastName: querySnapshot.docs.first.get("lastName"),
          birthDate: birthDate,
          createdDate: createdDate,
          govtId: querySnapshot.docs.first.get("govtId"),
          country: querySnapshot.docs.first.get("country"),
          state: querySnapshot.docs.first.get("state"),
          city: querySnapshot.docs.first.get("city"),
          streetaddress: querySnapshot.docs.first.get("streetAddress"),
          email: querySnapshot.docs.first.get("email"),
          phoneNumber: querySnapshot.docs.first.get("phoneNumber"),
          team: querySnapshot.docs.first.get("team"),
          zipCode: querySnapshot.docs.first.get("zipCode"),
          formstatus: querySnapshot.docs.first.get("formStatus"),
          formHistory: {},
          accountStatus: int.parse(
              querySnapshot.docs.first.get("accountStatus").toString()),
          totalAmountEarned: double.parse(
              querySnapshot.docs.first.get("totalAmountEarned").toString()),
          personalAmountEarned: double.parse(querySnapshot.docs.first
              .get("personalAmountEarned")
              .toString())));
      return pcProviders;
    } catch (e) {
      debugPrint("Pc Provider mapping error: $e");
      return [];
    }
  }

  List<PcProvider> _mapQuerSnapToPcProvidersForTL(QuerySnapshot querySnapshot) {
    try {
      // Used list so that i can use the try catch
      List<PcProvider> pcProviders = [];
      for (var docSnap in querySnapshot.docs) {
        Timestamp timestamp1 = docSnap.get("birthDate");
        Timestamp timestamp2 = docSnap.get("createdDate");
        DateTime birthDate = timestamp1.toDate();
        DateTime createdDate = timestamp2.toDate();

        Map<String, dynamic> formHistory = docSnap.get("formHistory");
        debugPrint("Form History: $formHistory");
        pcProviders.add(PcProvider(
            uid: docSnap.get("uid"),
            pcProviderDocId: docSnap.id,
            firstName: docSnap.get("firstName"),
            lastName: docSnap.get("lastName"),
            birthDate: birthDate,
            createdDate: createdDate,
            govtId: docSnap.get("govtId"),
            country: docSnap.get("country"),
            state: docSnap.get("state"),
            city: docSnap.get("city"),
            streetaddress: docSnap.get("streetAddress"),
            email: docSnap.get("email"),
            phoneNumber: docSnap.get("phoneNumber"),
            team: docSnap.get("team"),
            zipCode: docSnap.get("zipCode"),
            formstatus: docSnap.get("formStatus"),
            formHistory: {},
            accountStatus: int.parse(docSnap.get("accountStatus").toString()),
            totalAmountEarned:
                double.parse(docSnap.get("totalAmountEarned").toString()),
            personalAmountEarned:
                double.parse(docSnap.get("personalAmountEarned").toString())));
      }
      return pcProviders;
    } catch (e) {
      debugPrint("Pc Provider mapping error: $e");
      return [];
    }
  }

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
        "personalAmountEarned": pcProvider.personalAmountEarned,
        "createdDate": Timestamp.fromDate(pcProvider.createdDate)
      }).then((value) => true);
    } catch (e) {
      debugPrint("CreatePcProviderAccount Error: $e");
      return Future.value(false);
    }
  }

  Stream<List<PcProvider>> getPcProvider(String uid) {
    try {
      return pcProviderCollection
          .where("uid", isEqualTo: uid)
          .snapshots()
          .map(_mapQuerSnapToPcProvider);
    } catch (e) {
      debugPrint("GetPcProvider error: $e");
      return Stream<List<PcProvider>>.value([]);
    }
  }

  Stream<int> getPcProviderStatus(String pcProvDocId) {
    try {
      return pcProviderCollection
          .doc(pcProvDocId)
          .snapshots()
          .map((event) => int.parse(event.get("accountStatus").toString()));
    } catch (e) {
      debugPrint("GetPcProviderStatus error: $e");
      return Stream.value(0);
    }
  }

  Stream<List<PcProvider>> getPcProvidersForTL() {
    try {
      return pcProviderCollection
          .snapshots()
          .map(_mapQuerSnapToPcProvidersForTL);
    } catch (e) {
      debugPrint("GetPcProvidersForTL: $e");
      return Stream.value([]);
    }
  }
}
