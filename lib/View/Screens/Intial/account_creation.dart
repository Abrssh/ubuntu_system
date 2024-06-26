import 'package:flutter/material.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';
import 'package:intl/intl.dart';

class AccountCreation extends StatefulWidget {
  const AccountCreation({super.key});

  @override
  State<AccountCreation> createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
  final _formKey = GlobalKey<FormState>();
  String genderVal = "PC Provider";
  final List<String> gender = ["Male", "Female"];
  late int age;

  late String firstName, lastName, email;
  late String city;

  // PC Provider Vars
  late String country, state, streetAddress, emailPassword;
  late int zipCode;

  DateTime birthDate = DateTime.now();
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
  late String team, address, govId;
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
    // ProfileDatabaseService()
    //     .checkIfProfileExist(
    //         context.read<AuthenticationProvider>().userVal!.uid)
    //     .then((value) {
    //   // means profile exist
    //   if (value != "false") {
    //     ProfileDatabaseService().getProfile(value).then((value) {
    //       setState(() {
    //         loading = true;
    //       });
    //       context.read<ProfileProvider>().assignProfile(value);
    //       // context.push("/${RouteConstant.ownerDashboardPath}");
    //       Navigator.push(context, MaterialPageRoute(
    //         builder: (context) {
    //           return const OwnerDashboard();
    //         },
    //       ));
    //       debugPrint("OwnerDashboard Pushed $value");
    //     });
    //   } else {
    //     setState(() {
    //       loading = true;
    //     });
    //   }
    // });
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    double deviceWidth = deviceSize.width;
    double deviceHeight = deviceSize.height;

    loading = true;

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
                                  readOnly: true,
                                  validator: (value) => value!.isEmpty
                                      ? "Enter your Email"
                                      : null,
                                  onChanged: (value) {
                                    city = value;
                                  },
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Email Password'),
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
                                  decoration: const InputDecoration(
                                      labelText: 'Country'),
                                  validator: (value) => value!.isEmpty
                                      ? "Enter your Country"
                                      : null,
                                  onChanged: (value) {
                                    country = value;
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
                                    city = value;
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
                                TextFormField(
                                  decoration: const InputDecoration(
                                    iconColor: Colors.white,
                                    labelText: 'Age',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) => value!.isEmpty &&
                                          (value.isNotEmpty
                                                  ? int.tryParse(value)
                                                  : false) !=
                                              null
                                      ? "Enter Your Age"
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      if (int.tryParse(value) != null) {
                                        age = int.parse(value);
                                      }
                                    });
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const Text('Select Your BirthDate'),
                                        TextButton(
                                          child: Text(DateFormat.yMd()
                                              .format(birthDate)),
                                          onPressed: () async {
                                            final DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: birthDate,
                                              firstDate: DateTime(1995, 8),
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
                                          fontSize: deviceWidth * 0.05),
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
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // int ageRangeSelected = 0;
                                        // switch (ageRangeVal) {
                                        //   case "18-25":
                                        //     ageRangeSelected = 0;
                                        //   case "26-34":
                                        //     ageRangeSelected = 1;
                                        //   case "35-60":
                                        //     ageRangeSelected = 2;
                                        //     break;
                                        //   default:
                                        // }
                                        // setState(() {
                                        //   loading = false;
                                        // });
                                        // Profile profile = Profile(
                                        //     address: homeAddress,
                                        //     ageRange: ageRangeSelected,
                                        //     lastName: lastName,
                                        //     userName: username,
                                        //     firstName: firstName,
                                        //     profileId: "",
                                        //     uid: context
                                        //         .read<AuthenticationProvider>()
                                        //         .userVal!
                                        //         .uid,
                                        //     city: city);
                                        // ProfileDatabaseService()
                                        //     .createProfile(profile)
                                        //     .then((value) {
                                        //   setState(() {
                                        //     loading = true;
                                        //   });
                                        //   if (value != "false") {
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(const SnackBar(
                                        //       content:
                                        //           Text('Profile Created Successfully'),
                                        //       backgroundColor: Colors.green,
                                        //     ));
                                        //     // context.push(
                                        //     //     "/${RouteConstant.ownerDashboardPath}");
                                        //     context
                                        //         .read<ProfileProvider>()
                                        //         .assignProfileId(value);
                                        //     Navigator.push(context, MaterialPageRoute(
                                        //       builder: (context) {
                                        //         return const OwnerDashboard();
                                        //       },
                                        //     ));
                                        //   } else {
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(const SnackBar(
                                        //       content: Text('Profile Creation Failed'),
                                        //       backgroundColor: Colors.red,
                                        //     ));
                                        //   }
                                        // });
                                      }
                                    },
                                    child: const Text('Submit'),
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
                                TextFormField(
                                  decoration: const InputDecoration(
                                    iconColor: Colors.white,
                                    labelText: 'Age',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) => value!.isEmpty &&
                                          (value.isNotEmpty
                                                  ? int.tryParse(value)
                                                  : false) !=
                                              null
                                      ? "Enter Your Age"
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      if (int.tryParse(value) != null) {
                                        age = int.parse(value);
                                      }
                                    });
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
                                    govId = value;
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
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (accountSelected == 0) {
                                        } else {}
                                        // int ageRangeSelected = 0;
                                        // switch (ageRangeVal) {
                                        //   case "18-25":
                                        //     ageRangeSelected = 0;
                                        //   case "26-34":
                                        //     ageRangeSelected = 1;
                                        //   case "35-60":
                                        //     ageRangeSelected = 2;
                                        //     break;
                                        //   default:
                                        // }
                                        // setState(() {
                                        //   loading = false;
                                        // });
                                        // Profile profile = Profile(
                                        //     address: homeAddress,
                                        //     ageRange: ageRangeSelected,
                                        //     lastName: lastName,
                                        //     userName: username,
                                        //     firstName: firstName,
                                        //     profileId: "",
                                        //     uid: context
                                        //         .read<AuthenticationProvider>()
                                        //         .userVal!
                                        //         .uid,
                                        //     city: city);
                                        // ProfileDatabaseService()
                                        //     .createProfile(profile)
                                        //     .then((value) {
                                        //   setState(() {
                                        //     loading = true;
                                        //   });
                                        //   if (value != "false") {
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(const SnackBar(
                                        //       content:
                                        //           Text('Profile Created Successfully'),
                                        //       backgroundColor: Colors.green,
                                        //     ));
                                        //     // context.push(
                                        //     //     "/${RouteConstant.ownerDashboardPath}");
                                        //     context
                                        //         .read<ProfileProvider>()
                                        //         .assignProfileId(value);
                                        //     Navigator.push(context, MaterialPageRoute(
                                        //       builder: (context) {
                                        //         return const OwnerDashboard();
                                        //       },
                                        //     ));
                                        //   } else {
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(const SnackBar(
                                        //       content: Text('Profile Creation Failed'),
                                        //       backgroundColor: Colors.red,
                                        //     ));
                                        //   }
                                        // });
                                      }
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Card(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                accountSelected = true;
                              });
                            },
                            icon: const Icon(Icons.computer),
                            label: const Text("PC Provider")),
                      ),
                      Card(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                accountSelected = true;
                              });
                            },
                            icon: const Icon(Icons.account_box),
                            label: const Text("Employee")),
                      ),
                    ],
                  ),
                )
          : const LoadingAnimation(),
    );
  }
}
