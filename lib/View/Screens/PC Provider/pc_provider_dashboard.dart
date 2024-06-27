import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Data/Firebase/Firestore%20Database/pc_provider_database_service.dart';
import 'package:ubuntu_system/Data/Model/pc_provider.dart';
import 'package:ubuntu_system/Provider/authentication_provider.dart';
import 'package:ubuntu_system/View/Screens/PC%20Provider/Class/notification_item.dart';
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
    // Add more notifications here
  ];

  bool showForm = false, showNotifiation = false;
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
                fontSize: deviceWidth * 0.03, fontWeight: FontWeight.bold),
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
                onTap: () {
                  // Handle notification tap (e.g., show detailed view)
                },
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
          title: Text('Account Details'),
          content: Text('Placeholder content for account details.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  late PcProvider _pcProvider;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    var authProv = context.read<AuthenticationProvider>().userVal;
    PcProviderDatabaseService().getPcProvider(authProv!.uid).listen((event) {
      _pcProvider = event[0];
      setState(() {
        loading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Ubuntu',
            style: TextStyle(
                fontSize: deviceWidth * 0.06), // Set app bar text size
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Handle notification icon tap (e.g., show a notification screen)
                setState(() {
                  showNotifiation = !showNotifiation;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                // Handle exit action
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
                      // currentAccountPicture: const CircleAvatar(
                      //   backgroundImage: AssetImage('assets/profile_picture.jpg'),
                      // ),
                      onDetailsPressed: () {
                        // Show account details when the header is pressed
                        _showAccountDetailsDialog(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Tasks'),
                      onTap: () {},
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
                      : const SizedBox(
                          height: 0,
                        ),
                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),
                  _pcProvider.formstatus < 5
                      ? Padding(
                          padding: EdgeInsets.all(deviceWidth * 0.04),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Congratulations on joining Ubuntu!',
                                  style: TextStyle(
                                      fontSize: deviceWidth * 0.07,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      fontWeight: FontWeight
                                          .bold), // Set form content text size
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    launchUrlString(whatsAppGroupLink);
                                  },
                                  child: Text('Join our WhatsApp group: ',
                                      style: TextStyle(
                                          fontSize: deviceWidth * 0.04)),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                Text('Form Status',
                                    style: TextStyle(
                                        fontSize: deviceWidth * 0.08,
                                        fontWeight: FontWeight.w300)),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                Text(formStatusValues[_pcProvider.formstatus],
                                    style: TextStyle(
                                      fontSize: deviceWidth * 0.08,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(deviceWidth * 0.04),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Total Amount Earned: ',
                                        style: TextStyle(
                                            fontSize: deviceWidth * 0.045,
                                            fontWeight: FontWeight.w400)),
                                    Text('${_pcProvider.totalAmountEarned} \$',
                                        style: TextStyle(
                                            fontSize: deviceWidth * 0.06,
                                            fontWeight: FontWeight.w300)),
                                  ],
                                ),
                                SizedBox(height: deviceHeight * 0.03),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Individual Income: ',
                                        style: TextStyle(
                                            fontSize: deviceWidth * 0.06,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${_pcProvider.personalAmountEarned} \$',
                                        style: TextStyle(
                                            fontSize: deviceWidth * 0.06,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                SizedBox(height: deviceHeight * 0.03),
                                Text('Account Status',
                                    style: TextStyle(
                                        fontSize: deviceWidth * 0.07,
                                        fontWeight: FontWeight.w300)),
                                SizedBox(height: deviceHeight * 0.01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        accountStatusValues[
                                            _pcProvider.accountStatus],
                                        style: TextStyle(
                                            fontSize: deviceWidth * 0.08,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              )
            : const LoadingAnimation2(),
      ),
    );
  }
}
