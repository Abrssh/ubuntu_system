import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Provider/administrator_provider.dart';
import 'package:ubuntu_system/Provider/authentication_provider.dart';
import 'package:ubuntu_system/Provider/employee_acc_provider.dart';
import 'package:ubuntu_system/Provider/pc_provider_provider_class.dart';
import 'package:ubuntu_system/View/Screens/Intial/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(DevicePreview(
    builder: (context) => const MainApp(),
    enabled: !kReleaseMode,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmployeeAccProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PCProviderClass(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdministratorProvider(),
        ),
      ],
      child: MaterialApp(
        // useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: const Scaffold(body: SplashScreen()),
      ),
    );
  }
}
