import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/task_database_service.dart';
import 'package:ubuntu_system/Data/Model/task.dart';
import 'package:ubuntu_system/Provider/employee_acc_provider.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  late String outlierTaskId;
  late double amountEarned;

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    double deviceWidth = deviceSize.width;
    double deviceHeight = deviceSize.height;

    return SizedBox(
      width: deviceWidth,
      height: deviceHeight * 0.5,
      child: loading
          ? Padding(
              padding: EdgeInsets.all(deviceWidth * 0.04),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(deviceWidth * 0.1),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Add a Task",
                          style: TextStyle(
                              fontSize: deviceWidth * 0.055,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.03,
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: deviceWidth * 0.01),
                          decoration: InputDecoration(
                              iconColor: Colors.white,
                              labelText: 'Task ID',
                              border: const OutlineInputBorder(),
                              labelStyle:
                                  TextStyle(fontSize: deviceWidth * 0.04)),
                          validator: (value) =>
                              value!.isEmpty ? "Enter Task ID" : null,
                          onChanged: (value) {
                            setState(() {
                              outlierTaskId = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        TextFormField(
                          // style: TextStyle(
                          //   fontSize: deviceWidth * 0.01,
                          // ),
                          decoration: const InputDecoration(
                            iconColor: Colors.white,
                            labelText: 'Amount Earned',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty || double.tryParse(value) == null
                                  ? "Enter Amount Earned"
                                  : null,
                          onChanged: (value) {
                            setState(() {
                              if (double.tryParse(value) != null) {
                                amountEarned = double.parse(value);
                              }
                            });
                          },
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = false;
                                });
                                var employProv = context
                                    .read<EmployeeAccProvider>()
                                    .employeeAccVal!;
                                // debugPrint(
                                //     "Employ prov: ${employProv.pcProviderId} ${employProv.employeeDocId}");
                                // debugPrint("Otid: $outlierTaskId");
                                Task task = Task(
                                    pcProviderId: employProv.pcProviderId,
                                    employeeId: employProv.employeeDocId,
                                    // outlierTaskId:
                                    //     "outlierTaskId: $outlierTaskId",
                                    outlierTaskId: outlierTaskId,
                                    taskDocId: "",
                                    payAmount: amountEarned,
                                    createdDate: DateTime.now(),
                                    feedbackDate: DateTime.now(),
                                    // 99 means feedback was not given
                                    feedback: 99);
                                // debugPrint(
                                //     "$outlierTaskId ${task.outlierTaskId}");
                                TaskDatabaseService()
                                    .createTask(task)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      loading = true;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Task Created Successfully'),
                                      backgroundColor: Colors.green,
                                    ));
                                    Navigator.pop(context);
                                  } else {
                                    setState(() {
                                      loading = true;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Task Creation Failed'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                });
                              }
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(fontSize: deviceWidth * 0.05),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const LoadingAnimation(),
    );
  }
}
