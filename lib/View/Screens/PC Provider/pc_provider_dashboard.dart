// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/pc_provider_database_service.dart';
// import 'package:ubuntu_system/Data/Model/pc_provider.dart';
// import 'package:ubuntu_system/Provider/authentication_provider.dart';
// import 'package:ubuntu_system/Provider/pc_provider_provider_class.dart';
// import 'package:ubuntu_system/View/Screens/PC%20Provider/Class/notification_item.dart';
// import 'package:ubuntu_system/View/Screens/PC%20Provider/pc_prov_assign_feedback_page.dart';
// import 'package:ubuntu_system/View/Screens/PC%20Provider/pc_provider_tasks.dart';
// import 'package:ubuntu_system/View/Widgets/loading_animation.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// class PcProviderDashboard extends StatefulWidget {
//   const PcProviderDashboard({super.key});

//   @override
//   State<PcProviderDashboard> createState() => _PcProviderDashboardState();
// }

// class _PcProviderDashboardState extends State<PcProviderDashboard> {
//   final List<NotificationItem> notifications = [
//     NotificationItem(
//       shortMessage: 'New message received',
//       fullDetails: 'You have a new message from John Doe.',
//     ),
//     NotificationItem(
//       shortMessage: 'New message received',
//       fullDetails: 'You have a new message from John Doe.',
//     ),
//     // Add more notifications here
//   ];

//   bool showNotifiation = false;
//   List<String> formStatusValues = [
//     "Ready to onBoard",
//     "onBoarded",
//     "Ready to Apply",
//     "Applied",
//     "Ready to Setup",
//     "Ready to be Active"
//   ];
//   List<String> accountStatusValues = [
//     "EQ",
//     "TeamV Disconnected",
//     "Verify Email",
//     "Active"
//   ];

//   String whatsAppGroupLink =
//       "https://kotlinlang.org/docs/releases.html#release-details";

//   Widget _buildNotifications(double deviceWidth) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: Colors.grey[200],
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Notifications',
//             style: TextStyle(
//                 fontSize: deviceWidth * 0.03, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: notifications.length,
//             itemBuilder: (context, index) {
//               final notification = notifications[index];
//               return ListTile(
//                 title: Text(notification.shortMessage),
//                 subtitle: Text(notification.fullDetails),
//                 onTap: () {
//                   // Handle notification tap (e.g., show detailed view)
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAccountDetailsDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Account Details'),
//           content: Text('Placeholder content for account details.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // Close the dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _logoutAction(BuildContext context, double deviceWidth) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Logout"),
//           content: Text(
//             "Are you sure you want to Logout?",
//             style: TextStyle(fontSize: deviceWidth * 0.04),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 FirebaseAuth.instance.signOut().then((value) {
//                   Navigator.pop(context);
//                 });
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 "Yes",
//                 style: TextStyle(fontSize: deviceWidth * 0.055),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 "No",
//                 style: TextStyle(fontSize: deviceWidth * 0.055),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   late PcProvider _pcProvider;
//   bool loading = false;

//   late StreamSubscription getPcProviderSub;

//   @override
//   void initState() {
//     super.initState();
//     var authProv = context.read<AuthenticationProvider>().userVal;
//     var pcProv = context.read<PCProviderClass>();
//     getPcProviderSub = PcProviderDatabaseService()
//         .getPcProvider(authProv!.uid)
//         .listen((event) {
//       _pcProvider = event[0];
//       pcProv.assignPcProvider(_pcProvider);
//       setState(() {
//         loading = true;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     getPcProviderSub.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double deviceHeight = MediaQuery.of(context).size.height;
//     final double deviceWidth = MediaQuery.of(context).size.width;

