
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  final VoidCallback? onFinish; // Make onFinish optional

  LoadingScreen({this.onFinish});

  @override
  Widget build(BuildContext context) {
    // Call onFinish after a 3-second delay if it's provided
    Future.delayed(const Duration(seconds: 3), () {
      if (onFinish != null) onFinish!();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Lottie.asset(
            height: 400,
            'lib/assets/lottieAnimations/newTimer.json',

            // width: 100,

            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}




