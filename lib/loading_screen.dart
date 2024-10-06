import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:traffic_counting_project/dashboard.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: DashBoard(),
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.1, 0.4, 0.7, 0.9],
        colors: [
          Color(0xFF3594DD),
          Color(0xFF4563DB),
          Color(0xFF5036D5),
          Color(0xFF5B16D0),
        ],
      ),
      useLoader: true,
      loaderColor: Colors.white,
      loadingText: Text(
        "Counting detected vehicles",
        style:
            TextStyle(color: Colors.white, fontFamily: "Poppins", fontSize: 35),
        textAlign: TextAlign.center,
      ),
    );
  }
}
