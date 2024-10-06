import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'bezier.dart';

class GraphPainter extends CustomPainter {
  List<Offset> _points;
  List<Bezier> _bezierpoints;
  List<Offset> drawnPoints = [];
  List<String> _chartTimes;
  double _left, _top, _width, _height;
  int _len;
  double _t;
  int _strokes;
  String _chartTitle;
  Vehicle _vehicle;
  List<String> _titles = <String>["Cars", "Bicycles", "Buses"];
  GraphPainter(this._points, this._strokes, this._t, this._bezierpoints,
      this._chartTitle, this._chartTimes);

  GraphPainter.drawBarChart(
      this._points, this._strokes, this._t, this._vehicle);
  Offset _getCubicBezier(Offset p0, Offset p1, Offset p2, Offset p3, double t) {
    double u = 1 - t;
    double uu = u * u;
    double uuu = u * u * u;
    double tt = t * t;
    double ttt = t * t * t;
    return (p0 * uuu) + (p1 * 3 * uu * t) + (p2 * 3 * u * tt) + (p3 * ttt);
  }

  void _drawCurve(List<Offset> points, Canvas canvas, Size size, Paint paint) {
    Color prevColor = paint.color;
    double prevStrokeWidth = paint.strokeWidth;
    paint.strokeWidth = 2;
    paint.color = Colors.white;
    _len = _bezierpoints.length;
    //draw the curve
    Offset p1;
    final double radius = 10;
    int end = (_len == _strokes - 2) ? _len : _len - 1;
    for (int i = 0; i < end; i++) {
      Bezier b = _bezierpoints[i];
      p1 = b.p0;
      p1 = Offset(_left + p1.dx / _strokes * _width,
          _top + (_strokes - p1.dy) / _strokes * _height);
      for (double t = 0; t <= 1.0; t += 0.01) {
        Offset p2 = _getCubicBezier(b.p0, b.p1, b.p2, b.p3, t);
        p2 = Offset(_left + p2.dx / _strokes * _width,
            _top + (_strokes - p2.dy) / _strokes * _height);
        canvas.drawLine(p1, p2, paint);
        p1 = p2;
      }
      canvas.drawArc(
          Rect.fromLTWH(p1.dx - radius, p1.dy - radius, radius * 2, radius * 2),
          0,
          pi * 2.0,
          true,
          paint);
    }
    if (end != _strokes - 2) {
      Bezier b = _bezierpoints[_len - 1];
      p1 = b.p0;
      p1 = Offset(_left + p1.dx / _strokes * _width,
          _top + (_strokes - p1.dy) / _strokes * _height);
      for (double t = 0; t <= _t; t += 0.01) {
        Offset p2 = _getCubicBezier(b.p0, b.p1, b.p2, b.p3, t);
        p2 = Offset(_left + p2.dx / _strokes * _width,
            _top + (_strokes - p2.dy) / _strokes * _height);
        canvas.drawLine(p1, p2, paint);
        p1 = p2;
      }
    }
    paint.color = prevColor;
    paint.strokeWidth = prevStrokeWidth;
  }

  void _drawGuidingLines(Canvas canvas, Size size, Paint paint) {
    Color prevColor = paint.color;
    paint.color = Color(0x22FFFFFF);
    final double lineWidth = _width * .9;
    for (int i = 0; i < _strokes; i += 1) {
      double top = _top + _height / _strokes * (i + 1);
      Offset p1 = Offset(_left + (_width - lineWidth) / 2, top);
      Offset p2 = Offset(_left + (_width - lineWidth) / 2 + lineWidth, top);
      canvas.drawLine(p1, p2, paint);
    }
    paint.color = prevColor;
  }

