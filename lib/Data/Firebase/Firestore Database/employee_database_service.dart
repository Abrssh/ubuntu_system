import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Interface/employee_repository.dart';
import 'package:ubuntu_system/Data/Model/employee_account.dart';

class EmployeeDatabaseService implements EmployeeRepository {
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
          managerName: querySnapshot.docs.first.get("managerName"),
          pcProviderId: querySnapshot.docs.first.get("pcProviderId"),
          pcProviderName: querySnapshot.docs.first.get("pcProviderName"),
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
            managerName: docSnap.get("managerName"),
            pcProviderId: docSnap.get("pcProviderId"),
            pcProviderName: docSnap.get("pcProviderName"),
            team: docSnap.get("team")));
      }

      return employees;
    } catch (e) {
      debugPrint("Map to employeeacc error: $e");
      return [];
    }
  }

  @override
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
        "pcProviderName": employeeAccount.pcProviderName,
        "managerId": employeeAccount.managerId,
        "managerName": employeeAccount.managerName,
        "manager": employeeAccount.manager,
        "amountReceived": employeeAccount.amountReceived,
        "createdDate": Timestamp.fromDate(employeeAccount.createdDate)
      }).then((value) => true);
    } catch (e) {
      debugPrint("CreateEmployeeAccount Error: $e");
      return Future.value(false);
    }
  }

  @override
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

  @override
  Stream<List<EmployeeAccount>> getEmployeesForTL(String managerId) {
    try {
      return employeeCollection
          .where("managerId", isEqualTo: managerId)
          .snapshots()
          .map(_mapQuerSnapToEmployeeForTL);
    } catch (e) {
      debugPrint("GetEmployeesForTL: $e");
      return Stream.value([]);
    }
  }

  @override
  Stream<List<EmployeeAccount>> getEmployeesForAdmin() {
    try {
      return employeeCollection.snapshots().map(_mapQuerSnapToEmployeeForTL);
    } catch (e) {
      debugPrint("GetEmployeesForTL: $e");
      return Stream.value([]);
    }
  }

  @override
  Future<bool?> assignEmployeeManager(String employeeId, String managerName,
      bool isManager, List<String> employeesAssignedToManager) async {
    try {
      Map<String, bool> transactionReturn =
          await FirebaseFirestore.instance.runTransaction((transaction) async {
        QuerySnapshot employeeQuerSnap = await employeeCollection
            .where("managerId", isEqualTo: employeeId)
            .get();

        if (isManager) {
          for (var assignedEmployeeId in employeesAssignedToManager) {
            transaction.update(employeeCollection.doc(assignedEmployeeId), {
              "managerId": employeeId,
              "managerName": managerName,
              "manager": false
            });
          }
          transaction.update(employeeCollection.doc(employeeId),
              {"manager": isManager, "managerId": "", "managerName": ""});
        } else {
          for (var docSnap in employeeQuerSnap.docs) {
            transaction.update(employeeCollection.doc(docSnap.id),
                {"managerId": "", "managerName": ""});
          }
          transaction.update(
              employeeCollection.doc(employeeId), {"manager": isManager});
        }
        return Future.value({"val": true});
      });
      return transactionReturn["val"];
    } catch (e) {
      debugPrint("AssignEmployeeManager error: $e");
      return Future.value(false);
    }
  }
}
