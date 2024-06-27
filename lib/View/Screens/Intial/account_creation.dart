import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/employee_database_service.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/pc_provider_database_service.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/user_database_service.dart';
import 'package:ubuntu_system/Data/Model/employee_account.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';
import 'package:ubuntu_system/Data/Model/user_acc.dart';
import 'package:ubuntu_system/Provider/authentication_provider.dart';
import 'package:ubuntu_system/Shared/constant.dart';
import 'package:ubuntu_system/View/Screens/Administrator/administrator_dashboard.dart';
import 'package:ubuntu_system/View/Screens/Employee/employee_dashboard.dart';
import 'package:ubuntu_system/View/Screens/OnBoardingManager/onboarding_manager_dashboard.dart';
import 'package:ubuntu_system/View/Screens/PC%20Provider/pc_provider_dashboard.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';
import 'package:intl/intl.dart';

class AccountCreation extends StatefulWidget {
  const AccountCreation({super.key});

  @override
  State<AccountCreation> createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
  final _formKey = GlobalKey<FormState>();
  String genderVal = "Male";
  final List<String> gender = ["Male", "Female"];

  late String firstName, lastName, email = "", phoneNumber;
  late String city;

  DateTime birthDate = DateTime.now();

  bool emailExist = false;

  // PC Provider Vars
  late String state, streetAddress, emailPassword;
  late int zipCode;

  final List<String> _countrySuggestion = <String>['Ethiopia', 'USA', 'UK'];
  final TextEditingController _countrySuggestionController =
      TextEditingController();

