import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  List<CameraDescription> cameras = [];
  late CameraController controller;
  int selectedCamera = 0;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: FutureBuilder(
        future: _initCamera(),
        builder: (BuildContext context, AsyncSnapshot<CameraController> snapshot) {
          if(snapshot.hasData){
            return _cameraPreview(snapshot.data!);
          }else if(snapshot.hasError){
            return Center(child: Text((snapshot.error as String)));
          }else{
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }

  Future<CameraController> _initCamera()async{
    cameras = await availableCameras();
    if(cameras.isNotEmpty){
      controller = CameraController(cameras[selectedCamera], ResolutionPreset.max);
      await controller.initialize().catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
            // Handle access errors here.
              break;
            default:
            // Handle other errors here.
              break;
          }
        }
      });
      return controller;
    }else{
     return Future.error("No camera available");
    }
  }

  Widget _cameraPreview(CameraController cameraController){
    return Stack(
      children: [
        CameraPreview(cameraController),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(onPressed: (){
            setState(() {
              selectedCamera = selectedCamera == 0 ? 1:0;
            });
          }, icon:  const Icon(Icons.rotate_left,color: Colors.white,)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
            child: ElevatedButton(onPressed: () => _capture(), child: const Text("Capture"))),
      ],
    );
  }

  void _capture()async{
    try{
      final image = await controller.takePicture();
      if(context.mounted){
        Navigator.pop(context,image);
      }
    }catch(e){
      log("Error on capture image --> ${e.toString()}");
    }
  }
}
