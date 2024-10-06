import 'package:flutter/material.dart';
import 'package:traffic_counting_project/camera_screen.dart';
import 'package:traffic_counting_project/dashboard.dart';
import 'package:traffic_counting_project/loading_screen.dart';

class TrafficHomeScreen extends StatefulWidget {
  @override
  _TrafficHomeScreenState createState() => _TrafficHomeScreenState();
}
//hello-----

class _TrafficHomeScreenState extends State<TrafficHomeScreen> with TickerProviderStateMixin {
  Animation<Color> animationGreen;
  AnimationController controllerGreen;

  Animation<Color> animationYellow;
  AnimationController controllerYellow;

  Animation<Color> animationRed;
  AnimationController controllerRed;

  @override
  void initState() {
    super.initState();

    controllerGreen =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1400));
    animationGreen = ColorTween(begin: Colors.green[700], end: Colors.lightGreenAccent).animate(controllerGreen)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllerGreen.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controllerGreen.forward();
        }
      });

    controllerGreen.forward();

    controllerYellow =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    animationYellow = ColorTween(begin: Colors.orange, end: Colors.yellowAccent).animate(controllerYellow)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllerYellow.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controllerYellow.forward();
        }
      });

    controllerYellow.forward();

    controllerRed =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    animationRed = ColorTween(begin: Colors.red[800], end: Colors.pinkAccent).animate(controllerRed)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controllerRed.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controllerRed.forward();
        }
      });

    controllerRed.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Countify+",
          style: TextStyle(fontFamily: "Chicle", fontSize: 40),
        ),
        backgroundColor: Color(0xFF3594DD),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashBoard()),
            );
          },
          child: Icon(
            Icons.bar_chart,
            color: Colors.orangeAccent, // add custom icons also
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30),
            height: MediaQuery.of(context).size.width * .2,
            alignment: Alignment.center,
            child: Text(
              "Ready... Steady... GO!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white, fontSize: 30, fontFamily: "Ubuntu"),

            ),
          ),
          Center(
            child: Container(
              height: 300,
              width: 150,
              child: Stack(
                children: [
                  Container(
                    //  alignment: Alignment.center,
                    height: 300,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.4, 0.7, 0.9],
                        colors: [
                          Colors.grey[500],
                          Colors.grey[500],
                          Colors.grey[500],
                          Colors.grey[600],
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.only(left: 40.25, top: 20),
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: 67.5,
                          width: 67.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: animationRed.value,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 40.25, top: 20),
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: 67.5,
                          width: 67.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: animationYellow.value,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 40.25, top: 20),
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: 67.5,
                          width: 67.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: animationGreen.value,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 5,
            child: const DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.red,
                    Colors.green,
                  ],
                ),
              ),
            ),
          ),
          InkWell(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white60,
                  width: double.infinity,
                  height: 80,
                  child: Center(
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold,
                        fontSize: 37,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraScreen()),
                );
              }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controllerRed.dispose();
    controllerGreen.dispose();
    controllerYellow.dispose();
    super.dispose();
  }
}
//------------------------------------------------------ Lola

