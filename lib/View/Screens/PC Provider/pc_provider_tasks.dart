import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Model/task.dart';

class PCProviderTasks extends StatefulWidget {
  const PCProviderTasks({super.key});

  @override
  State<PCProviderTasks> createState() => _PCProviderTasksState();
}

class _PCProviderTasksState extends State<PCProviderTasks> {
  late List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks Done On this PC'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Task ID: ${task.outlierTaskId}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Employee ID: ${task.employeeId}'),
                  Text('Amount Earned: \$${task.payAmount.toStringAsFixed(2)}'),
                  Text('Created Date: ${task.createdDate.toString()}'),
                  Text('Feedback Date: ${task.feedbackDate.toString()}'),
                  Text('Feedback: ${task.feedback}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



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
