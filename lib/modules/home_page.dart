import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:untitled/modules/camera_page.dart';
import 'package:untitled/utils/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? xFile;
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Recognition"),
      ),
      body: Center(
        child: _buttons(),
      ),
    );
  }

  Widget _buttons() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ElevatedButton(
            onPressed: () {
              goTo(context, const CameraPage()).then((value){
                setState(() {
                 xFile = value;
                });
              });
            },
            child: const Text("Add Face")),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: () {}, child: const Text("Compare Face")),
        const SizedBox(height: 20),
        if (xFile != null) _captureImage()
      ]),
    );
  }

  Widget _captureImage() {
    return Image.file(
      File(xFile!.path),
      height: 100,
      width: 100,
    );
  }
}
