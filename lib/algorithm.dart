import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'globals.dart';
import 'dart:math' as math;

void bresenhamLine(Canvas canvas, Paint paint, Offset start, Offset end) {
  int x0 = start.dx.round();
  int y0 = start.dy.round();
  int x1 = end.dx.round();
  int y1 = end.dy.round();

  final dx = (x1 - x0).abs();
  final dy = (y1 - y0).abs();
  final sx = x0 < x1 ? pixelsize : -pixelsize;
  final sy = y0 < y1 ? pixelsize : -pixelsize;
  var err = dx - dy;
  int limit = 1024;
  while (limit > 0) {
    limit--;
    canvas.drawPoints(
        ui.PointMode.points, [Offset(x0.toDouble(), y0.toDouble())], paint);
    if (x0 == x1 && y0 == y1) break;
    var e2 = 2 * err;
    if (e2 > -dy) {
      err -= dy;
      x0 += sx;
    }
    if (e2 < dx) {
      err += dx;
      y0 += sy;
    }
  }
}

void bresenhamCircle(Canvas canvas, Paint paint, Offset center, Offset point) {
  final radius = math.sqrt(
      math.pow(point.dx - center.dx, 2) + math.pow(point.dy - center.dy, 2));
  int x = 0;
  int y = (radius / pixelsize).round() * pixelsize;
  int d = 3 * pixelsize - 2 * radius.round();
  while (x <= y) {
    canvas.drawPoints(
        ui.PointMode.points,
        [
          Offset(center.dx + x.toDouble(), center.dy + y.toDouble()),
          Offset(center.dx + x.toDouble(), center.dy - y.toDouble()),
          Offset(center.dx - x.toDouble(), center.dy + y.toDouble()),
          Offset(center.dx - x.toDouble(), center.dy - y.toDouble()),
          Offset(center.dx + y.toDouble(), center.dy + x.toDouble()),
          Offset(center.dx + y.toDouble(), center.dy - x.toDouble()),
          Offset(center.dx - y.toDouble(), center.dy + x.toDouble()),
          Offset(center.dx - y.toDouble(), center.dy - x.toDouble()),
        ],
        paint);
    x = x + pixelsize;
    if (d < 0) {
      d = d + 4 * x + 6 * pixelsize;
    } else {
      y = y - pixelsize;
      d = d + 4 * (x - y) + 10 * pixelsize;
    }
  }
}

void bresenhamEllipse(
    Canvas canvas, Paint paint, Offset ponit1, Offset ponit2) {
  //计算圆心和横竖轴
  final Offset center = Offset(((ponit1.dx + ponit2.dx) ~/ 2).toDouble(),
      ((ponit1.dy + ponit2.dy) ~/ 2).toDouble()); // 圆心
  int rx = (ponit1.dx - ponit2.dx).abs() ~/ (2 * pixelsize); // 横半轴
  int ry = (ponit1.dy - ponit2.dy).abs() ~/ (2 * pixelsize); // 竖半轴

  int x = 0, y = ry;
  int d1 = 4 * (ry * ry) - 4 * (rx * rx * ry) + (rx * rx);
  int dx = 2 * ry * ry * x; //为零
  int dy = 2 * rx * rx * y;
  int ym = y;
  int xm = x;
  y = y * pixelsize;

  // Region 1
  while (dx < dy) {
    drawSymmetricPoints(canvas, center, x.toInt(), y.toInt(), paint);
    if (d1 < 0) {
      x = x + pixelsize;
      dx = dx + (2 * ry * ry);
      d1 = d1 + 4 * dx + 4 * (ry * ry);
    } else {
      x = x + pixelsize;
      y = y - pixelsize;
      dx = dx + (2 * ry * ry);
      dy = dy - (2 * rx * rx);
      d1 = d1 + 4 * dx - 4 * dy + 4 * (ry * ry);
    }
  }

  // Region 2

  int d2 = ((ry * ry) * ((2 * xm + 1) * (2 * xm + 1))) +
      2 * ((rx * rx) * ((ym - 1) * (ym - 1))) -
      2 * (rx * rx * ry * ry);

  while (y >= 0) {
    drawSymmetricPoints(canvas, center, x.toInt(), y.toInt(), paint);
    if (d2 > 0) {
      y = y - pixelsize;
      dy = dy - (2 * rx * rx);
      d2 = d2 + 2 * (rx * rx) - 2 * dy;
    } else {
      y = y - pixelsize;
      x = x + pixelsize;
      dx = dx + (2 * ry * ry);
      dy = dy - (2 * rx * rx);
      d2 = d2 + 2 * dx - 2 * dy + 2 * (rx * rx);
    }
  }
}

void drawSymmetricPoints(
    Canvas canvas, Offset center, int x, int y, Paint paint) {
  List<Offset> points = [
    Offset(center.dx + x, center.dy + y),
    Offset(center.dx - x, center.dy + y),
    Offset(center.dx + x, center.dy - y),
    Offset(center.dx - x, center.dy - y),
  ];
  canvas.drawPoints(ui.PointMode.points, points, paint);
}
