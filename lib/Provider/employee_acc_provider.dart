import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/employee_account.dart';

class EmployeeAccProvider extends ChangeNotifier {
  EmployeeAccount? _employeeAccount;
  EmployeeAccount? get employeeAccVal => _employeeAccount;

  assignEmployeeAcc(EmployeeAccount employeeAccount) {
    _employeeAccount = employeeAccount;
  }
}
