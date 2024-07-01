import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/administrator_database.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/employee_database_service.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/pc_provider_database_service.dart';
import 'package:ubuntu_system/Data/Model/administrator.dart';
import 'package:ubuntu_system/Data/Model/employee_account.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';
import 'package:ubuntu_system/Provider/authentication_provider.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

class AdministratorDashBoard extends StatefulWidget {
  const AdministratorDashBoard({super.key});

  @override
  State<AdministratorDashBoard> createState() => _AdministratorDashBoardState();
}

class _AdministratorDashBoardState extends State<AdministratorDashBoard> {
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

  bool loading = false;
  int _currentIndex = 0;

  List<String> accountStatusValues = [
    "EQ",
    "TeamV Disconnected",
    "Verify Email",
    "Active"
  ];

  List<String> formStatusValues = [
    "Ready to onBoard",
    "onBoarded",
    "Ready to Apply",
    "Applied",
    "Ready to Setup",
    "Ready to be Active"
  ];

  late Administrator _administrator;

  List<EmployeeAccount> employeeAccounts = [];
  List<PcProvider> pcProviders = [], forms = [];

  late StreamSubscription getEmployeesForAdSub, getPcProviderForAdmSub;

  List<String> employeeNames = [];

  List<String> getEmployee(String query) {
    List<String> matches = <String>[];
    matches.addAll(employeeNames);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  final TextEditingController _employeeSuggestionController =
      TextEditingController();

  List<String> managerDropDownVals = ["Manager Role", "Employee Role"];
  List<List<bool>> checkBoxValues = [];

  List<PcProvider> filteredForms = [];
  int filterIndex = 0;

  @override
  void initState() {
    super.initState();
    var authProv = context.read<AuthenticationProvider>().userVal!;
    AdministratorDatabaseService()
        .getAdministrator(authProv.email!)
        .then((value) {
      _administrator = value[0];
      getEmployeesForAdSub =
          EmployeeDatabaseService().getEmployeesForTL().listen((empEvent) {
        debugPrint("Emps: ${empEvent.length}");
        employeeAccounts.clear();
        employeeAccounts.addAll(empEvent);
        employeeNames.clear();
        checkBoxValues.clear();
        List<bool> tempCheckBoxVals = [];
        for (var employee in employeeAccounts) {
          employeeNames.add(employee.firstName + employee.email);
          tempCheckBoxVals.add(false);
        }
        for (var i = 0; i < employeeAccounts.length; i++) {
          checkBoxValues[i].addAll(tempCheckBoxVals);
        }
        getPcProviderForAdmSub =
            PcProviderDatabaseService().getPcProvidersForTL().listen((pcEvent) {
          pcProviders.clear();
          forms.clear();
          for (var pcProv in pcEvent) {
            pcProviders.add(pcProv);
            forms.add(pcProv);
            filteredForms.add(pcProv);
          }
          debugPrint("Forms leng: ${forms.length} : ${pcProviders.length}");
          // inludes only pc providers that are in the onboarding stages
          forms.removeWhere((element) => element.formstatus == 5);
          pcProviders.removeWhere((element) => element.formstatus < 5);
          debugPrint("Forms leng: ${forms.length} : ${pcProviders.length}");
          setState(() {
            loading = true;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    getEmployeesForAdSub.cancel();
    getPcProviderForAdmSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    debugPrint("Administration Dashboard");

    final tabs = [
      SizedBox(
        width: deviceWidth,
        height: deviceHeight * 0.79,
        child: Column(
          children: [
            const Text("Employees"),
            SizedBox(
              height: deviceWidth * 0.03,
            ),
            SizedBox(
              height: deviceHeight * 0.7,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: SizedBox(
                              height: deviceHeight * 0.055,
                              child: const Icon(Icons.person)),
                          title: Text(
                              "Name: ${employeeAccounts[index].firstName}  Income Earned: ${employeeAccounts[index].amountReceived}"),
                          subtitle: Text(
                              "Joined:${DateFormat.yMd(employeeAccounts[index].createdDate)}, TL:${employeeAccounts[index].managerId != "" ? employeeAccounts[index].managerName : "N/A"}, PC assigned: ${employeeAccounts[index].pcProviderId != "" ? employeeAccounts[index].pcProviderName : "N/A"}"),
                          onTap: null,
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Assign Role: ",
                              style: TextStyle(fontSize: deviceWidth * 0.04),
                            ),
                            DropdownButton<String>(
                              value: employeeAccounts[index].manager
                                  ? managerDropDownVals[0]
                                  : managerDropDownVals[1],
                              onChanged: (value) {
                                setState(() {
                                  index = managerDropDownVals.indexWhere(
                                      (element) => element == value);
                                  if (index == 0) {
                                    employeeAccounts[index].manager = true;
                                  } else {
                                    employeeAccounts[index].manager = false;
                                  }
                                });
                              },
                              items: managerDropDownVals
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
                        employeeAccounts[index].manager
                            ? Column(
                                children: [
                                  Text(
                                    "Select Employees For this Manager",
                                    style: TextStyle(
                                        fontSize: deviceWidth * 0.07,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.3,
                                    // color: Colors.amber,
                                    child: SingleChildScrollView(
                                      child: SizedBox(
                                        height: deviceHeight * 0.3,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ListView.builder(
                                                itemCount:
                                                    employeeAccounts.length,
                                                itemBuilder: (context, index2) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Card(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      elevation: 8,
                                                      child: CheckboxListTile(
                                                          controlAffinity:
                                                              ListTileControlAffinity
                                                                  .leading,
                                                          title: Text(
                                                            (employeeAccounts[index].firstName +
                                                                            employeeAccounts[index]
                                                                                .email)
                                                                        .length <
                                                                    20
                                                                ? (employeeAccounts[
                                                                            index]
                                                                        .firstName +
                                                                    employeeAccounts[
                                                                            index]
                                                                        .email)
                                                                : "${(employeeAccounts[index].firstName + employeeAccounts[index].email).substring(0, 20)}...",
                                                            style: TextStyle(
                                                                color: checkBoxValues[
                                                                            index]
                                                                        [index2]
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                          tileColor:
                                                              Colors.white,
                                                          selectedTileColor:
                                                              Colors.green,
                                                          checkColor:
                                                              Colors.white,
                                                          activeColor:
                                                              Colors.green,
                                                          selected:
                                                              checkBoxValues[
                                                                      index]
                                                                  [index2],
                                                          value: checkBoxValues[
                                                              index][index2],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              checkBoxValues[
                                                                          index]
                                                                      [index2] =
                                                                  value!;
                                                            });
                                                          }),
                                                    ),
                                                  );
                                                },
                                              )
                                            ]),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                loading = false;
                              });
                              if (employeeAccounts[index].manager) {
                                List<String> employeesAddedTothisManag = [];
                                for (var i = 0;
                                    i < checkBoxValues[index].length;
                                    i++) {
                                  if (checkBoxValues[index][i]) {
                                    employeesAddedTothisManag
                                        .add(employeeAccounts[i].employeeDocId);
                                  }
                                }
                                if (employeesAddedTothisManag.isNotEmpty) {
                                  EmployeeDatabaseService()
                                      .assignEmployeeManager(
                                          employeeAccounts[index].employeeDocId,
                                          employeeAccounts[index].firstName,
                                          employeeAccounts[index].manager,
                                          employeesAddedTothisManag)
                                      .then((value) {
                                    setState(() {
                                      loading = true;
                                    });
                                    if (value!) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Manager Assigned Successfully'),
                                        backgroundColor: Colors.green,
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Manager Failed to be Assigned'),
                                        backgroundColor: Colors.red,
                                      ));
                                    }
                                  });
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        'You did not assign employees for the manager'),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              } else {
                                EmployeeDatabaseService().assignEmployeeManager(
                                    employeeAccounts[index].employeeDocId,
                                    employeeAccounts[index].firstName,
                                    employeeAccounts[index].manager,
                                    []).then((value) {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (value!) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Employee Role Assigned Successfully'),
                                      backgroundColor: Colors.green,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Employee Role Failed to be Assigned'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                });
                              }
                            },
                            child: Text("Submit",
                                style: TextStyle(fontSize: deviceWidth * 0.04)))
                      ],
                    ),
                  );
                },
                itemCount: employeeAccounts.length,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: deviceWidth,
        height: deviceHeight * 0.79,
        child: Column(
          children: [
            const Text("PC Providers"),
            SizedBox(
              height: deviceWidth * 0.03,
            ),
            SizedBox(
              height: deviceHeight * 0.7,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: SizedBox(
                          height: deviceHeight * 0.055,
                          child: const Icon(Icons.computer)),
                      title: Text(
                          "Name: ${pcProviders[index].firstName}, Acc Status: ${accountStatusValues[pcProviders[index].accountStatus]}"),
                      subtitle: Column(
                        children: [
                          Text(
                              "Team: ${pcProviders[index].team} Joined: ${DateFormat.yMd(pcProviders[index].createdDate)}, Amount Earned: ${pcProviders[index].totalAmountEarned} Assigned To: ${pcProviders[index].employeeName != "" ? pcProviders[index].employeeName : "N/A"}"),
                          SizedBox(
                            height: deviceHeight * 0.03,
                          ),
                          RawAutocomplete<String>(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              return getEmployee(textEditingValue.text);
                            },
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController textEditingController,
                                FocusNode focusNode,
                                VoidCallback onFieldSubmitted) {
                              _employeeSuggestionController.text =
                                  textEditingController.text;
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onFieldSubmitted: (String value) {
                                  onFieldSubmitted();
                                },
                                decoration: const InputDecoration(
                                  iconColor: Colors.white,
                                  labelText: 'Assign To: ',
                                  border: OutlineInputBorder(),
                                ),
                              );
                            },
                            optionsViewBuilder: (BuildContext context,
                                AutocompleteOnSelected<String> onSelected,
                                Iterable<String> options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  child: SizedBox(
                                    height: 100,
                                    width: 300,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(8.0),
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final String option =
                                            options.elementAt(index);
                                        return GestureDetector(
                                          onTap: () {
                                            onSelected(option);
                                          },
                                          child: ListTile(
                                            title: Text(option),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: deviceHeight * 0.03,
                          ),
                          ElevatedButton(
                              onPressed: _employeeSuggestionController.text !=
                                      ""
                                  ? () {
                                      int employeeIndex =
                                          employeeNames.indexWhere((element) =>
                                              element ==
                                              _employeeSuggestionController
                                                  .text);
                                      if (employeeIndex != -1) {
                                        setState(() {
                                          loading = false;
                                        });
                                        PcProviderDatabaseService()
                                            .assignEmployee(
                                          pcProviders[index].pcProviderDocId,
                                          pcProviders[index].firstName +
                                              pcProviders[index].lastName,
                                          employeeAccounts[employeeIndex]
                                              .employeeDocId,
                                          employeeNames[employeeIndex],
                                        )
                                            .then((value) {
                                          setState(() {
                                            loading = true;
                                          });
                                          if (value!) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Employee Assigned Successfully'),
                                              backgroundColor: Colors.green,
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Failed To Assign Employee'),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        });
                                      } else {}
                                    }
                                  : null,
                              child: Text("Submit",
                                  style:
                                      TextStyle(fontSize: deviceWidth * 0.04)))
                        ],
                      ),
                      onTap: null,
                    ),
                  );
                },
                itemCount: pcProviders.length,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: deviceWidth,
        height: deviceHeight * 0.79,
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
                  value: formStatusValues[filterIndex],
                  onChanged: (value) {
                    setState(() {
                      filterIndex = formStatusValues
                          .indexWhere((element) => element == value);
                    });
                    filteredForms.clear();
                    for (var form in forms) {
                      if (form.formstatus == filterIndex) {
                        filteredForms.add(form);
                      }
                    }
                  },
                  items: formStatusValues
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
              height: deviceHeight * 0.7,
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
                              "Joined: ${filteredForms[index].createdDate}) email: ${filteredForms[index].email}, phoneNumber: ${filteredForms[index].phoneNumber}, birthDate: ${filteredForms[index].birthDate.toString()}, Govt ID: ${filteredForms[index].govtId}, Country: ${filteredForms[index].country}, State: ${filteredForms[index].state}, City: ${filteredForms[index].city}, Street Address: ${filteredForms[index].streetaddress}, Zip Code: ${filteredForms[index].zipCode.toString()}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Update Form Status: ",
                                style: TextStyle(fontSize: deviceWidth * 0.04),
                              ),
                              DropdownButton<String>(
                                value: formStatusValues[
                                    filteredForms[index].formstatus],
                                onChanged: (value) {
                                  setState(() {
                                    filteredForms[index].formstatus =
                                        formStatusValues.indexWhere(
                                            (element) => element == value);
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
                                        filteredForms[index].pcProviderDocId,
                                        filteredForms[index].formstatus,
                                        _administrator.adminDocId)
                                    .then((value) {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (value) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Form Updated Successfully'),
                                      backgroundColor: Colors.green,
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Form Failed To Update'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }
                                });
                              },
                              child: Text("Submit",
                                  style:
                                      TextStyle(fontSize: deviceWidth * 0.04)))
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
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Administrator",
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
      drawer: loading
          ? Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                        '${_administrator.firstName} ${_administrator.lastName}'),
                    accountEmail: Text(_administrator.email),
                    // currentAccountPicture: const CircleAvatar(
                    //   backgroundImage: AssetImage('assets/profile_picture.jpg'),
                    // ),
                    onDetailsPressed: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add Onboarding Manager'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const Placeholder();
                        },
                      ));
                    },
                  ),
                ],
              ),
            )
          : const LoadingAnimation2(),
      body: loading
          ? Padding(
              padding: EdgeInsets.all(deviceWidth * 0.04),
              child: tabs[_currentIndex],
            )
          : const LoadingAnimation2(),
      bottomNavigationBar: loading
          ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.work), label: "Employee"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.computer), label: "PC"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.edit_document), label: "Forms")
              ],
              elevation: deviceWidth * 0.1,
              backgroundColor: Colors.white,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            )
          : null,
    );
  }
}
