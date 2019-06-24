part of models;

class Side {
  int id;
  String text;
  Color textColor;
  ui.Image image;
  List<DrawingElement> elements;
  Color backgroundFill;

  Future _imageLoaded;

  Side({
    this.text,
    this.textColor,
    this.image,
    this.elements,
    this.backgroundFill,
  });
  Side.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    text = map['text'];
    if (map['text_color'] != null) {
      textColor = Color(map['text_color']);
    }
    if (map['background_fill'] != null) {
      backgroundFill = Color(map['background_fill']);
    }
    List<dynamic> json = jsonDecode(map['elements']);
    elements = json.map((element) => DrawingElement.fromJson(element)).toList();

    if (map['image'] != null) {
      _imageLoaded = _loadImage(map['image']);
    } else {
      _imageLoaded = Future.value(null);
    }
  }

  Future _loadImage(Uint8List data) async {
    var codec = await ui.instantiateImageCodec(data);
    var info = await codec.getNextFrame();
    image = info.image;
  }

  Future get imageLoaded => _imageLoaded;

  Future<Map<String, dynamic>> toMap() async {
    Uint8List bytes;

    if (image != null) {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final buffer = data.buffer;
      bytes = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await _loadImage(bytes);
    }

    return {
      'id': id,
      'text': text,
      'text_color': textColor.value,
      'image': bytes,
      'elements': jsonEncode(elements),
      'background_fill': backgroundFill == null ? null : backgroundFill.value,
    };
  }
}
