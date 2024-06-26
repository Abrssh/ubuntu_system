import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/employee_account.dart';

class EmployeeDatabaseService {
  final CollectionReference employeeCollection =
      FirebaseFirestore.instance.collection("employee");

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
        "amountReceived": employeeAccount.amountReceived
      }).then((value) => true);
    } catch (e) {
      debugPrint("CreateEmployeeAccount Error: $e");
      return Future.value(false);
    }
  }
}
