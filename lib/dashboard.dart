import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'graph_painter.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  BuildContext _context;
  Animation<double> _animation;
  AnimationController _controller;
  List<Offset> points;
  int strokes = 20;
  double _t = 0;
  List<Vehicle> vehicles  = [Vehicle.CAR, Vehicle.BICYCLE, Vehicle.BUS, Vehicle.ALL];
  Vehicle currVehicle = Vehicle.CAR;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _t = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.stop();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
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
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: CustomScrollView(
                    anchor: 0.0,
                    shrinkWrap: false,
                    physics: ClampingScrollPhysics(),
                    slivers: <Widget>[
                      _buildHeader(),
                      _buildRegionTabBar(),
                      // _buildStatsTabBar(),
                    ],
                  )),
              Expanded(
                flex: 4,
                child: Container(
                  alignment: Alignment.center,
                  height: vh(.8),
                  width: vw(.8),
                  child: CustomPaint(
                    painter: GraphPainter.drawBarChart(<Offset>[
                      Offset(0, 13),
                      Offset(0, 7),
                      Offset(0, 10),
                    ], strokes, _t, currVehicle),

                    // GraphPainter(points, strokes, _t, _bezierpoints,
                    //     _titles[_titleIndex], _chartTimes),
                    size: Size(vw(.9), vh(.5)),
                  ),
                ),
              )
            ],
          )),
    );
  }

  double vw(double ratio) {
    return MediaQuery.of(_context).size.width * ratio;
  }

  double vh(double ratio) {
    return MediaQuery.of(_context).size.height * ratio;
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Text(
            'Detected Traffic',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void setColor(Container c, int colo) {}
  SliverToBoxAdapter _buildRegionTabBar() {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 4,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Color(0xFF4563DB),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TabBar(
            indicator: BubbleTabIndicator(
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
                indicatorHeight: 40.0,
                indicatorColor: Colors.white),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Text('Cars'),
              Text('Bicycles'),
              Text('Buses'),
              Text('All'),
            ],
            onTap: (index) {
              setState(() {
                currVehicle = vehicles[index];
                _controller.stop();
                _t = 0;
                _controller.reset();
                _controller.forward();
              });
            },
          ),
        ),
      ),
    );

    // SliverPadding _buildStatsTabBar() {
    //   return SliverPadding();
    // }
  }

  // ------------------------------------------------------Michael
  //
}
