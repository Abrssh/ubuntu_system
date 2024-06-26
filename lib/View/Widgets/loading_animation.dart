import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    // var deviceWidth = deviceSize.width;
    var deviceHeight = deviceSize.height;
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: SpinKitChasingDots(
          // color: const Color.fromARGB(255, 4, 37, 64),
          color: Colors.purple,
          size: deviceHeight * 0.08,
        ),
      ),
    );
  }
}

class LoadingAnimation2 extends StatelessWidget {
  const LoadingAnimation2({super.key});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    // var deviceWidth = deviceSize.width;
    var deviceHeight = deviceSize.height;
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: SpinKitDoubleBounce(
          // color: const Color.fromARGB(255, 4, 37, 64),
          color: Colors.blue,
          size: deviceHeight * 0.08,
        ),
      ),
    );
  }
}
