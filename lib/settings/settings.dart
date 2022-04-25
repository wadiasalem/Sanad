import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sanad/settings/clipPath.dart';
import 'package:sanad/settings/settingsInterface.dart';
import 'package:sanad/welcome.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key,settingsInterface this.settings}):super(key: key);
  final settingsInterface settings;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AssetsAudioPlayer audioPlayer ;


  @override
  void initState(){
    audioPlayer = AssetsAudioPlayer.newPlayer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void setCharacter(character){
    audioPlayer.stop();
    widget.settings.setCharacter(character);

    audioPlayer.open(

        Audio("assets/audio/"+character+"/intro.mp3"),
        autoStart: true,
        showNotification: true
    );
  }

  void setLanguage(language)async{
    audioPlayer.stop();
    String character = widget.settings.character;
    print(widget.settings.language);
      if(language=="AR"&&character=="alain"){
        character = "karim";
      }else if (language=="AR"&&character=="estelle"){
        character = "nour";
      }else if(language=="FR"&&character=="nour"){
        character = "estelle";
      }else if((language=="FR"&&character=="karim")){
        character = "alain";
      }

    setState(() {
      widget.settings.setSettings(language,character);
    });

    audioPlayer.open(
        Audio("assets/audio/"+character+"/intro.mp3"),
        autoStart: true,
        showNotification: true
    );
  }

  _return()async{
    WidgetsFlutterBinding.ensureInitialized();
    audioPlayer.stop();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomePage()));
  }


  @override
  Widget build(BuildContext context) {

    _navigatWelcome()async{
      WidgetsFlutterBinding.ensureInitialized();
      audioPlayer.stop();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomePage()));
    }

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 100,
            title: IconButton(
              onPressed: (){
                _navigatWelcome();
              },
              icon: Icon(
                Icons.assignment_return_outlined,
                color: HexColor("2b3c23"),
                size: 50,
              ),
              iconSize: 100,
            ),
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
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
              Expanded(
                  flex: 4,
                  child:Container(
                    child:  Row(
                      children: [
                              Expanded(
                                flex: 5,

                                child: Column(

                                  children: [
                                    Container(

                                        child:
                                            IconButton(
                                            onPressed: (){
                                              setCharacter(widget.settings.language=="AR"?"karim":"alain");
                                            },
                                              icon: Image.asset('assets/characters/character1.png',),
                                              iconSize: width/3,
                                            )
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),

                                      child: Container(
                                        color: HexColor("91A886"),
                                        child: Padding(
                                            padding: EdgeInsets.all(15), //apply padding to all four sides
                                            child: Text(
                                              widget.settings.language=="AR"?"Karim":"Alain",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                backgroundColor: HexColor("91A886"),
                                                fontSize: width/25,

                                              ),
                                            )
                                        ),
                                      )

                                    )

                                  ],
                                )
                              ),
                              Expanded(
                                flex: 5,
                                  child: Column(

                                    children: [
                                      Container(

                                          child: IconButton(
                                            onPressed: (){
                                              setCharacter(widget.settings.language=="AR"?"nour":"estelle");
                                            },
                                            icon: Image.asset('assets/characters/character2.png',),
                                            iconSize: width/3,
                                          )
                                      ),
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(20.0),

                                          child: Container(
                                            color: HexColor("91A886"),
                                            child: Padding(
                                                padding: EdgeInsets.all(15), //apply padding to all four sides
                                                child: Text(
                                                  widget.settings.language=="AR"?"Nour":"Estelle",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      backgroundColor: HexColor("91A886"),
                                                      fontSize: width/25,

                                                  ),
                                                )
                                            ),
                                          )

                                      )


                                    ],
                                  )
                              )



                      ],
                    )
                )
              ),
            ClipPath(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    color: HexColor("91A886"),
                  ),
                  clipper: WaveClipper(),
                ),

            Expanded(
                flex: 5,
                child : Container(
                  color: HexColor("91A886"),
                  child: Center(

                    child: Container(
                      height: 300,
                      child: Column(

                        children: [
                          Container(
                            height: 30,
                          ),
                          Text(
                              "Language de direction",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width/20,
                              )
                          ),
                          Container(
                            height: 30,
                          ),
                          Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    child:
                                    FlatButton(
                                      onPressed: () {
                                        setLanguage("FR");
                                      },
                                      padding: EdgeInsets.all(0.0),

                                      child:
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
                                        child: Image.asset('assets/flags/FR.png',width: width/3),
                                      ),

                                    ),


                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    child: FlatButton(
                                      onPressed: () {
                                        setLanguage("AR");
                                      },
                                      padding: EdgeInsets.all(0.0),

                                      child:
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
                                        child: Image.asset('assets/flags/AR.png',width: width/3),
                                      ),

                                    ),
                                  ),
                                )
                              ]
                          )
                        ],
                      ),
                    )
                  )
              ,
                ),
              )




              ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.


    );
  }
}
