part of models;

class Card {
  int id;
  int level;
  int frontSideId;
  int backSideId;
  DateTime createdAt;

  Side frontSide;
  Side backSide;

  Card({
    this.id,
    this.level,
    this.frontSideId,
    this.backSideId,
    this.createdAt,
  });

  Card.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        level = map['level'],
        frontSideId = map['front_side_id'],
        backSideId = map['back_side_id'],
        createdAt = DateTime.fromMillisecondsSinceEpoch(map['created_at']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'front_side_id': frontSideId,
      'back_side_id': backSideId,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }
}
