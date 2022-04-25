import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:sanad/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sanad/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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

