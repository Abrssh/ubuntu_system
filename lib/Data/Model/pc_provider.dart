class PcProvider {
  final String uid,
      pcProviderDocId,
      firstName,
      lastName,
      govtId,
      country,
      state,
      city,
      streetaddress,
      email,
      phoneNumber,
      team;

  final DateTime birthDate;

  // accountstatus 0 EQ, 1 teamviewer disconnected, 2 verify email and 3 active/tasking
  // form status 0 Ready to onboard, 1 onboarded, 2 ready to apply, 3 applied, 4 ready to setup and 5 ready to be active
  final int zipCode, formstatus, accountStatus;
  final double totalAmountEarned, personalAmountEarned;

  // int = form status and dynamic equals [manager/adminstrator id, datetime]
  final Map<int, Map<String, DateTime>> formHistory;

  PcProvider(
      {required this.uid,
      required this.pcProviderDocId,
      required this.firstName,
      required this.lastName,
      required this.birthDate,
      required this.govtId,
      required this.country,
      required this.state,
      required this.city,
      required this.streetaddress,
      required this.email,
      required this.phoneNumber,
      required this.team,
      required this.zipCode,
      required this.formstatus,
      required this.formHistory,
      required this.accountStatus,
      required this.totalAmountEarned,
      required this.personalAmountEarned});
}
