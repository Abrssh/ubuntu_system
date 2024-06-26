class Task {
  final String pcProviderId, employeeId, outlierTaskId, taskDocId;
  final double payAmount;
  final int feedback;

  Task(
      {required this.pcProviderId,
      required this.employeeId,
      required this.outlierTaskId,
      required this.taskDocId,
      required this.payAmount,
      required this.feedback});
}