//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Ubuntu',
//             style: TextStyle(
//                 fontSize: deviceWidth * 0.06), // Set app bar text size
//           ),
//           centerTitle: true,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.notifications),
//               onPressed: () {
//                 setState(() {
//                   showNotifiation = !showNotifiation;
//                 });
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.exit_to_app),
//               onPressed: () {
//                 _logoutAction(context, deviceWidth);
//               },
//             ),
//           ],
//         ),
//         drawer: loading
//             ? Drawer(
//                 child: ListView(
//                   children: [
//                     UserAccountsDrawerHeader(
//                       accountName: Text(
//                           '${_pcProvider.firstName} ${_pcProvider.lastName}'),
//                       accountEmail: Text(_pcProvider.email),
//                       // currentAccountPicture: const CircleAvatar(
//                       //   backgroundImage: AssetImage('assets/profile_picture.jpg'),
//                       // ),
//                       onDetailsPressed: () {
//                         // Show account details when the header is pressed
//                         _showAccountDetailsDialog(context);
//                       },
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.task),
//                       title: const Text('Tasks'),
//                       onTap: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) {
//                             return const PCProviderTasks();
//                           },
//                         ));
//                       },
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.feedback),
//                       title: const Text('Assign Feedback'),
//                       onTap: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) {
//                             return const PCProvAssignFeedbackPage();
//                           },
//                         ));
//                       },
//                     ),
//                   ],
//                 ),
//               )
//             : const LoadingAnimation2(),
//         body: loading
//             ? Column(
//                 children: [
//                   showNotifiation
//                       ? _buildNotifications(deviceWidth)
//                       : const SizedBox(
//                           height: 0,
//                         ),
//                   SizedBox(
//                     height: deviceHeight * 0.03,
//                   ),
//                   _pcProvider.formstatus < 5
//                       ? Padding(
//                           padding: EdgeInsets.all(deviceWidth * 0.04),
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Congratulations on joining Ubuntu!',
//                                   style: TextStyle(
//                                       fontSize: deviceWidth * 0.07,
//                                       fontStyle: FontStyle.italic,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight
//                                           .bold), // Set form content text size
//                                 ),
//                                 SizedBox(
//                                   height: deviceHeight * 0.03,
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     launchUrlString(whatsAppGroupLink);
//                                   },
//                                   child: Text('Join our WhatsApp group: ',
//                                       style: TextStyle(
//                                           fontSize: deviceWidth * 0.04)),
//                                 ),
//                                 SizedBox(
//                                   height: deviceHeight * 0.03,
//                                 ),
//                                 Text('Form Status',
//                                     style: TextStyle(
//                                         fontSize: deviceWidth * 0.08,
//                                         fontWeight: FontWeight.w300)),
//                                 SizedBox(
//                                   height: deviceHeight * 0.03,
//                                 ),
//                                 Text(formStatusValues[_pcProvider.formstatus],
//                                     style: TextStyle(
//                                       fontSize: deviceWidth * 0.08,
//                                       fontWeight: FontWeight.w400,
//                                     )),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Padding(
//                           padding: EdgeInsets.all(deviceWidth * 0.04),
//                           child: Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text('Total Amount Earned: ',
//                                         style: TextStyle(
//                                             fontSize: deviceWidth * 0.045,
//                                             fontWeight: FontWeight.w400)),
//                                     Text(
//                                         '${_pcProvider.totalAmountEarned.toStringAsFixed(2)} \$',
//                                         style: TextStyle(
//                                             fontSize: deviceWidth * 0.06,
//                                             fontWeight: FontWeight.w300)),
//                                   ],
//                                 ),
//                                 SizedBox(height: deviceHeight * 0.03),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text('Individual Income: ',
//                                         style: TextStyle(
//                                             fontSize: deviceWidth * 0.06,
//                                             fontWeight: FontWeight.w600)),
//                                     Text(
//                                         '${_pcProvider.personalAmountEarned.toStringAsFixed(2)} \$',
//                                         style: TextStyle(
//                                             fontSize: deviceWidth * 0.06,
//                                             fontWeight: FontWeight.w400)),
//                                   ],
//                                 ),
//                                 SizedBox(height: deviceHeight * 0.03),
//                                 Text('Account Status',
//                                     style: TextStyle(
//                                         fontSize: deviceWidth * 0.07,
//                                         fontWeight: FontWeight.w100)),
//                                 SizedBox(height: deviceHeight * 0.01),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                         accountStatusValues[
//                                             _pcProvider.accountStatus],
//                                         style: TextStyle(
//                                             fontSize: deviceWidth * 0.08,
//                                             fontWeight: FontWeight.w500)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                 ],
//               )
//             : const LoadingAnimation2(),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/pc_provider_database_service.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';
import 'package:ubuntu_system/Provider/authentication_provider.dart';
import 'package:ubuntu_system/Provider/pc_provider_provider_class.dart';
import 'package:ubuntu_system/View/Screens/PC%20Provider/Class/notification_item.dart';
import 'package:ubuntu_system/View/Screens/PC%20Provider/pc_prov_assign_feedback_page.dart';
import 'package:ubuntu_system/View/Screens/PC%20Provider/pc_provider_tasks.dart';
import 'package:ubuntu_system/View/Widgets/loading_animation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PcProviderDashboard extends StatefulWidget {
  const PcProviderDashboard({super.key});

  @override
  State<PcProviderDashboard> createState() => _PcProviderDashboardState();
}

class _PcProviderDashboardState extends State<PcProviderDashboard> {
  final List<NotificationItem> notifications = [
    NotificationItem(
      shortMessage: 'New message received',
      fullDetails: 'You have a new message from John Doe.',
    ),
    NotificationItem(
      shortMessage: 'New message received',
      fullDetails: 'You have a new message from John Doe.',
    ),
  ];

  bool showNotifiation = false;
  List<String> formStatusValues = [
    "Ready to onBoard",
    "onBoarded",
    "Ready to Apply",
    "Applied",
    "Ready to Setup",
    "Ready to be Active"
  ];
  List<String> accountStatusValues = [
    "EQ",
    "TeamV Disconnected",
    "Verify Email",
    "Active"
  ];

  String whatsAppGroupLink =
      "https://kotlinlang.org/docs/releases.html#release-details";

