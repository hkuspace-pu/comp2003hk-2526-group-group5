import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:groupproject_group5/models/city_item.dart';
import 'package:groupproject_group5/state/city_gamification_state.dart';

class FocusCityPage extends StatelessWidget {
  const FocusCityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF46AA57),
        elevation: 0,
        centerTitle: true,
        title: const Text('Focus City', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Consumer<GamificationData>(
              builder: (context, gamificationData, _) => Text(
                "TODAY'S CITY (Lv: ${gamificationData.currentCurrentLevel}, XP: ${gamificationData.currentTotalXp})",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Build your city with focus sessions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: Consumer2<FocusSessionData, GamificationData>(
              builder: (context, focusData, gamificationData, _) {
                if (focusData.currentDidCompleteNaturally) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    HapticFeedback.vibrate();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Completed! +${focusData.currentXpAwardOnCompletion} XP!'),
                    ));
                    gamificationData.addXp(focusData.currentXpAwardOnCompletion);
                    focusData.acknowledgeCompletion();
                  });
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    const double itemSize = 48.0;
                    final bool hideTimer = !focusData.currentIsRunning;

                    return Stack(
                      children: [
                        DragTarget<ItemType>(
                          onAcceptWithDetails: (details) {
                            final RenderBox renderBox = context.findRenderObject() as RenderBox;
                            final Offset localOffset = renderBox.globalToLocal(details.offset);
                            final double normalizedX = (localOffset.dx / constraints.maxWidth).clamp(0.0, 1.0);
                            final double normalizedY = (localOffset.dy / constraints.maxHeight).clamp(0.0, 1.0);
                            gamificationData.placeItem(details.data, Offset(normalizedX, normalizedY));
                          },
                          builder: (context, _, __) => Container(
                            color: const Color(0xFF63B63B),
                            child: hideTimer ? null : Center(
                              child: Text(
                                focusData.formattedTime,
                                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                        ...gamificationData.currentPlacedItems.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final PlacedItem placedItem = entry.value;
                          final itemInfo = gamificationData.getItemInfo(placedItem.type);

                          return Positioned(
                            left: placedItem.x * constraints.maxWidth - itemSize / 2,
                            top: placedItem.y * constraints.maxHeight - itemSize / 2,
                            child: Draggable<PlacedItem>(
                              data: placedItem,
                              feedback: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  itemInfo.imagePath,
                                  width: itemSize * 1.2,
                                  height: itemSize * 1.2,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(width: itemSize * 1.2, height: itemInfo.imagePath.contains('tree') ? itemSize * 1.2 : itemSize * 1.2, color: Colors.grey),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.5,
                                child: Image.asset(
                                  itemInfo.imagePath,
                                  width: itemSize,
                                  height: itemSize,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(width: itemSize, height: itemSize, color: Colors.grey),
                                ),
                              ),
                              child: Image.asset(
                                itemInfo.imagePath,
                                width: itemSize,
                                height: itemSize,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(width: itemSize, height: itemSize, color: Colors.grey),
                              ),
                              onDragEnd: (details) {
                                if (details.offset != null) {
                                  final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
                                  if (renderBox != null) {
                                    final localOffset = renderBox.globalToLocal(details.offset!);
                                    final newX = (localOffset.dx / constraints.maxWidth).clamp(0.0, 1.0);
                                    final newY = (localOffset.dy / constraints.maxHeight).clamp(0.0, 1.0);
                                    gamificationData.updateItemPosition(index, newX, newY);
                                  }
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          Consumer<GamificationData>(
            builder: (context, gamificationData, _) => Padding(
              padding: const EdgeInsets.all(8),
              child: Text(gamificationData.nextUnlockProgress,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Consumer<GamificationData>(
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
                      final bool isUnlocked = gamificationData.currentUnlockedItemTypes.contains(itemInfo.type);
                      return SizedBox(
                        width: 70,
                        child: DraggableUnlockableItem(itemInfo: itemInfo, isUnlocked: isUnlocked),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Consumer<FocusSessionData>(
                builder: (context, focusData, _) => ElevatedButton.icon(
                  onPressed: focusData.startStopSession,
                  icon: Icon(focusData.currentIsRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(focusData.currentIsRunning
                      ? 'END FOCUS SESSION'
                      : 'START ${focusData.currentInitialDuration.inMinutes}-MIN FOCUS SESSION'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF46AA57),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Consumer<GamificationData>(
                builder: (context, gamificationData, _) => ElevatedButton.icon(
                  onPressed: () => gamificationData.reset(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('RESET GAMIFICATION'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF46AA57),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 64,
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomIcon(icon: Icons.home),
                _BottomIcon(icon: Icons.event),
                _BottomIcon(icon: Icons.area_chart),
                _BottomIcon(icon: Icons.settings),
              ],
            ),
          ),
        ],
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

    if (!isUnlocked) {
      return Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              itemInfo.imagePath,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 4),
            Text(itemInfo.label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('${itemInfo.unlockXp} XP',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
      );
    }

    return Draggable<ItemType>(
      data: itemInfo.type,
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(
          itemInfo.imagePath,
          width: size + 16,
          height: size + 16,
          errorBuilder: (context, error, stackTrace) => Container(
            width: size + 16,
            height: size + 16,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image, color: Colors.white, size: 24),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ FIX 3: Add this too
        children: [
          Image.asset(
            itemInfo.imagePath,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image, color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(itemInfo.label,
              style: const TextStyle(fontSize: 12, color: Colors.black)),
          const Text('Place',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
class _BottomIcon extends StatelessWidget {
  final IconData icon;
  const _BottomIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(icon, color: Colors.black87));
  }
}