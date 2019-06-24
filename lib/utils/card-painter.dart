import 'package:flutter/material.dart';
import 'package:leiterify/utils/drawing-elements.dart';

class CardPainter extends CustomPainter {
  CardPainter(this.elements);

  final List<DrawingElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    canvas.clipRect(rect);
    elements.forEach((el) => el.draw(canvas, size));
  }

  @override
  bool shouldRepaint(CardPainter other) => other.elements != elements;
}
