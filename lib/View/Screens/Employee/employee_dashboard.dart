import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/employee_database_service.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/pc_provider_database_service.dart';
import 'package:ubuntu_system/Data/Model/employee_account.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';
import 'package:ubuntu_system/Provider/authentication_provider.dart';
import 'package:ubuntu_system/Provider/employee_acc_provider.dart';
import 'package:ubuntu_system/View/Screens/Employee/add_task.dart';
import 'package:ubuntu_system/View/Screens/Employee/employee_tasks.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';

class EmployeeDashBoard extends StatefulWidget {
  const EmployeeDashBoard({super.key});

  @override
  State<EmployeeDashBoard> createState() => _EmployeeDashBoardState();
}

class _EmployeeDashBoardState extends State<EmployeeDashBoard> {
  bool loading = false;
  bool runOnce = false;

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

  List<String> accountStatusValues = [
    "EQ",
    "TeamV Disconnected",
    "Verify Email",
    "Active"
  ];

  late EmployeeAccount _employeeAccount;
  int employeeAssignedPCAccountStatus = -1;

  late StreamSubscription getEmployeeSub;
  StreamSubscription? getPcStatusSub,
      getEmployeesForTlSub,
      getPcProvidersForTlSub;

  int _currentIndex = 0;

  List<EmployeeAccount> employeeAccounts = [];
  List<PcProvider> pcProviders = [];

  DateFormat dateFormat = DateFormat("yMd");

