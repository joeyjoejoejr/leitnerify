import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

abstract class DrawingElement {
  void draw(Canvas canvas, Size size);
  Map<String, dynamic> toJson();
  DrawingElement();
  factory DrawingElement.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'Line':
        return Line.fromJson(json);
      case 'Fill':
        return Fill.fromJson(json);
      case 'BackgroundImage':
        return BackgroundImage.fromJson(json);
      default:
        return null;
    }
  }
}

class Line extends DrawingElement {
  List<Offset> _points = [];
  final Color color;

  Line(this.color);
  Line.fromJson(Map<String, dynamic> json)
      : _points = (json['points'] as List<List<double>>)
            .map((list) => Offset(list[0], list[1]))
            .toList(),
        color = Color(json['color']);

  @override
  void draw(Canvas canvas, Size _) {
    Paint paint = Paint()
      ..color = this.color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < _points.length - 1; i++) {
      canvas.drawLine(_points[i], _points[i + 1], paint);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'points': _points.map((point) => [point.dx, point.dy]).toList(),
      'color': color.value,
      'type': 'Line',
    };
  }

  void addPoint(Offset point) {
    _points.add(point);
  }

  bool get isEmpty {
    return _points.isEmpty;
  }
}

class Fill extends DrawingElement {
  final Color color;

  Fill(this.color);
  Fill.fromJson(Map<String, dynamic> json) : color = Color(json['color']);

  @override
  void draw(Canvas canvas, Size _) {
    Paint paint = Paint()..color = this.color;

    canvas.drawPaint(paint);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'color': color.value,
      'type': 'Fill',
    };
  }
}

class BackgroundImage extends DrawingElement {
  ui.Image image;
  BackgroundImage(this.image);
  BackgroundImage.fromJson(Map<String, dynamic> json);

  void draw(Canvas canvas, Size size) async {
    if (image != null) {
      var imgSize = Size(image.width.toDouble(), image.height.toDouble());
      var imageRect = Offset.zero & imgSize;
      var scale = size.height / imgSize.height;
      var destWidth = image.width * scale;
      var offsetX = (size.width - destWidth) / 2;
      var destRect =
          Offset(offsetX, 0.0) & Size(destWidth, image.height * scale);
      canvas.drawImageRect(image, imageRect, destRect, Paint());
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'BackGroundImage',
    };
  }
}
