import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/onboard_manager_database_service.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/pc_provider_database_service.dart';
import 'package:ubuntu_system/Data/Model/on_boarding_manager.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';
import 'package:ubuntu_system/Provider/authentication_provider.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

class OnboardingManagerDashBoard extends StatefulWidget {
  const OnboardingManagerDashBoard({super.key});

  @override
  State<OnboardingManagerDashBoard> createState() =>
      _OnboardingManagerDashBoardState();
}

class _OnboardingManagerDashBoardState
    extends State<OnboardingManagerDashBoard> {
  void _logoutAction(BuildContext context, double deviceWidth) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: Text(
            "Are you sure you want to Logout?",
            style: TextStyle(fontSize: deviceWidth * 0.04),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pop(context);
                });
                Navigator.pop(context);
              },
              child: Text(
                "Yes",
                style: TextStyle(fontSize: deviceWidth * 0.055),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(fontSize: deviceWidth * 0.055),
              ),
            ),
          ],
        );
      },
    );
  }

  late OnBoardingManager _onBoardingManager;

  bool loading = false;

  List<String> formStatusValues = [
    "Ready to onBoard",
    "onBoarded",
    "Ready to Apply",
    "Applied",
    "Ready to Setup",
    "Ready to be Active"
  ];

  List<String> filterFormStatusValues = [
    "All",
    "Ready to onBoard",
    "onBoarded",
    "Ready to Apply",
    "Applied",
    "Ready to Setup",
    "Ready to be Active"
  ];

  List<PcProvider> forms = [], filteredForms = [];
  int filterIndex = 0;

  late StreamSubscription getFormsSub;

  DateFormat dateFormat = DateFormat("yMd");

  @override
  void initState() {
    super.initState();
    var authProv = context.read<AuthenticationProvider>().userVal!;
    OnboardingManagerDatabaseService()
        .getOnboardingManager(authProv.uid, authProv.email!)
        .then((value) {
      _onBoardingManager = value[0];
      getFormsSub = PcProviderDatabaseService()
          .getFormsForOnboardManager()
          .listen((event) {
        forms.clear();
        event.sort(
          (a, b) => a.createdDate.millisecondsSinceEpoch
              .compareTo(b.createdDate.millisecondsSinceEpoch),
        );
        forms.addAll(event);
        int tempFilterIndex = filterIndex;
        filteredForms.clear();
        bool allSelected = true;
        if (tempFilterIndex > 0) {
          allSelected = false;
          tempFilterIndex -= 1;
        }
        for (var form in forms) {
          if (form.formstatus == tempFilterIndex ||
              (tempFilterIndex == 0 && allSelected)) {
            filteredForms.add(form);
          }
        }
        debugPrint("FilForms: ${filteredForms.length}");
        setState(() {
          loading = true;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    getFormsSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    debugPrint("OnboardingManager Dashboard");
    BuildContext mainBuildContext = context;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Onboarding Manager",
            style: TextStyle(fontSize: deviceWidth * 0.06),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                _logoutAction(context, deviceWidth);
              },
            ),
          ],
        ),
        body: loading
            ? SizedBox(
                width: deviceWidth,
                height: deviceHeight * 0.89,
                child: Column(
                  children: [
                    const Text("Forms"),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Filter Based On: ",
                          style: TextStyle(fontSize: deviceWidth * 0.04),
                        ),
                        DropdownButton<String>(
                          value: filterFormStatusValues[filterIndex],
                          onChanged: (value) {
                            setState(() {
                              filterIndex = filterFormStatusValues
                                  .indexWhere((element) => element == value);
                            });
                            int tempFilterIndex = filterIndex;
                            filteredForms.clear();
                            bool allSelected = true;
                            if (tempFilterIndex > 0) {
                              allSelected = false;
                              tempFilterIndex -= 1;
                            }
                            for (var form in forms) {
                              if (form.formstatus == tempFilterIndex ||
                                  (tempFilterIndex == 0 && allSelected)) {
                                filteredForms.add(form);
                              }
                            }
                          },
                          items: filterFormStatusValues
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.608,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: SizedBox(
                                  height: deviceHeight * 0.055,
                                  child: const Icon(Icons.computer)),
                              title: Text(
                                  "Name: ${filteredForms[index].firstName} ${filteredForms[index].lastName}, Form Status: ${formStatusValues[filteredForms[index].formstatus]}"),
                              subtitle: Column(
                                children: [
                                  Text(
                                      "Joined: ${dateFormat.format(filteredForms[index].createdDate)}) email: ${filteredForms[index].email}, phoneNumber: ${filteredForms[index].phoneNumber}, birthDate: ${dateFormat.format(filteredForms[index].birthDate)}, Govt ID: ${filteredForms[index].govtId}, Country: ${filteredForms[index].country}, State: ${filteredForms[index].state}, City: ${filteredForms[index].city}, Street Address: ${filteredForms[index].streetaddress}, Zip Code: ${filteredForms[index].zipCode.toString()}"),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Update Form Status: ",
                                        style: TextStyle(
                                            fontSize: deviceWidth * 0.04),
                                      ),
                                      DropdownButton<String>(
                                        value: formStatusValues[
                                            filteredForms[index].formstatus],
                                        onChanged: (value) {
                                          setState(() {
                                            filteredForms[index].formstatus =
                                                formStatusValues.indexWhere(
                                                    (element) =>
                                                        element == value);
                                          });
                                        },
                                        items: formStatusValues
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.02,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          loading = false;
                                        });
                                        PcProviderDatabaseService()
                                            .updateFormStatus(
                                                filteredForms[index]
                                                    .pcProviderDocId,
                                                filteredForms[index].formstatus,
                                                _onBoardingManager
                                                    .onBoardManDocID)
                                            .then((value) {
                                          // setState(() {
                                          //   loading = true;
                                          // });
                                          if (value) {
                                            ScaffoldMessenger.of(
                                                    mainBuildContext)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Form Updated Successfully'),
                                              backgroundColor: Colors.green,
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(
                                                    mainBuildContext)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Form Failed To Update'),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        });
                                      },
                                      child: Text("Submit",
                                          style: TextStyle(
                                              fontSize: deviceWidth * 0.04)))
                                ],
                              ),
                              onTap: null,
                            ),
                          );
                        },
                        itemCount: filteredForms.length,
                      ),
                    ),
                  ],
                ),
              )
            : const LoadingAnimation2(),
      ),
    );
  }
}
