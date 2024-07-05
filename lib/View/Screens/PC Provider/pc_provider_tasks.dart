// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/task_database_service.dart';
// import 'package:ubuntu_system/Data/Model/task.dart';
// import 'package:ubuntu_system/Provider/pc_provider_provider_class.dart';
// import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

// class PCProviderTasks extends StatefulWidget {
//   const PCProviderTasks({super.key});

//   @override
//   State<PCProviderTasks> createState() => _PCProviderTasksState();
// }

// class _PCProviderTasksState extends State<PCProviderTasks> {
//   late List<Task> tasks = [];

//   bool loading = false;

//   DateFormat dateFormat = DateFormat("yMd");

//   @override
//   void initState() {
//     super.initState();
//     var pcProv = context.read<PCProviderClass>();
//     TaskDatabaseService()
//         .getTasksForPcProvider(pcProv.pcProviderVal!.pcProviderDocId)
//         .then((value) {
//       tasks.addAll(value);
//       setState(() {
//         loading = true;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double deviceHeight = MediaQuery.of(context).size.height;
//     final double deviceWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tasks Done On this PC'),
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
//                           Text('Employee Name: ${task.employeeName}',),
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

// Alternative

// class TaskListPage extends StatelessWidget {
//   final List<Task> tasks;

//   TaskListPage({required this.tasks});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Task List'),
//         backgroundColor: Colors.black,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue, Colors.purple],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: ListView.builder(
//           itemCount: tasks.length,
//           itemBuilder: (context, index) {
//             final task = tasks[index];
//             return Card(
//               elevation: 2,
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               color: Colors.transparent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12), // Rounded corners
//                 side: BorderSide(color: Colors.white, width: 1), // White border
//               ),
//               child: ListTile(
//                 title: Text(
//                   'Task ID: ${task.outlierTaskId}',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('PC Provider ID: ${task.pcProviderId}', style: TextStyle(color: Colors.white)),
//                     Text('Employee ID: ${task.employeeId}', style: TextStyle(color: Colors.white)),
//                     Text('Amount Earned: \$${task.amountEarned.toStringAsFixed(2)}', style: TextStyle(color: Colors.white)),
//                     Text('Created Date: ${task.createdDate.toString()}', style: TextStyle(color: Colors.white)),
//                     Text('Feedback Date: ${task.feedbackDate.toString()}', style: TextStyle(color: Colors.white)),
//                     Text('Feedback: ${task.feedback}', style: TextStyle(color: Colors.white)),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart'; // Import foundation library to use kIsWeb
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/task_database_service.dart';
import 'package:ubuntu_system/Data/Model/task.dart';
import 'package:ubuntu_system/Provider/pc_provider_provider_class.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

class PCProviderTasks extends StatefulWidget {
  const PCProviderTasks({super.key});

  @override
  State<PCProviderTasks> createState() => _PCProviderTasksState();
}

class _PCProviderTasksState extends State<PCProviderTasks> {
  late List<Task> tasks = [];

  bool loading = false;

  DateFormat dateFormat = DateFormat("yMd");

  @override
  void initState() {
    super.initState();
    var pcProv = context.read<PCProviderClass>();
    TaskDatabaseService()
        .getTasksForPcProvider(pcProv.pcProviderVal!.pcProviderDocId)
        .then((value) {
      tasks.addAll(value);
      setState(() {
        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    const bool isWeb = kIsWeb; // Check if running on web

    // Adjust card elevation and layout based on the platform
    double cardElevation = isWeb ? 1.0 : deviceWidth * 0.04;
    double fontSize = isWeb
        ? 16.0
        : deviceWidth * 0.045; // Adjust font size for better readability

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks Done On this PC'),
        centerTitle: true,
      ),
      body: loading
          ? SizedBox(
              height: deviceHeight * 0.9,
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    elevation: cardElevation,
                    margin: const EdgeInsets.symmetric(
                      horizontal: isWeb ? 20.0 : 10.0, // Horizontal margin
                      vertical: isWeb ? 10.0 : 5.0, // Vertical margin
                    ),
                    child: ListTile(
                      title: Text(
                        'Task ID: ${task.outlierTaskId}',
                        style: TextStyle(fontSize: fontSize),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Employee Name: ${task.employeeName}',
                            style: TextStyle(fontSize: fontSize),
                          ),
                          Text(
                            'Amount Earned: \$${task.payAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: fontSize),
                          ),
                          Text(
                            'Created Date: ${dateFormat.format(task.createdDate)}',
                            style: TextStyle(fontSize: fontSize),
                          ),
                          Text(
                            'Feedback Date: ${dateFormat.format(task.feedbackDate)}',
                            style: TextStyle(fontSize: fontSize),
                          ),
                          Text(
                            'Feedback: ${task.feedback == 99 ? 'N/A' : task.feedback}',
                            style: TextStyle(fontSize: fontSize),
                          ),
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
