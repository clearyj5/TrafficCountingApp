import 'package:flutter/material.dart';
import 'package:traffic_counting_project/traffic_home_screen.dart';
import 'package:traffic_counting_project/camera_screen.dart';
import 'package:camera/camera.dart';

void main() async {

  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Traffic UI',
      debugShowCheckedModeBanner: false,
      home: TrafficHomeScreen(),
    );
  }
}
//---------------Jack
