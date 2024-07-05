// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/task_database_service.dart';
// import 'package:ubuntu_system/Data/Model/task.dart';
// import 'package:ubuntu_system/Provider/employee_acc_provider.dart';
// import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

// class EmployeeTasks extends StatefulWidget {
//   const EmployeeTasks({super.key});

//   @override
//   State<EmployeeTasks> createState() => _EmployeeTasksState();
// }

// class _EmployeeTasksState extends State<EmployeeTasks> {
//   late List<Task> tasks = [];

//   bool loading = false;

//   @override
//   void initState() {
//     super.initState();
//     var empProv = context.read<EmployeeAccProvider>();
//     TaskDatabaseService()
//         .getTasksForEmployee(empProv.employeeAccVal!.employeeDocId)
//         .then((value) {
//       tasks.addAll(value);
//       setState(() {
//         loading = true;
//       });
//     });
//   }

//   DateFormat dateFormat = DateFormat("yMd");

//   @override
//   Widget build(BuildContext context) {
//     final double deviceHeight = MediaQuery.of(context).size.height;
//     final double deviceWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tasks Done'),
//         centerTitle: true,
//       ),
//       body: loading
//           ? SizedBox(
//               height: deviceHeight * 0.9,
//               child: ListView.builder(
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = tasks[index];
//                   return Card(
//                     elevation: deviceWidth * 0.04,
//                     child: ListTile(
//                       title: Text('Task ID: ${task.outlierTaskId}'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                               'Amount Earned: \$${task.payAmount.toStringAsFixed(2)}'),
//                           Text(
//                               'Created Date: ${dateFormat.format(task.createdDate)}'),
//                           Text(
//                               'Feedback Date: ${dateFormat.format(task.feedbackDate)}'),
//                           Text(
//                               'Feedback: ${task.feedback == 99 ? 'N/A' : task.feedback}'),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             )
//           : const LoadingAnimation2(),
//     );
//   }
// }

import 'package:flutter/foundation.dart'; // Import foundation library to use kIsWeb
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/task_database_service.dart';
import 'package:ubuntu_system/Data/Model/task.dart';
import 'package:ubuntu_system/Provider/employee_acc_provider.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

class EmployeeTasks extends StatefulWidget {
  const EmployeeTasks({super.key});

  @override
  State<EmployeeTasks> createState() => _EmployeeTasksState();
}

class _EmployeeTasksState extends State<EmployeeTasks> {
  late List<Task> tasks = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    var empProv = context.read<EmployeeAccProvider>();
    TaskDatabaseService()
        .getTasksForEmployee(empProv.employeeAccVal!.employeeDocId)
        .then((value) {
      tasks.addAll(value);
      setState(() {
        loading = true;
      });
    });
  }

  DateFormat dateFormat = DateFormat("yMd");

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    const isWeb = kIsWeb; // Determine if running on web

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks Done'),
        centerTitle: true,
      ),
      body: loading
          ? SizedBox(
              height: deviceHeight *
                  (isWeb ? 1.0 : 0.9), // Adjust height based on platform
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    elevation: isWeb
                        ? 2
                        : deviceWidth *
                            0.04, // Adjust elevation based on platform
                    margin: isWeb
                        ? const EdgeInsets.all(10)
                        : EdgeInsets.zero, // Adjust margin for web
                    child: ListTile(
                      title: Text('Task ID: ${task.outlierTaskId}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Amount Earned: \$${task.payAmount.toStringAsFixed(2)}'),
                          Text(
                              'Created Date: ${dateFormat.format(task.createdDate)}'),
                          Text(
                              'Feedback Date: ${dateFormat.format(task.feedbackDate)}'),
                          Text(
                              'Feedback: ${task.feedback == 99 ? 'N/A' : task.feedback}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : const LoadingAnimation2(),
    );
  }
}
