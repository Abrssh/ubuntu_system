import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/task_database_service.dart';
import 'package:ubuntu_system/Provider/pc_provider_provider_class.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

class PCProvAssignFeedbackPage extends StatefulWidget {
  const PCProvAssignFeedbackPage({super.key});

  @override
  State<PCProvAssignFeedbackPage> createState() =>
      _PCProvAssignFeedbackPageState();
}

class _PCProvAssignFeedbackPageState extends State<PCProvAssignFeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String outlierTaskId = "";
  int feedback = 0;

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    double deviceWidth = deviceSize.width;
    double deviceHeight = deviceSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Feedback"),
        centerTitle: true,
      ),
      body: loading
          ? Padding(
              padding: EdgeInsets.all(deviceWidth * 0.04),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                            labelText: 'Feedback',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value!.isEmpty || int.tryParse(value) == null
                                  ? "Give a Feedback"
                                  : int.parse(value) > 5 || int.parse(value) < 0
                                      ? "Not a valid Feedback"
                                      : null,
                          onChanged: (value) {
                            setState(() {
                              if (int.tryParse(value) != null) {
                                feedback = int.parse(value);
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
                                var pcProvCla = context
                                    .read<PCProviderClass>()
                                    .pcProviderVal!;
                                TaskDatabaseService()
                                    .assignFeedbackToTask(outlierTaskId,
                                        pcProvCla.pcProviderDocId, feedback)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      loading = true;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Feedback given Successfully'),
                                      backgroundColor: Colors.green,
                                    ));
                                  } else {
                                    setState(() {
                                      loading = true;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Assigning Feedbaack has Failed'),
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
                    )),
              ),
            )
          : const LoadingAnimation(),
    );
  }
}
