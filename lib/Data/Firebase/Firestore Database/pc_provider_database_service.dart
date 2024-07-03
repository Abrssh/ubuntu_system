import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';

class PcProviderDatabaseService {
  final CollectionReference pcProviderCollection =
      FirebaseFirestore.instance.collection("pcProvider");
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection("employee");

  List<PcProvider> _mapQuerSnapToPcProvider(QuerySnapshot querySnapshot) {
    try {
      List<PcProvider> pcProviders = [];
      // Used list so that i can use the try catch
      Timestamp timestamp1 = querySnapshot.docs.first.get("birthDate");
      Timestamp timestamp2 = querySnapshot.docs.first.get("createdDate");
      Timestamp timestamp3 = querySnapshot.docs.first.get("lastUpdatedOn");
      DateTime birthDate = timestamp1.toDate();
      DateTime createdDate = timestamp2.toDate();
      DateTime lastUpdatedOn = timestamp3.toDate();

      // Map<String, dynamic> formHistory =
      //     querySnapshot.docs.first.get("formHistory");
      // debugPrint("Form History: $formHistory");
      pcProviders.add(PcProvider(
          uid: querySnapshot.docs.first.get("uid"),
          pcProviderDocId: querySnapshot.docs.first.id,
          employeeId: querySnapshot.docs.first.get("employeeId"),
          employeeName: querySnapshot.docs.first.get("employeeName"),
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
          // formHistory: {},
          lastUpdatedBy: querySnapshot.docs.first.get("lastUpdatedBy"),
          lastUpdatedOn: lastUpdatedOn,
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
        Timestamp timestamp3 = docSnap.get("lastUpdatedOn");
        DateTime birthDate = timestamp1.toDate();
        DateTime createdDate = timestamp2.toDate();
        DateTime lastUpdatedOn = timestamp3.toDate();

        // Map<String, dynamic> formHistory = docSnap.get("formHistory");
        // debugPrint("Form History: $formHistory");
        pcProviders.add(PcProvider(
            uid: docSnap.get("uid"),
            pcProviderDocId: docSnap.id,
            employeeId: docSnap.get("employeeId"),
            employeeName: docSnap.get("employeeName"),
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
            // formHistory: {},
            lastUpdatedBy: docSnap.get("lastUpdatedBy"),
            lastUpdatedOn: lastUpdatedOn,
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
        "employeeId": pcProvider.employeeId,
        "employeeName": pcProvider.employeeName,
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
        // "formHistory": pcProvider.formHistory,
        "lastUpdatedBy": pcProvider.lastUpdatedBy,
        "lastUpdatedOn": pcProvider.lastUpdatedOn,
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

  Stream<List<PcProvider>> getPcProvidersForAdmin() {
    try {
      return pcProviderCollection
          .snapshots()
          .map(_mapQuerSnapToPcProvidersForTL);
    } catch (e) {
      debugPrint("GetPcProvidersForTL: $e");
      return Stream.value([]);
    }
  }

  Stream<List<PcProvider>> getFormsForOnboardManager() {
    try {
      return pcProviderCollection
          .where("formStatus", isLessThan: 5)
          .snapshots()
          .map(_mapQuerSnapToPcProvidersForTL);
    } catch (e) {
      debugPrint("GetFormsForOnboardManager: $e");
      return Stream.value([]);
    }
  }

  Future<bool?> assignEmployee(String pcDocId, pcProviderName,
      String employeeId, String employeeName) async {
    try {
      Map<String, bool> transactionReturn =
          await FirebaseFirestore.instance.runTransaction((transaction) async {
        QuerySnapshot querySnapshot = await employeeCollection
            .where("pcProviderId", isEqualTo: pcDocId)
            .get();
        transaction
            .update(employeeCollection.doc(querySnapshot.docs.first.id), {
          "pcProviderId": "",
          "pcProviderName": "",
        });
        transaction.update(pcProviderCollection.doc(pcDocId),
            {"employeeId": employeeId, "employeeName": employeeName});
        transaction.update(employeeCollection.doc(employeeId), {
          "pcProviderId": pcDocId,
          "pcProviderName": pcProviderName,
        });
        return Future.value({"val": true});
      });
      return transactionReturn["val"];
    } catch (e) {
      debugPrint("AssignEmployee Error: $e");
      return Future.value(false);
    }
  }

  Future<bool> updateFormStatus(
      String pcProvDocId, int formStatus, String updaterId) {
    try {
      return pcProviderCollection.doc(pcProvDocId).update({
        "formStatus": formStatus,
        "lastUpdatedBy": updaterId,
        "lastUpdatedOn": Timestamp.now()
      }).then((value) => true);
    } catch (e) {
      debugPrint("UpdateFormStatus: $e");
      return Future.value(false);
    }
  }

  Future<bool> updatePcAccountStatus(String pcProvDocId, int status) {
    try {
      return pcProviderCollection
          .doc(pcProvDocId)
          .update({"accountStatus": status}).then((value) => true);
    } catch (e) {
      debugPrint("UpdatePcAccountStatus: $e");
      return Future.value(false);
    }
  }
}
