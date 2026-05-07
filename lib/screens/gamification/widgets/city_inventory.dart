import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/item_info.dart';
import '../../../providers/gamification_provider.dart';

class CityInventory extends StatelessWidget {
  const CityInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GamificationProvider>(
      builder: (context, gamificationData, _) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: gamificationData.currentAllItems.map((itemInfo) {
              final bool isUnlocked = gamificationData.currentUnlockedItemTypes
                  .contains(itemInfo.type);
              return SizedBox(
                width: 70,
                child: DraggableUnlockableItem(
                  itemInfo: itemInfo,
                  isUnlocked: isUnlocked,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class DraggableUnlockableItem extends StatelessWidget {
  final ItemInfo itemInfo;
  final bool isUnlocked;

  const DraggableUnlockableItem({
    required this.itemInfo,
    required this.isUnlocked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 48;

    // Original Logic: Show locked state if XP is insufficient
    if (!isUnlocked) {
      return Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(itemInfo.imagePath, width: size, height: size, fit: BoxFit.cover),
            const SizedBox(height: 4),
            Text(itemInfo.label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('${itemInfo.unlockXp} XP', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
      );
    }

    // Original Logic: Draggable item for building
    return Draggable<ItemType>(
      data: itemInfo.type,
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(itemInfo.imagePath, width: size + 16, height: size + 16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(itemInfo.imagePath, width: size, height: size, fit: BoxFit.cover),
          const SizedBox(height: 4),
          Text(itemInfo.label, style: const TextStyle(fontSize: 12, color: Colors.black)),
          const Text('Place', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}