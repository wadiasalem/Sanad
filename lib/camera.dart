import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sanad/tflite/classifier.dart';
import 'package:sanad/utils/OutputData.dart';
import 'package:sanad/welcome.dart';

class CameraPage extends StatefulWidget {

  const CameraPage({
    Key key,
    this.camera,
    this.character
  }) : super(key: key);

  final CameraDescription camera;
  final String character;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {

  ///audio player
  AssetsAudioPlayer audioPlayer ;
  AssetsAudioPlayer cameraStart ;

  ///audio play list
  List<Audio> audios ;

  /// Controller
  CameraController cameraController;

  ///camera frame
  CameraImage cameraImage;

  /// true when model is running
  bool running;

  /// true when still predicting
  bool predicting;

  /// Instance of Classifier
  Classifier classifier;

  ///output Data List
  OutputData output;

  ///timer 5 sec to predict
  Timer timer;

  Timer exitTimer;


  @override
  void initState(){
    super.initState();
    audioPlayer = AssetsAudioPlayer.newPlayer();
    cameraStart = AssetsAudioPlayer.newPlayer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    audios = [] ;
    /// create classifier
    initStateAsync();
    ///init the output list
    output = OutputData();
  }

  void cameraStartSound(){
    ///start a sound after the camera starter
    cameraStart.open(
        Audio("assets/audio/cameraStart.wav"),
        autoStart: true,
        showNotification: true
    );
  }

  void resultSound(String result)async{
    if(result == '0'){
      audios=[
        Audio("assets/audio/"+widget.character+"/0.mp3"),
        Audio("assets/audio/"+widget.character+"/fermeture.mp3"),
      ];
    }else {
      audios = [
        Audio("assets/audio/" + widget.character + "/montant.mp3"),
        Audio("assets/audio/" + widget.character + "/" + result + ".mp3"),
        Audio("assets/audio/" + widget.character + "/dinar.mp3"),
        Audio("assets/audio/"+widget.character+"/fermeture.mp3"),
      ];
    }
    ///start a sound after the result
    await audioPlayer.open(
        Playlist(audios: audios ),
        autoStart: true,
        showNotification: true
    );
    audioPlayer.playlistFinished.listen((finished) {
      if(finished) {
        predicting=false;
        exitTimer = Timer(Duration(seconds: 2), () {
          exit(0);
        });
      }
    });

  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);
    /// Camera initialization
    await initializeCamera();

    /// Create an instance of classifier to load model and labels
    classifier = Classifier();

    /// Initially predicting = false
    running = false;
  }


  /// Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    ///create camera controller
    cameraController =
        CameraController(
          widget.camera,
          ResolutionPreset.high,
          imageFormatGroup:
          ImageFormatGroup.yuv420,);

    ///init the camera
    await cameraController.initialize().then((_) async {
      startStream();
    });
  }

  void startStream() async{
    predicting=true;
    exitTimer?.cancel();

    ///run sound
    cameraStartSound();
    /// Stream of image passed to [onLatestImageAvailable] callback
    await cameraController.startImageStream(onLatestImageAvailable);
    ///predict after 5 sec
    timer = Timer(Duration(seconds: 5), (){
      cameraController.stopImageStream();
      resultSound(output.getResult());
    });
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  onLatestImageAvailable(CameraImage cameraImage) async {
    ///if the model not loaded yet then return
    if (classifier.modelLoaded == false) return ;

    /// If previous inference has not completed then return
    if (running) return;

    setState(() {
      running = true;
    });
    ///add the result to the output results
    output.addData(await classifier.predict(cameraImage));
    /// set predicting to false to allow new frames
    setState(() {
      running = false;
    });

  }


  _navigatWelcome()async{
    WidgetsFlutterBinding.ensureInitialized();
    timer?.cancel();
    audioPlayer.stop();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>WelcomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapUp: (_) => {
          if(!predicting)
          startStream()
    },
    child:Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 50,
          title: IconButton(
            onPressed: (){
              _navigatWelcome();
            },
            icon: Icon(
              Icons.assignment_return_outlined,
              color: Colors.white,
              size: 40,
            ),
            iconSize: 50,
          ),
        ),
     body: Center(
         child:((){
       if(cameraController == null){
         return Container();
       }


       if(!cameraController.value.isInitialized){
         return Container();
       }
       return CameraPreview(cameraController);
     }())),

      )
    );
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController.value.isStreamingImages) {
          await cameraController.startImageStream(onLatestImageAvailable);
        }
        break;
      default:
    }
  }

  @override
  void dispose() async{
    super.dispose();
  }

}