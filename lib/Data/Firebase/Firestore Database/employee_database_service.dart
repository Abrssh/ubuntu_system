import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/employee_account.dart';

class EmployeeDatabaseService {
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection("employee");

  List<EmployeeAccount> _mapQuerSnapToEmployee(QuerySnapshot querySnapshot) {
    try {
      List<EmployeeAccount> employees = [];
      Timestamp timestamp1 = querySnapshot.docs.first.get("birthDate");
      Timestamp timestamp2 = querySnapshot.docs.first.get("createdDate");
      DateTime birthDate = timestamp1.toDate();
      DateTime createdDate = timestamp2.toDate();

      employees.add(EmployeeAccount(
          employeeDocId: querySnapshot.docs.first.id,
          uid: querySnapshot.docs.first.get("uid"),
          firstName: querySnapshot.docs.first.get("firstName"),
          lastName: querySnapshot.docs.first.get("lastName"),
          birthdate: birthDate,
          createdDate: createdDate,
          city: querySnapshot.docs.first.get("city"),
          address: querySnapshot.docs.first.get("address"),
          email: querySnapshot.docs.first.get("email"),
          govtId: querySnapshot.docs.first.get("govtId"),
          amountReceived: double.parse(
              querySnapshot.docs.first.get("amountReceived").toString()),
          phoneNumber: querySnapshot.docs.first.get("phoneNumber"),
          status: int.parse(querySnapshot.docs.first.get("status").toString()),
          manager: querySnapshot.docs.first.get("manager"),
          managerId: querySnapshot.docs.first.get("managerId"),
          pcProviderId: querySnapshot.docs.first.get("pcProviderId"),
          team: querySnapshot.docs.first.get("team")));
      return employees;
    } catch (e) {
      debugPrint("Map to employeeacc error: $e");
      return [];
    }
  }

  List<EmployeeAccount> _mapQuerSnapToEmployeeForTL(
      QuerySnapshot querySnapshot) {
    try {
      List<EmployeeAccount> employees = [];
      for (var docSnap in querySnapshot.docs) {
        Timestamp timestamp1 = docSnap.get("birthDate");
        Timestamp timestamp2 = docSnap.get("createdDate");
        DateTime birthDate = timestamp1.toDate();
        DateTime createdDate = timestamp2.toDate();
        employees.add(EmployeeAccount(
            employeeDocId: docSnap.id,
            uid: docSnap.get("uid"),
            firstName: docSnap.get("firstName"),
            lastName: docSnap.get("lastName"),
            birthdate: birthDate,
            createdDate: createdDate,
            city: docSnap.get("city"),
            address: docSnap.get("address"),
            email: docSnap.get("email"),
            govtId: docSnap.get("govtId"),
            amountReceived:
                double.parse(docSnap.get("amountReceived").toString()),
            phoneNumber: docSnap.get("phoneNumber"),
            status: int.parse(docSnap.get("status").toString()),
            manager: docSnap.get("manager"),
            managerId: docSnap.get("managerId"),
            pcProviderId: docSnap.get("pcProviderId"),
            team: docSnap.get("team")));
      }

      return employees;
    } catch (e) {
      debugPrint("Map to employeeacc error: $e");
      return [];
    }
  }

  Future<bool> createEmployeeAccount(EmployeeAccount employeeAccount) {
    try {
      return employeeCollection.doc().set({
        "uid": employeeAccount.uid,
        "firstName": employeeAccount.firstName,
        "lastName": employeeAccount.lastName,
        "birthDate": Timestamp.fromDate(employeeAccount.birthdate),
        "govtId": employeeAccount.govtId,
        "city": employeeAccount.city,
        "address": employeeAccount.address,
        "email": employeeAccount.email,
        "phoneNumber": employeeAccount.phoneNumber,
        "status": employeeAccount.status,
        "team": employeeAccount.team,
        "pcProviderId": employeeAccount.pcProviderId,
        "managerId": employeeAccount.managerId,
        "manager": employeeAccount.manager,
        "amountReceived": employeeAccount.amountReceived,
        "createdDate": Timestamp.fromDate(employeeAccount.createdDate)
      }).then((value) => true);
    } catch (e) {
      debugPrint("CreateEmployeeAccount Error: $e");
      return Future.value(false);
    }
  }

  Stream<List<EmployeeAccount>> getEmployee(String uid) {
    try {
      return employeeCollection
          .where("uid", isEqualTo: uid)
          .snapshots()
          .map(_mapQuerSnapToEmployee);
    } catch (e) {
      debugPrint("GetEmployee: $e");
      return Stream<List<EmployeeAccount>>.value([]);
    }
  }

  Stream<List<EmployeeAccount>> getEmployeesForTL() {
    try {
      return employeeCollection.snapshots().map(_mapQuerSnapToEmployeeForTL);
    } catch (e) {
      debugPrint("GetEmployeesForTL: $e");
      return Stream.value([]);
    }
  }
}
