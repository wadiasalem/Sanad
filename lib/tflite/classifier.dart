import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

class Classifier {

  ///model assets path
  static const String MODEL_FILE_NAME = "assets/models/currency.tflite";
  static const String LABEL_FILE_NAME = "assets/models/currencylabels.txt";

  ///model status is loaded or not
  static bool _modelLoaded = false ;


  Classifier() {
    Classifier.loadModel().then((value) {
        _modelLoaded = true;
    });
  }

  /// Loads interpreter from asset
  static Future<String> loadModel() async {
    try {
      String res = await Tflite.loadModel(
          model: MODEL_FILE_NAME,
          labels: LABEL_FILE_NAME,
          numThreads: 1,
          isAsset: true,
          useGpuDelegate: false
      );
      return res;
    } catch (e) {
      print("Error while loading module: $e");
    }
  }

  /// Loads interpreter from asset
  static Future<String> stopModel() async {
    try {
      String res = await Tflite.close();
      return res;
    } catch (e) {
      print("Error while stopping the module: $e");
    }
  }

  /// Gets the interpreter instance
  bool get modelLoaded => _modelLoaded;

  Future<dynamic> predict(CameraImage image)async{
    return await Tflite.runModelOnFrame(
        bytesList: image
            .planes.map((plane)
        {return plane.bytes;})
            .toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        numResults: 5)
        .then((value) {
          var res = value[0];
          if(value.length == 1)
            return res['label'];
          for(var i=1;i<value.length ;i++){
            if(value[i]['confidence']>res['confidence'])
              res = value[i];
          }
          return res['label'];
    });
  }

}