  List<String> getCountry(String query) {
    List<String> matches = <String>[];
    matches.addAll(_countrySuggestion);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  // Employee Vars
  late String address, govtId;
  final List<String> _teamSuggestions = <String>[
    'Math',
    'Biology',
    'Programming'
  ];
  final TextEditingController _teamsuggestionController =
      TextEditingController();

  List<String> getTeamSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(_teamSuggestions);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  bool loading = false;
  bool accountSelected = false;
  // 0 equals pc provider and 1 equals employee
  int accountType = 0;

  @override
  void initState() {
    debugPrint("Profile Creation Entered");
    var authProv = context.read<AuthenticationProvider>().userVal;
    UserDatabaseService()
        .checkIfUserExist(authProv!.uid, authProv.email!)
        .then((value) {
      // debugPrint("Value: $value ${value.userType}");
      if (value.userType == "pcprovider") {
        setState(() {
          loading = true;
        });
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const PcProviderDashboard();
          },
        ));
      } else if (value.userType == "employee") {
        setState(() {
          loading = true;
        });
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const EmployeeDashBoard();
          },
        ));
      } else if (value.userType == "administrator") {
        UserDatabaseService()
            .updateUserAccUid(authProv.uid, authProv.email!)
            .then(
          (value) {
            setState(() {
              loading = true;
            });
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const AdministratorDashBoard();
              },
            ));
          },
        );
      } else if (value.userType == "onboardingmanager") {
        UserDatabaseService()
            .updateUserAccUid(authProv.uid, authProv.email!)
            .then(
          (value) {
            setState(() {
              loading = true;
            });
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const OnboardingManagerDashBoard();
              },
            ));
          },
        );
      } else {
        // debugPrint("Else Entered: ${value.userType}");
        setState(() {
          loading = true;
        });
        if (authProv.email!.isNotEmpty) {
          email = authProv.email!;
          emailExist = true;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    double deviceWidth = deviceSize.width;
    double deviceHeight = deviceSize.height;

    return Scaffold(
      body: loading
          ? accountSelected
              ? accountType == 0
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(deviceWidth * 0.1),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Enter PC Provider Information",
                                  style: TextStyle(
                                      fontSize: deviceWidth * 0.06,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.06,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    iconColor: Colors.white,
                                    labelText: 'First Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter Your First Name"
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      firstName = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    iconColor: Colors.white,
                                    labelText: 'Last Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter Your Last Name"
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      lastName = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  initialValue: email,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  readOnly: emailExist,
                                  validator: (value) => value!.isEmpty
                                      ? "Enter your Email"
                                      : null,
                                  onChanged: (value) {
                                    email = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Email Password'),
                                  obscureText: true,
                                  validator: (value) => value!.isEmpty
                                      ? "Enter your Email Password"
                                      : null,
                                  onChanged: (value) {
                                    emailPassword = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      hintText: "Phone Number"),
                                  validator: (value) => (value!.isEmpty ||
                                          double.tryParse(value) == null)
                                      ? "Enter your phone Number"
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      phoneNumber = value;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Government ID'),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter your Government ID"
                                      : null,
                                  onChanged: (value) {
                                    govtId = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                RawAutocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    return getCountry(textEditingValue.text);
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    _countrySuggestionController.text =
                                        textEditingController.text;
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      onFieldSubmitted: (String value) {
                                        onFieldSubmitted();
                                      },
                                      decoration: const InputDecoration(
                                        iconColor: Colors.white,
                                        labelText: 'Country: ',
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
                                            itemBuilder: (BuildContext context,
                                                int index) {
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
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'State'),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter your State"
                                      : null,
                                  onChanged: (value) {
                                    state = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'City'),
                                  validator: (value) =>
                                      value!.isEmpty ? "Enter your City" : null,
                                  onChanged: (value) {
                                    city = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Street Address'),
                                  validator: (value) =>
                                      value!.isEmpty ? "Enter your City" : null,
                                  onChanged: (value) {
                                    streetAddress = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    iconColor: Colors.white,
                                    labelText: 'Zip Code',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) => value!.isEmpty &&
                                          (value.isNotEmpty
                                                  ? int.tryParse(value)
                                                  : false) !=
                                              null
                                      ? "Enter Your ZipCode"
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      if (int.tryParse(value) != null) {
                                        zipCode = int.parse(value);
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Select Your BirthDate',
                                          style: TextStyle(
                                              fontSize: deviceWidth * 0.04),
                                        ),
                                        TextButton(
                                          child: Text(DateFormat.yMd()
                                              .format(birthDate)),
                                          onPressed: () async {
                                            final DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: birthDate,
                                              firstDate: DateTime(1910, 8),
                                              lastDate: DateTime(2101),
                                            );
                                            if (picked != null &&
                                                picked != birthDate) {
                                              setState(() {
                                                birthDate = picked;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Gender: ",
                                      style: TextStyle(
                                          fontSize: deviceWidth * 0.04),
                                    ),
                                    DropdownButton<String>(
                                      value: genderVal,
                                      onChanged: (value) {
                                        setState(() {
                                          genderVal = value!;
                                        });
                                      },
                                      items: gender
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
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: deviceHeight * 0.1),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          loading = false;
                                        });
                                        var authProv = context
                                            .read<AuthenticationProvider>()
                                            .userVal;
                                        PcProvider pcProvider = PcProvider(
                                            uid: authProv!.uid,
                                            pcProviderDocId: "",
                                            firstName: firstName,
                                            lastName: lastName,
                                            birthDate: birthDate,
                                            createdDate: DateTime.now(),
                                            govtId: govtId,
                                            country:
                                                _countrySuggestionController
                                                    .text,
                                            state: state,
                                            city: city,
                                            streetaddress: streetAddress,
                                            email: email,
                                            phoneNumber: phoneNumber,
                                            team: "",
                                            zipCode: zipCode,
                                            formstatus: 0,
                                            formHistory: {},
                                            accountStatus: 0,
                                            totalAmountEarned: 0,
                                            personalAmountEarned: 0);
                                        UserAcc userAcc =
                                            await UserDatabaseService()
                                                .checkIfUserExist(
                                                    authProv.uid, "");
                                        if (userAcc.docId != "false") {
                                          PcProviderDatabaseService()
                                              .createPcProviderAccount(
                                                  pcProvider)
                                              .then((value) {
                                            setState(() {
                                              loading = true;
                                            });
                                            if (value != false) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Profile Created Successfully'),
                                                backgroundColor: Colors.green,
                                              ));
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return const PcProviderDashboard();
                                                },
                                              ));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Profile Creation Failed'),
                                                backgroundColor: Colors.red,
                                              ));
                                            }
                                          });
                                        } else {
                                          UserDatabaseService()
                                              .createUserAcc(authProv.uid,
                                                  "pcprovider", email)
                                              .then((value) {
                                            if (value) {
                                              PcProviderDatabaseService()
                                                  .createPcProviderAccount(
                                                      pcProvider)
                                                  .then((value) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                if (value != false) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        'Profile Created Successfully'),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ));
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return const PcProviderDashboard();
                                                    },
                                                  ));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        'Profile Creation Failed'),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                }
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Profile Creation Failed'),
                                                backgroundColor: Colors.red,
                                              ));
                                            }
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontSize: deviceWidth * 0.045),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(deviceWidth * 0.1),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Enter Employee Information",
                                  style: TextStyle(
                                      fontSize: deviceWidth * 0.06,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.06,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    iconColor: Colors.white,
                                    labelText: 'First Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter Your First Name"
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      firstName = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    iconColor: Colors.white,
                                    labelText: 'Last Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter Your Last Name"
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      lastName = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Select Your BirthDate',
                                          style: TextStyle(
                                              fontSize: deviceWidth * 0.04),
                                        ),
                                        TextButton(
                                          child: Text(DateFormat.yMd()
                                              .format(birthDate)),
                                          onPressed: () async {
                                            final DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: birthDate,
                                              firstDate: DateTime(1910, 8),
                                              lastDate: DateTime(2101),
                                            );
                                            if (picked != null &&
                                                picked != birthDate) {
                                              setState(() {
                                                birthDate = picked;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      hintText: "Phone Number"),
                                  validator: (value) => (value!.isEmpty ||
                                          double.tryParse(value) == null)
                                      ? "Enter your phone Number"
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      phoneNumber = value;
                                    });
                                  },
                                  keyboardType: TextInputType.phone,
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'City'),
                                  validator: (value) =>
                                      value!.isEmpty ? "Enter your City" : null,
                                  onChanged: (value) {
                                    city = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Address'),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter your Address"
                                      : null,
                                  onChanged: (value) {
                                    address = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Government ID'),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter your Government ID"
                                      : null,
                                  onChanged: (value) {
                                    govtId = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  initialValue: email,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  readOnly: emailExist,
                                  validator: (value) => value!.isEmpty
                                      ? "Enter your Email"
                                      : null,
                                  onChanged: (value) {
                                    email = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                RawAutocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    return getTeamSuggestions(
                                        textEditingValue.text);
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    _teamsuggestionController.text =
                                        textEditingController.text;
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      onFieldSubmitted: (String value) {
                                        onFieldSubmitted();
                                      },
                                      decoration: const InputDecoration(
                                        iconColor: Colors.white,
                                        labelText: 'Choose Your Team',
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
                                            itemBuilder: (BuildContext context,
                                                int index) {
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
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: deviceHeight * 0.1),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        debugPrint("Employee Creation");
                                        setState(() {
                                          loading = false;
                                        });
                                        var authProv = context
                                            .read<AuthenticationProvider>()
                                            .userVal;
                                        EmployeeAccount employeeAccount =
                                            EmployeeAccount(
                                                uid: authProv!.uid,
                                                firstName: firstName,
                                                lastName: lastName,
                                                birthdate: birthDate,
                                                createdDate: DateTime.now(),
                                                city: city,
                                                address: address,
                                                email: email,
                                                govtId: govtId,
                                                amountReceived: 0,
                                                phoneNumber: phoneNumber,
                                                status: 0,
                                                manager: false,
                                                managerId: "",
                                                pcProviderId: "",
                                                team: _teamsuggestionController
                                                    .text);
                                        UserAcc userAcc =
                                            await UserDatabaseService()
                                                .checkIfUserExist(
                                                    authProv.uid, "");
                                        if (userAcc.docId != "false") {
                                          EmployeeDatabaseService()
                                              .createEmployeeAccount(
                                                  employeeAccount)
                                              .then((value) {
                                            setState(() {
                                              loading = true;
                                            });
                                            if (value != false) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Profile Created Successfully'),
                                                backgroundColor: Colors.green,
                                              ));
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return const EmployeeDashBoard();
                                                },
                                              ));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Profile Creation Failed'),
                                                backgroundColor: Colors.red,
                                              ));
                                            }
                                          });
                                        } else {
                                          UserDatabaseService()
                                              .createUserAcc(authProv.uid,
                                                  "employee", email)
                                              .then((value) {
                                            if (value) {
                                              EmployeeDatabaseService()
                                                  .createEmployeeAccount(
                                                      employeeAccount)
                                                  .then((value) {
                                                setState(() {
                                                  loading = true;
                                                });
                                                if (value != false) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        'Profile Created Successfully'),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ));
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return const EmployeeDashBoard();
                                                    },
                                                  ));
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                    content: Text(
                                                        'Profile Creation Failed'),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                }
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Profile Creation Failed'),
                                                backgroundColor: Colors.red,
                                              ));
                                            }
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontSize: deviceWidth * 0.045),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: deviceHeight * 0.4,
                          child: Card(
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.computer,
                                    size: deviceHeight * 0.2,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          accountSelected = true;
                                          accountType = 0;
                                        });
                                      },
                                      child: Text(
                                        "PC Provider",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: deviceWidth * 0.05),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.4,
                          child: Card(
                            color: Colors.grey[100],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.account_box,
                                    size: deviceHeight * 0.2,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          accountSelected = true;
                                          accountType = 1;
                                        });
                                      },
                                      child: Text(
                                        "Employee",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: deviceWidth * 0.05),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
          : const LoadingAnimation(),
    );
  }
}