  void _drawLabel(String label, Size size, Canvas canvas, Paint paint) {
    final double fontSize = 23;
    ui.ParagraphStyle ps =
        ui.ParagraphStyle(textAlign: TextAlign.center, fontSize: fontSize);
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ps);
    pb.pushStyle(ui.TextStyle(color: Colors.white));
    pb.addText(label);
    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: 300);
    ui.Paragraph par = pb.build();
    par.layout(pc);

    double left = size.width / 2 - par.width / 2;
    double top = size.height * 0;
    canvas.drawParagraph(par, Offset(left, top));

    final double lineWidth = size.width * .1;
    left = size.width / 2 - lineWidth / 2;
    top = size.height * 0 + par.height;
    Color prevColor = paint.color;
    double stroke = paint.strokeWidth;
    paint.color = Colors.white;
    paint.strokeWidth = 3;
    canvas.drawLine(Offset(left, top), Offset(left + lineWidth, top), paint);
    paint.color = prevColor;
    paint.strokeWidth = stroke;
  }

  void _drawAxes(Canvas canvas, Paint paint) {
    Color prevColor = paint.color;
    double prevStrokeWidth = paint.strokeWidth;
    paint.color = Colors.white;
    paint.strokeWidth = 2.5;
    canvas.drawLine(Offset(_left, _top), Offset(_left, _top + _height), paint);
    canvas.drawLine(Offset(_left, _top + _height),
        Offset(_left + _width, _top + _height), paint);
    paint.color = prevColor;
    paint.strokeWidth = prevStrokeWidth;
  }

  void _drawNumbers(Canvas canvas, Paint paint, double offset) {
    final double fontSize = _width / 4 * .2;
    ui.ParagraphBuilder pb;
    ui.ParagraphStyle ps;
    ui.ParagraphConstraints pc;
    ui.Paragraph par;
    Offset off;
    //draw the vertical numbers
    for (int i = 0; i < _strokes; i += 2) {
      ps = ui.ParagraphStyle(textAlign: TextAlign.right, fontSize: fontSize);
      pb = ui.ParagraphBuilder(ps);
      pb.pushStyle(ui.TextStyle(color: Colors.white));
      pb.addText("${_strokes - i - 1}");
      pc = ui.ParagraphConstraints(width: 100);
      par = pb.build();
      par.layout(pc);
      double topOffset = _top + _height / _strokes * (i + 1) - par.height / 2;
      off = Offset(_left - offset - par.width, topOffset);
      canvas.drawParagraph(par, off);
    }

    int vehicle;
    switch (_vehicle) {
      case Vehicle.CAR:
        vehicle = 0;
        break;
      case Vehicle.BICYCLE:
        vehicle = 1;
        break;
      case Vehicle.BUS:
        vehicle = 2;
        break;
      case Vehicle.ALL:
        for (int i = 0; i < _titles.length; i++) {
          pc = ui.ParagraphConstraints(width: 300);
          ps = ui.ParagraphStyle(
              textAlign: TextAlign.center, fontSize: fontSize);
          pb = ui.ParagraphBuilder(ps);
          pb.pushStyle(ui.TextStyle(color: Colors.white));
          pb.addText(_titles[i]);
          par = pb.build();
          par.layout(pc);
          double leftOffset =
              _left + _width / (_titles.length + 1) * (i + 1) - par.width / 2;
          off = Offset(leftOffset, _top + _height + offset);
          canvas.drawParagraph(par, off);
        }
        return;
    }
    pc = ui.ParagraphConstraints(width: 300);
    ps = ui.ParagraphStyle(textAlign: TextAlign.center, fontSize: fontSize);
    pb = ui.ParagraphBuilder(ps);
    pb.pushStyle(ui.TextStyle(color: Colors.white));
    pb.addText(_titles[vehicle]);
    par = pb.build();
    par.layout(pc);
    double leftOffset =
        _left + _width / (_titles.length + 1) * (vehicle + 1) - par.width / 2;
    off = Offset(leftOffset, _top + _height + offset);
    canvas.drawParagraph(par, off);

    // draw the horizontal labels
    // for (int i = 1; i < _titles.length + 1; i++) {
    //   ps = ui.ParagraphStyle(textAlign: TextAlign.center, fontSize: fontSize);
    //   pb = ui.ParagraphBuilder(ps);
    //   pb.pushStyle(ui.TextStyle(color: Colors.white));
    //   pb.addText(_titles[i - 1]);
    //   pc = ui.ParagraphConstraints(width: 300);
    //   par = pb.build();
    //   par.layout(pc);
    //   double leftOffset =
    //       _left + _width / (_titles.length + 1) * i - par.width / 2;
    //   off = Offset(leftOffset, _top + _height + offset);
    //   canvas.drawParagraph(par, off);
    // }
  }

  _drawAxesMarks(Canvas canvas, Paint paint, double offset) {
    for (int i = 0; i < _strokes; i++) {
      double leftOffset = _left + _width / _strokes * i;
      Offset p1 = Offset(leftOffset, _height - offset);
      Offset p2 = Offset(leftOffset, _height + offset);
      canvas.drawLine(p1, p2, paint);
      double topOffset = _top + _height / _strokes * (i + 1);
      p1 = Offset(_left - offset, topOffset);
      p2 = Offset(_left + offset, topOffset);
      canvas.drawLine(p1, p2, paint);
    }
  }

  _drawBackground(Canvas canvas, Size size, Paint paint) {
    Color prevColor = paint.color;
    PaintingStyle prevStyle = paint.style;
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;
    Rect r = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawRect(r, paint);
    paint.style = prevStyle;
    paint.color = prevColor;
  }

  _drawBarChart(Canvas canvas, Size size, Paint paint) {
    Color prevColor = paint.color;
    paint.color = Colors.white;
    double barWidth = size.width * .1;

    int vehicle;
    switch (_vehicle) {
      case Vehicle.CAR:
        vehicle = 0;
        break;
      case Vehicle.BICYCLE:
        vehicle = 1;
        break;
      case Vehicle.BUS:
        vehicle = 2;
        break;
      case Vehicle.ALL:
        for (int i = 0; i < _points.length; i++) {
          double left =
              _left + _width / (_points.length + 1) * (i + 1) - barWidth / 2;
          double height = (_height * _points[i].dy / _strokes) * _t;
          double top = _top + _height - height;
          Rect r = Rect.fromLTWH(left, top, barWidth, height);
          canvas.drawRect(r, paint);
        }

        return;
    }
    double left =
        _left + _width / (_points.length + 1) * (vehicle + 1) - barWidth / 2;
    double height = (_height * _points[vehicle].dy / _strokes) * _t;
    double top = _top + _height - height;
    Rect r = Rect.fromLTWH(left, top, barWidth, height);
    canvas.drawRect(r, paint);
    paint.color = prevColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _left = size.width * .1;
    _top = size.height * .1;
    _width = size.width * .9;
    _height = size.height * .8;
    Paint paint = Paint();
    // draw the background
    // _drawBackground(canvas, size, paint);

    //draw the axes
    _drawAxes(canvas, paint);
    //draw the marks on the axes
    final double offset = 15;

    //draw the marks on the axes
    // _drawAxesMarks(canvas, paint, offset);

    //draw the numbers on the axes
    _drawNumbers(canvas, paint, offset);

    //draw the guiding lines on the graph
    _drawGuidingLines(canvas, size, paint);

    // draw the bar chart
    _drawBarChart(canvas, size, paint);

    //draw the graph curve
    // _drawCurve(_points, canvas, size, paint);

    //draw the label on the graph
    // _drawLabel(_chartTitle, size, canvas, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}

enum Vehicle { CAR, BICYCLE, BUS, ALL }
