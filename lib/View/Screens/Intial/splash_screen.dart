import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ubuntu_system/View/Screens/Intial/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // context.go("/${RouteConstant.authGatePath}");
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return const AuthGate();
        },
      ));
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.network(
          "https://th.bing.com/th/id/OIP.ep0z0M7rJpK14WuGshv3EwHaEK?rs=1&pid=ImgDetMain",
          width: 300,
          height: 250,
        ),
      ),
    );
  }
}
