import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sanad/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanad',
      theme: ThemeData(
        fontFamily: 'Fredoka',
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        duration: 2000,
        splash: Image.asset(
          'assets/images/splash.png',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),

        nextScreen: WelcomePage(title: 'Sanad'),
        splashIconSize: double.infinity,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      ),

    );
  }
}

