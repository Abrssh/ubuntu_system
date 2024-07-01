class EmployeeAccount {
  final String uid,
      employeeDocId,
      firstName,
      lastName,
      city,
      address,
      govtId,
      email,
      phoneNumber,
      team,
      pcProviderId,
      pcProviderName,
      managerId,
      managerName;
  bool manager;
  // 0 has pc provider, 1 has no pc provider
  final int status;
  final double amountReceived;

  DateTime birthdate, createdDate;

  EmployeeAccount(
      {required this.uid,
      this.employeeDocId = "",
      required this.firstName,
      required this.lastName,
      required this.birthdate,
      required this.createdDate,
      required this.city,
      required this.address,
      required this.email,
      required this.govtId,
      required this.amountReceived,
      required this.phoneNumber,
      required this.status,
      required this.manager,
      required this.managerId,
      required this.managerName,
      required this.pcProviderId,
      required this.pcProviderName,
      required this.team});
}
