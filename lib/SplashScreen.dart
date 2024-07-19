import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_projects/HomeScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        fontFamily: 'Montserrat',
      ),
      child: AnimatedSplashScreen(
        splash: Column(
          children: [
            Expanded(
              child: Center(
                child: Lottie.asset(
                  'assets/images/1.json',
                  animate: true,
                ),
              ),
            ),
          ],
        ),
        nextScreen: const HomeLayout(),
        splashIconSize: 350,
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor:Colors.cyan,
      ),
    );
  }
}


