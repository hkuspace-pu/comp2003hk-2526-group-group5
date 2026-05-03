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
  final ItemType type;
  final double x; // Normalized 0.0 - 1.0
  final double y; // Normalized 0.0 - 1.0

  PlacedItem({required this.type, required this.x, required this.y});

  Map<String, dynamic> toJson() => {
    'type': type.index,
    'x': x,
    'y': y,
  };

  factory PlacedItem.fromJson(Map<String, dynamic> json) => PlacedItem(
    type: ItemType.values[json['type'] as int],
    x: (json['x'] as num).toDouble(),
    y: (json['y'] as num).toDouble(),
  );
}