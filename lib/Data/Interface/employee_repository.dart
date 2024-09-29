import 'package:ubuntu_system/Data/Model/employee_account.dart';

abstract class EmployeeRepository {
  Stream<List<EmployeeAccount>> getEmployee(String uid);
  Stream<List<EmployeeAccount>> getEmployeesForTL(String managerId);
  Stream<List<EmployeeAccount>> getEmployeesForAdmin();
  Future<bool> createEmployeeAccount(EmployeeAccount employeeAccount);
  Future<bool?> assignEmployeeManager(String employeeId, String managerName,
      bool isManager, List<String> employeesAssignedToManager);
}
