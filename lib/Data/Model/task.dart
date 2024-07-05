class Task {
  final String pcProviderId, employeeId, employeeName, outlierTaskId, taskDocId;
  final double payAmount;
  final int feedback;
  final DateTime createdDate, feedbackDate;

  Task(
      {required this.pcProviderId,
      required this.employeeId,
      required this.employeeName,
      required this.outlierTaskId,
      required this.taskDocId,
      required this.payAmount,
      required this.createdDate,
      required this.feedbackDate,
      required this.feedback});
}