  @override
  void initState() {
    super.initState();
    var authProv = context.read<AuthenticationProvider>().userVal;
    var employProv = context.read<EmployeeAccProvider>();
    getEmployeeSub =
        EmployeeDatabaseService().getEmployee(authProv!.uid).listen((event) {
      _employeeAccount = event[0];
      employProv.assignEmployeeAcc(_employeeAccount);

      if (_employeeAccount.manager) {
        getEmployeesForTlSub = EmployeeDatabaseService()
            .getEmployeesForTL(_employeeAccount.employeeDocId)
            .listen((event) {
          debugPrint("Emps: ${event.length}");
          employeeAccounts.clear();
          employeeAccounts.addAll(event);
          getPcProvidersForTlSub =
              PcProviderDatabaseService().getPcProvidersForTL().listen((event) {
            pcProviders.clear();
            pcProviders.addAll(event);
            pcProviders.removeWhere(
              (element) {
                bool doesntExist = true;
                for (var employee in employeeAccounts) {
                  if (employee.employeeDocId == element.employeeId) {
                    doesntExist = false;
                    break;
                  }
                }
                debugPrint("Doesnt Exist: $doesntExist");
                return doesntExist;
              },
            );
            setState(() {
              loading = true;
            });
          });
        });
      } else {
        if (!runOnce && _employeeAccount.pcProviderId != "") {
          getPcStatusSub = PcProviderDatabaseService()
              .getPcProviderStatus(_employeeAccount.pcProviderId)
              .listen((event) {
            setState(() {
              employeeAssignedPCAccountStatus = event;
            });
            debugPrint("AccSt: $employeeAssignedPCAccountStatus");
            setState(() {
              loading = true;
            });
          });
          runOnce = true;
        } else {
          setState(() {
            loading = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (getPcStatusSub != null) {
      getPcStatusSub!.cancel();
    }
    if (getEmployeesForTlSub != null) {
      getEmployeesForTlSub!.cancel();
    }
    if (getPcProvidersForTlSub != null) {
      getPcProvidersForTlSub!.cancel();
    }
    getEmployeeSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    debugPrint("Employee Dashboard");

    final tabs = loading && _employeeAccount.manager
        ? [
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
                          child: ListTile(
                            leading: SizedBox(
                                height: deviceHeight * 0.055,
                                child: const Icon(Icons.person)),
                            title: Text(
                                "Name: ${employeeAccounts[index].firstName}  Income Earned: ${employeeAccounts[index].amountReceived}"),
                            subtitle: Text(
                                "Joined:${dateFormat.format(employeeAccounts[index].createdDate)}, TL:${employeeAccounts[index].managerId != "" ? employeeAccounts[index].managerName : "N/A"}, PC assigned: ${employeeAccounts[index].pcProviderId != "" ? employeeAccounts[index].pcProviderName : "N/A"}"),
                            onTap: null,
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
                            subtitle: Text(
                                "Joined: ${dateFormat.format(pcProviders[index].createdDate)}, Amount Earned: ${pcProviders[index].totalAmountEarned}, Assigned To: ${pcProviders[index].employeeName != "" ? pcProviders[index].employeeName : "N/A"}"),
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
          ]
        : [];

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Employee",
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
                          '${_employeeAccount.firstName} ${_employeeAccount.lastName}'),
                      accountEmail: Text(_employeeAccount.email),
                      // currentAccountPicture: const CircleAvatar(
                      //   backgroundImage: AssetImage('assets/profile_picture.jpg'),
                      // ),
                      onDetailsPressed: () {},
                    ),
                    ListTile(
                      title: const Text('Tasks'),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const EmployeeTasks();
                          },
                        ));
                      },
                    ),
                  ],
                ),
              )
            : const LoadingAnimation2(),
        body: loading
            ? _employeeAccount.manager
                ? Padding(
                    padding: EdgeInsets.all(deviceWidth * 0.04),
                    child: tabs[_currentIndex],
                  )
                : Padding(
                    padding: EdgeInsets.all(deviceWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Income Earned: ',
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.06,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(
                              width: deviceWidth * 0.01,
                            ),
                            Text(
                                '${_employeeAccount.amountReceived.toStringAsFixed(2)} \$',
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.07,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('PC: ',
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.045,
                                    fontWeight: FontWeight.w300)),
                            SizedBox(
                              width: deviceWidth * 0.01,
                            ),
                            Text(
                                _employeeAccount.pcProviderId != ""
                                    ? _employeeAccount.pcProviderName
                                    : "not assigned",
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.045,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Status: ',
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.045,
                                    fontWeight: FontWeight.w300)),
                            SizedBox(
                              width: deviceWidth * 0.01,
                            ),
                            _employeeAccount.pcProviderId != ""
                                ? DropdownButton<String>(
                                    value: accountStatusValues[
                                        employeeAssignedPCAccountStatus],
                                    onChanged: (value) {
                                      setState(() {
                                        loading = false;
                                      });
                                      int newIndex =
                                          accountStatusValues.indexWhere(
                                              (element) => element == value);
                                      PcProviderDatabaseService()
                                          .updatePcAccountStatus(
                                              _employeeAccount.pcProviderId,
                                              newIndex)
                                          .then((value) {
                                        // setState(() {
                                        //   loading = true;
                                        // });
                                        if (value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Account Status Updated Successfully'),
                                            backgroundColor: Colors.green,
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Account Status Failed To Update'),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      });
                                    },
                                    items: accountStatusValues
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )
                                : Text(
                                    employeeAssignedPCAccountStatus >= 0
                                        ? accountStatusValues[
                                            employeeAssignedPCAccountStatus]
                                        : "N/A",
                                    style: TextStyle(
                                        fontSize: deviceWidth * 0.045,
                                        fontWeight: FontWeight.w400)),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Team: ',
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.045,
                                    fontWeight: FontWeight.w300)),
                            SizedBox(
                              width: deviceWidth * 0.03,
                            ),
                            Text(_employeeAccount.team,
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.045,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Manager: ',
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.045,
                                    fontWeight: FontWeight.w300)),
                            SizedBox(
                              width: deviceWidth * 0.01,
                            ),
                            Text(
                                _employeeAccount.managerId != ""
                                    ? _employeeAccount.managerName
                                    : 'not assigned',
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.045,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight * 0.03,
                        ),
                        ElevatedButton(
                          onPressed: _employeeAccount.pcProviderId != ""
                              ? () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: const AddTask(),
                                      );
                                    },
                                  );
                                }
                              : null,
                          child: Text('Add a Task',
                              style: TextStyle(fontSize: deviceWidth * 0.04)),
                        ),
                      ],
                    ),
                  )
            : const LoadingAnimation2(),
        bottomNavigationBar: loading
            ? _employeeAccount.manager
                ? BottomNavigationBar(
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.work), label: "Employee"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.computer), label: "PC"),
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
                : null
            : null,
      ),
    );
  }
}
