import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vcook_app/service/scan.dart';

class CameraOn extends StatelessWidget{
  const CameraOn({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value
              ? CameraPreview(controller.cameraController)
              : const Center(child: Text("Loading Previwe.."));
      }),
      );
  }
}