import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanad/camera.dart';


/// [HomeView] stacks [CameraView] and [BoxWidget]s with bottom sheet for stats
class mainCameraView extends StatefulWidget {

  final CameraDescription camera;

  const mainCameraView({
    Key key,
    this.camera,}) : super(key: key);

  @override
  _mainCameraView createState() => _mainCameraView();
}

class _mainCameraView extends State<mainCameraView> {
  /// Scaffold Key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Camera View
          CameraPage(
              camera: widget.camera,
              ),

        ],
      ),
    );
  }

}

