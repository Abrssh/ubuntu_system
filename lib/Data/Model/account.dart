class Account {
  final String uid, firstName, lastName, city, team, accountType, accountId;

  Account(
      {required this.uid,
      this.accountId = "",
      required this.accountType,
      required this.firstName,
      required this.lastName,
      required this.city,
      required this.team});
}
