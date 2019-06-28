import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leiterify/database.dart';
import 'package:leiterify/utils/app-state.dart';
import 'package:leiterify/utils/platform.dart';

import '../utils/drawing-elements.dart';
import '../models/models.dart' as models;
import '../utils/card-painter.dart';

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

class CreateCard extends StatefulWidget {
  final int cardNumber;
  final int totalCards;

  CreateCard({this.cardNumber, this.totalCards});
  CreateCardState createState() => CreateCardState();
}

class CreateCardState extends State<CreateCard> {
  final colors = [Colors.black, Colors.white] + Colors.primaries;

  Color _selectedColor = Colors.black;
  Tool _selectedTool = Tool.draw;
  SideState _currentSide = SideState("Front");
  SideState _otherSide = SideState("Back");

  @override
  Widget build(BuildContext context) {
    final data = App.of(context);
    return PlatformScaffold(
      navigationBar: PlatformAppBar(
        title: Text("Add Card(${widget.cardNumber}/${widget.totalCards})"),
        trailing: PlatformFlatButton(
          padding: EdgeInsets.zero,
          child: Text("Create"),
          onPressed: () async {
            await _persistCard(context);
            var cardNumber = data.cardsAddedToday + 1;

            if (cardNumber > widget.totalCards) {
              return Navigator.pushReplacementNamed(
                context,
                '/creation-complete',
              );
            } else {
              Navigator.pushReplacementNamed(
                context,
                '/create-card',
                arguments: {"cardNumber": cardNumber, "replace": true},
              );
            }
          },
        ),
      ),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          physics: _selectedTool == Tool.text
              ? null
              : NeverScrollableScrollPhysics(),
          children: [
            Visibility(
              child: Text(_currentSide.side),
            ),
            AspectRatio(
              aspectRatio: 5.0 / 3.0,
              child: Container(
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
        ),
      ),
    );
  }

  Widget _getTextField() {
    return PlatformTextField(
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
    var file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 300.0,
    );
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

  Future<void> _persistCard(BuildContext context) async {
    var card = models.Card(level: 1);
    var frontSideState =
        _currentSide.side == "Front" ? _currentSide : _otherSide;
    var backSideState = _currentSide.side == "Back" ? _currentSide : _otherSide;
    var frontSide = models.Side(
      text: frontSideState.text,
      textColor: frontSideState.textColor,
      image: frontSideState.image,
      elements: frontSideState.elements,
      backgroundFill: frontSideState.backgroundFill == null
          ? null
          : frontSideState.backgroundFill.color,
    );
    var backSide = models.Side(
      text: backSideState.text,
      textColor: backSideState.textColor,
      image: backSideState.image,
      elements: backSideState.elements,
      backgroundFill: backSideState.backgroundFill == null
          ? null
          : backSideState.backgroundFill.color,
    );

    await DbProvider.db.createCard(card, frontSide, backSide);
    App.of(context).cardsAddedToday += 1;
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
