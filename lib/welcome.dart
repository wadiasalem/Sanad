import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:camera/camera.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:sanad/camera.dart';
import 'package:sanad/settings/settingsInterface.dart';
import 'package:sanad/settings/settings.dart' as settingsPage;
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {

  const WelcomePage({Key key,this.title}) : super(key: key);
  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  AssetsAudioPlayer audioPlayer ;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String _character;
  settingsInterface settings = settingsInterface();



  @override
  void initState(){
    audioPlayer = AssetsAudioPlayer.newPlayer();
    super.initState();
    getSettings();

  }

  @override
  void dispose() {
    super.dispose();
  }


  void openPlayer(character){
    audioPlayer.open(
        Audio("assets/audio/"+character+"/ouverture.mp3"),
        autoStart: true,
        showNotification: true
    );
    audioPlayer.playlistAudioFinished.listen((event) {
      Timer(Duration(seconds: 2), () {
        _navigatCamera();
      });
    });
  }

  void getSettings()async{
    await _prefs.then((SharedPreferences prefs) {
      return (prefs.getString("language") ?? "FR");
    }).then((String language){
      _prefs.then((SharedPreferences prefs) {
        return  (prefs.getString("character") ?? ((language=="AR")?"karim":"alain"));
      }).then((String character){
        openPlayer(character);
        setState(() {
          _character=character;
        });

      });

    });
  }


  _navigatCamera()async{
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final camera = cameras.first;
    audioPlayer.stop();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CameraPage(
      camera: camera,
      character: _character,
    )));
  }

  _navigatSettings()async{
    WidgetsFlutterBinding.ensureInitialized();
    audioPlayer.stop();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>settingsPage.SettingsPage(
      settings: settings,
    )));
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTapUp: (_) => {
          _navigatSettings()
        },
         child:Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 100,
              actions: [
                IconButton(
                    onPressed: (){

                    },
                  icon: Image.asset('assets/images/logo.png',),
                  iconSize: 100,
                )
              ],
            ),
            body: Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                child:  Image.asset(
                  (   ((_character=="karim") | (_character=="alain"))?
                      'assets/characters/character1.png':
                      'assets/characters/character2.png'
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                )
              ),

                  SizedBox(height: 50),
                  Text(
                      "Bienvenu à SANAD",
                      style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: HexColor("2b3c23"),
                      )
                  ),
                  SizedBox(height: 40),
                  Text(
                      "Votre fidèle assistant",
                      style: TextStyle(
                        fontSize: 25,
                        color: HexColor("2b3c23"),
                      )
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                      onPressed: (){
                        _navigatCamera();
                    },
                     style: ButtonStyle(
                       backgroundColor: MaterialStateProperty.all<Color>(HexColor("2b3c23")),
                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                           RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20.0),
                           )
                       ),
                       fixedSize: MaterialStateProperty.all(Size(240, 60)),
                     ),
                      child:const Text(
                        "Commencer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25
                        ),
                      )
                  )

                ],
              ),
            ),
          // This trailing comma makes auto-formatting nicer for build methods.
        )

    );
  }
}
