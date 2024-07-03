import 'package:flutter/material.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/onboard_manager_database_service.dart';
import 'package:ubuntu_system/Data/Model/on_boarding_manager.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

class AddOnboardingManager extends StatefulWidget {
  const AddOnboardingManager({super.key});

  @override
  State<AddOnboardingManager> createState() => _AddOnboardingManagerState();
}

class _AddOnboardingManagerState extends State<AddOnboardingManager> {
  final _formKey = GlobalKey<FormState>();
  late String firstName, lastName, govtId, phoneNumber, city, address, email;

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    double deviceWidth = deviceSize.width;
    double deviceHeight = deviceSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add OnBoarding Manager"),
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
                              labelText: 'Email',
                              border: const OutlineInputBorder(),
                              labelStyle:
                                  TextStyle(fontSize: deviceWidth * 0.04)),
                          validator: (value) =>
                              value!.isEmpty ? "Enter Email" : null,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: deviceWidth * 0.01),
                          decoration: InputDecoration(
                              iconColor: Colors.white,
                              labelText: 'First Name',
                              border: const OutlineInputBorder(),
                              labelStyle:
                                  TextStyle(fontSize: deviceWidth * 0.04)),
                          validator: (value) =>
                              value!.isEmpty ? "Enter First Name" : null,
                          onChanged: (value) {
                            setState(() {
                              firstName = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: deviceWidth * 0.01),
                          decoration: InputDecoration(
                              iconColor: Colors.white,
                              labelText: 'Last Name',
                              border: const OutlineInputBorder(),
                              labelStyle:
                                  TextStyle(fontSize: deviceWidth * 0.04)),
                          validator: (value) =>
                              value!.isEmpty ? "Enter Last Name" : null,
                          onChanged: (value) {
                            setState(() {
                              lastName = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: deviceWidth * 0.01),
                          decoration: InputDecoration(
                              iconColor: Colors.white,
                              labelText: 'Govt Id',
                              border: const OutlineInputBorder(),
                              labelStyle:
                                  TextStyle(fontSize: deviceWidth * 0.04)),
                          validator: (value) =>
                              value!.isEmpty ? "Enter Govt Id" : null,
                          onChanged: (value) {
                            setState(() {
                              govtId = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: deviceWidth * 0.01),
                          decoration: InputDecoration(
                              iconColor: Colors.white,
                              labelText: 'PhoneNumber',
                              border: const OutlineInputBorder(),
                              labelStyle:
                                  TextStyle(fontSize: deviceWidth * 0.04)),
                          validator: (value) =>
                              value!.isEmpty ? "Enter Phone Number" : null,
                          onChanged: (value) {
                            setState(() {
                              phoneNumber = value;
                            });
                          },
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: deviceWidth * 0.01),
                          decoration: InputDecoration(
                              iconColor: Colors.white,
                              labelText: 'City',
                              border: const OutlineInputBorder(),
                              labelStyle:
                                  TextStyle(fontSize: deviceWidth * 0.04)),
                          validator: (value) =>
                              value!.isEmpty ? "Enter City" : null,
                          onChanged: (value) {
                            setState(() {
                              city = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: deviceWidth * 0.01),
                          decoration: InputDecoration(
                              iconColor: Colors.white,
                              labelText: 'Address',
                              border: const OutlineInputBorder(),
                              labelStyle:
                                  TextStyle(fontSize: deviceWidth * 0.04)),
                          validator: (value) =>
                              value!.isEmpty ? "Enter Address" : null,
                          onChanged: (value) {
                            setState(() {
                              address = value;
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
                                OnBoardingManager onBoardingManager =
                                    OnBoardingManager(
                                        email: email,
                                        firstName: firstName,
                                        lastName: lastName,
                                        phoneNumber: phoneNumber,
                                        address: address,
                                        city: city,
                                        govtId: govtId,
                                        uid: "",
                                        onBoardManDocID: "");
                                OnboardingManagerDatabaseService()
                                    .createOnboardingManager(onBoardingManager)
                                    .then((value) {
                                  if (value!) {
                                    setState(() {
                                      loading = true;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Onboarding Manager Was Created Successfully'),
                                      backgroundColor: Colors.green,
                                    ));
                                  } else {
                                    setState(() {
                                      loading = true;
                                    });
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Onboarding Manager Could not be Created'),
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
