enum ItemType { tree, park, house, building, road, river, bridge }

class ItemInfo {
  final ItemType type;
  final String label;
  final String imagePath;
  final int unlockXp;
  final int levelUnlock;
  final String description;

  const ItemInfo({
    required this.type,
    required this.label,
    required this.imagePath,
    required this.unlockXp,
    required this.levelUnlock,
    required this.description,
  });
}

class PlacedItem {
  ItemType type;
  double x;
  double y;

  PlacedItem({required this.type, required this.x, required this.y});

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'x': x,
        'y': y,
      };

  factory PlacedItem.fromJson(Map<String, dynamic> json) => PlacedItem(
        type: ItemType.values[json['type']],
        x: json['x'].toDouble(),
        y: json['y'].toDouble(),
      );
}