  Widget _buildNotifications(double deviceWidth) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: TextStyle(
                fontSize: deviceWidth * (kIsWeb ? 0.02 : 0.03),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification.shortMessage),
                subtitle: Text(notification.fullDetails),
                onTap: () {},
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAccountDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Account Details'),
          content: const Text('Placeholder content for account details.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _logoutAction(BuildContext context, double deviceWidth) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: Text(
            "Are you sure you want to Logout?",
            style: TextStyle(fontSize: deviceWidth * (kIsWeb ? 0.015 : 0.04)),
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
                style:
                    TextStyle(fontSize: deviceWidth * (kIsWeb ? 0.02 : 0.055)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style:
                    TextStyle(fontSize: deviceWidth * (kIsWeb ? 0.02 : 0.055)),
              ),
            ),
          ],
        );
      },
    );
  }

  late PcProvider _pcProvider;
  bool loading = false;

  late StreamSubscription getPcProviderSub;

  @override
  void initState() {
    super.initState();
    var authProv = context.read<AuthenticationProvider>().userVal;
    var pcProv = context.read<PCProviderClass>();
    getPcProviderSub = PcProviderDatabaseService()
        .getPcProvider(authProv!.uid)
        .listen((event) {
      _pcProvider = event[0];
      pcProv.assignPcProvider(_pcProvider);
      setState(() {
        loading = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    getPcProviderSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    const bool isWeb = kIsWeb;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ubuntu',
          style: TextStyle(fontSize: deviceWidth * (isWeb ? 0.02 : 0.06)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              setState(() {
                showNotifiation = !showNotifiation;
              });
            },
          ),
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
                        '${_pcProvider.firstName} ${_pcProvider.lastName}'),
                    accountEmail: Text(_pcProvider.email),
                    onDetailsPressed: () => _showAccountDetailsDialog(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.task),
                    title: const Text('Tasks'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PCProviderTasks(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.feedback),
                    title: const Text('Assign Feedback'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PCProvAssignFeedbackPage(),
                          ));
                    },
                  ),
                ],
              ),
            )
          : const LoadingAnimation2(),
      body: loading
          ? Column(
              children: [
                showNotifiation
                    ? _buildNotifications(deviceWidth)
                    : const SizedBox(height: 0),
                SizedBox(height: deviceHeight * (isWeb ? 0.02 : 0.03)),
                _pcProvider.formstatus < 5
                    ? Padding(
                        padding:
                            EdgeInsets.all(deviceWidth * (isWeb ? 0.01 : 0.04)),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Congratulations on joining Ubuntu!',
                                style: TextStyle(
                                  fontSize: deviceWidth * (isWeb ? 0.03 : 0.07),
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                  height: deviceHeight * (isWeb ? 0.01 : 0.03)),
                              ElevatedButton(
                                onPressed: () {
                                  launchUrlString(whatsAppGroupLink);
                                },
                                child: Text(
                                  'Join our WhatsApp group',
                                  style: TextStyle(
                                      fontSize:
                                          deviceWidth * (isWeb ? 0.015 : 0.04)),
                                ),
                              ),
                              SizedBox(
                                  height: deviceHeight * (isWeb ? 0.01 : 0.03)),
                              Text(
                                'Form Status',
                                style: TextStyle(
                                    fontSize:
                                        deviceWidth * (isWeb ? 0.03 : 0.08),
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                  height: deviceHeight * (isWeb ? 0.01 : 0.03)),
                              Text(
                                formStatusValues[_pcProvider.formstatus],
                                style: TextStyle(
                                  fontSize: deviceWidth * (isWeb ? 0.03 : 0.08),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.all(deviceWidth * (isWeb ? 0.01 : 0.04)),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Amount Earned: ',
                                    style: TextStyle(
                                        fontSize: deviceWidth *
                                            (isWeb ? 0.02 : 0.045),
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '${_pcProvider.totalAmountEarned.toStringAsFixed(2)} \$',
                                    style: TextStyle(
                                        fontSize:
                                            deviceWidth * (isWeb ? 0.03 : 0.06),
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: deviceHeight * (isWeb ? 0.01 : 0.03)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Individual Income: ',
                                    style: TextStyle(
                                        fontSize:
                                            deviceWidth * (isWeb ? 0.03 : 0.06),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${_pcProvider.personalAmountEarned.toStringAsFixed(2)} \$',
                                    style: TextStyle(
                                        fontSize:
                                            deviceWidth * (isWeb ? 0.03 : 0.06),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: deviceHeight * (isWeb ? 0.01 : 0.03)),
                              Text(
                                'Account Status',
                                style: TextStyle(
                                    fontSize:
                                        deviceWidth * (isWeb ? 0.02 : 0.07),
                                    fontWeight: FontWeight.w100),
                              ),
                              SizedBox(
                                  height:
                                      deviceHeight * (isWeb ? 0.005 : 0.01)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    accountStatusValues[
                                        _pcProvider.accountStatus],
                                    style: TextStyle(
                                        fontSize:
                                            deviceWidth * (isWeb ? 0.03 : 0.08),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            )
          : const LoadingAnimation2(),
    );
  }
}
