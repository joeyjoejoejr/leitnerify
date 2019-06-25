part of models;

class Card {
  int id;
  int level;
  int frontSideId;
  int backSideId;
  DateTime promotedAt;
  DateTime createdAt;

  Side frontSide;
  Side backSide;

  Card({
    this.id,
    this.level,
    this.frontSideId,
    this.backSideId,
    this.promotedAt,
    this.createdAt,
  });

  Card.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        level = map['level'],
        frontSideId = map['front_side_id'],
        backSideId = map['back_side_id'],
        promotedAt = map['promoted_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['promoted_at'])
            : null,
        createdAt = DateTime.fromMillisecondsSinceEpoch(map['created_at']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'front_side_id': frontSideId,
      'back_side_id': backSideId,
      'promoted_at':
          promotedAt != null ? promotedAt.millisecondsSinceEpoch : null,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  void promote() {
    level += 1;
    promotedAt = DateTime.now();
  }
}
