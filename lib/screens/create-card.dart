import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_picker/image_picker.dart';

class CreateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Add Card(1/5)"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text("Create"),
          onPressed: () {},
        ),
      ),
      child: CreatePage(),
    );
  }
}

enum Tool {
  text,
  draw,
  fill,
  image,
  flip,
}

class Tools {
  static IconData getIconData(Tool tool) {
    IconData iconForTool;
    switch (tool) {
      case Tool.text:
        iconForTool = Icons.text_fields;
        break;
      case Tool.draw:
        iconForTool = Icons.edit;
        break;
      case Tool.fill:
        iconForTool = Icons.format_paint;
        break;
      case Tool.image:
        iconForTool = Icons.image;
        break;
      case Tool.flip:
        iconForTool = Icons.replay;
        break;
    }

    return iconForTool;
  }
}

class SideState {
  String text = "";
  Color textColor = Colors.black;
  TextEditingController textController = TextEditingController(text: "");
  ui.Image image;
  List<DrawingElement> elements = [];
  Fill backgroundFill;

  String side;
  SideState(this.side);
}

class CreatePage extends StatefulWidget {
  CreatePageState createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  final colors = [Colors.black, Colors.white] + Colors.primaries;

  Color _selectedColor = Colors.black;
  Tool _selectedTool = Tool.draw;
  SideState _currentSide = SideState("Front");
  SideState _otherSide = SideState("Back");

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 100.0),
      children: [
        Text(_currentSide.side),
        Container(
          height: 300.0,
          color: Colors.white,
          child: CardCreator(
            color: _selectedColor,
            tool: _selectedTool,
            text: _currentSide.text,
            textColor: _currentSide.textColor,
            image: _currentSide.image,
            elements: _currentSide.elements,
            fill: _currentSide.backgroundFill,
            onElementUpdate: (elements) =>
                setState(() => _currentSide.elements = elements),
            onFillUpdate: (fill) =>
                setState(() => _currentSide.backgroundFill = fill),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: _getToolBar(),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: _getColorBar(),
        ),
      ]
          .followedBy(_selectedTool == Tool.text
              ? [
                  Container(color: Colors.white, child: _getTextField()),
                ]
              : [])
          .toList(),
    );
  }

  Widget _getTextField() {
    return CupertinoTextField(
      autofocus: true,
      placeholder: "Text to appear on card",
      controller: _currentSide.textController,
      onChanged: (text) => setState(() => _currentSide.text = text),
    );
  }

  Widget _getToolBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: Tool.values.map(_getToolBarItem).toList(),
    );
  }

  void _getImage() async {
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    var fileData = await file.readAsBytes();
    var codec = await ui.instantiateImageCodec(fileData);
    var info = await codec.getNextFrame();
    setState(() {
      _currentSide.image = info.image;
    });
  }

  Widget _getToolBarItem(Tool tool) {
    final borderColor = _selectedTool == tool ? Colors.blue : Colors.white;
    return GestureDetector(
      onTap: () {
        if (tool == Tool.image) {
          _getImage();
        } else if (tool == Tool.flip) {
          var newSide = _otherSide;
          setState(() {
            _otherSide = _currentSide;
            _currentSide = newSide;
          });
        } else {
          setState(() {
            _selectedTool = tool;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 5.0),
          color: Colors.white,
        ),
        child: Icon(
          Tools.getIconData(tool),
          color: Colors.black,
          size: 32.0,
        ),
      ),
    );
  }

  Widget _getColorBar() {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      children: colors.map(_getColorBarItem).toList(),
    );
  }

  Widget _getColorBarItem(Color color) {
    final borderColor = _selectedColor == color ? Colors.blue : Colors.white;
    return GestureDetector(
      onTap: () => setState(() {
            if (_selectedTool == Tool.text) {
              _currentSide.textColor = color;
            }
            _selectedColor = color;
          }),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 5.0),
          color: color,
        ),
        height: 37.0,
        width: 37.0,
      ),
    );
  }
}

abstract class DrawingElement {
  void draw(Canvas canvas, Size size);
}

class Line extends DrawingElement {
  List<Offset> _points = [];
  final Color color;

  Line(this.color);

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

  @override
  void draw(Canvas canvas, Size _) {
    Paint paint = Paint()..color = this.color;

    canvas.drawPaint(paint);
  }
}

class BackgroundImage extends DrawingElement {
  ui.Image image;
  BackgroundImage(this.image);

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
}

typedef ElementCallback = void Function(List<DrawingElement> elements);
typedef FillCallback = void Function(Fill fill);

class CardCreator extends StatefulWidget {
  final Color color;
  final Tool tool;
  final String text;
  final Color textColor;
  final ui.Image image;
  final List<DrawingElement> elements;
  final Fill fill;

  final ElementCallback onElementUpdate;
  final FillCallback onFillUpdate;

  CardCreator({
    this.color,
    this.tool,
    this.text,
    this.textColor,
    this.image,
    this.elements,
    this.onElementUpdate,
    this.fill,
    this.onFillUpdate,
  });

  CardCreatorState createState() => CardCreatorState();
}

class CardCreatorState extends State<CardCreator> {
  List<Offset> _points = [];
  BackgroundImage _backgroundImage;

  @override
  Widget build(BuildContext context) {
    List<DrawingElement> _paintElements = List.from(widget.elements);
    if (widget.image != null) {
      _backgroundImage = BackgroundImage(widget.image);
      _paintElements.insert(0, _backgroundImage);
    }
    if (widget.fill != null) _paintElements.insert(0, widget.fill);
    List<DrawingElement> elements = List.from(widget.elements);

    return Stack(
      children: [
        CustomPaint(
          painter: CardPainter(_paintElements),
          size: Size.infinite,
        ),
        GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            if (widget.tool != Tool.draw) return;

            RenderBox referenceBox = context.findRenderObject();
            final localPosition =
                referenceBox.globalToLocal(details.globalPosition);

            final el = elements.last;
            if (referenceBox.size.contains(localPosition)) {
              if (el is Line) {
                el.addPoint(localPosition);
                widget.onElementUpdate(elements);
              }
            } else if (el is Line && !el.isEmpty) {
              elements.add(Line(widget.color));
              widget.onElementUpdate(elements);
            }
          },
          onPanStart: (DragStartDetails details) {
            if (widget.tool != Tool.draw) return;

            RenderBox referenceBox = context.findRenderObject();
            final localPosition =
                referenceBox.globalToLocal(details.globalPosition);

            elements.add(Line(widget.color)..addPoint(localPosition));
            widget.onElementUpdate(elements);
          },
          onTapUp: (TapUpDetails details) {
            if (widget.tool == Tool.fill) _handleFillTap(details);
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: AutoSizeText(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(color: widget.textColor, fontSize: 32.0),
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  void _handleFillTap(TapUpDetails details) {
    RenderBox referenceBox = context.findRenderObject();
    final localPosition = referenceBox.globalToLocal(details.globalPosition);

    if (referenceBox.size.contains(localPosition)) {
      widget.onFillUpdate(Fill(widget.color));
    }
  }
}

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
