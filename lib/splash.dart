import 'package:flutter/material.dart';
import 'home.dart';
import 'main.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
    @override
    void initState(){
      super.initState();
      _navigatehome();
    }
    _navigatehome()async{
      await Future.delayed(Duration(milliseconds: 2500),(){});
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: 'Sanad',)));
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
            child: Image.asset(
              'assets/images/splash.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),

      ),

    );
  }
}

