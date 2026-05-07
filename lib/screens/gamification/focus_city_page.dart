import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/item_info.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/focus_session_provider.dart';
import 'widgets/city_inventory.dart';
import 'widgets/timer_display.dart';

class FocusCityPage extends StatefulWidget {
  const FocusCityPage({super.key});

  @override
  State<FocusCityPage> createState() => _FocusCityPageState();
}

class _FocusCityPageState extends State<FocusCityPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Initialize the lifecycle observer for anti-cheat detection
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final focusData = Provider.of<FocusSessionProvider>(context, listen: false);

    // Anti-cheat: If the app is minimized (paused) while a session is running, trigger failure
    if (state == AppLifecycleState.paused && focusData.isRunning) {
      _handleFocusFailure(focusData);
    }
  }

  void _handleFocusFailure(FocusSessionProvider focusData) {
    focusData.failSession(); // Deducts XP via the internal gamification provider
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Focus Interrupted!',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You left the app during a focus session. Your city progress was damaged and XP has been deducted.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            child: const Text('I will stay focused', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Focus City',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Stats
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Consumer<GamificationProvider>(
                builder: (context, gamification, _) => Text(
                  "TODAY'S CITY (Lv: ${gamification.currentCurrentLevel}, XP: ${gamification.currentTotalXp})",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Build your city by completing focus sessions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),

            // City Canvas Layer
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Consumer2<FocusSessionProvider, GamificationProvider>(
                builder: (context, focusData, gamification, _) {
                  // Completion logic feedback
                  if (focusData.didCompleteNaturally) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      HapticFeedback.vibrate();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Focus Completed! +${focusData.xpAwardOnCompletion} XP!')),
                      );
                      focusData.acknowledgeCompletion();
                    });
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      const double itemSize = 48.0;
                      return Stack(
                        children: [
                          // Grass/DragTarget Layer
                          DragTarget<ItemType>(
                            onAcceptWithDetails: (details) {
                              final RenderBox renderBox = context.findRenderObject() as RenderBox;
                              final localOffset = renderBox.globalToLocal(details.offset);

                              final double nx = (localOffset.dx / constraints.maxWidth).clamp(0.0, 1.0);
                              final double ny = (localOffset.dy / constraints.maxHeight).clamp(0.0, 1.0);
                              gamification.placeItem(details.data, Offset(nx, ny));
                            },
                            builder: (context, _, _) => Container(
                              color: const Color(0xFF63B63B), // Primary Grass Green
                              child: focusData.isRunning
                                  ? TimerDisplay(formattedTime: focusData.formattedTime)
                                  : null,
                            ),
                          ),

                          // Placed Buildings Layer
                          ...gamification.currentPlacedItems.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final placedItem = entry.value;
                            final itemInfo = gamification.getItemInfo(placedItem.type);

                            return Positioned(
                              left: placedItem.x * constraints.maxWidth - itemSize / 2,
                              top: placedItem.y * constraints.maxHeight - itemSize / 2,
                              child: Draggable(
                                feedback: Image.asset(itemInfo.imagePath, width: itemSize * 1.2),
                                childWhenDragging: Opacity(opacity: 0.5, child: Image.asset(itemInfo.imagePath, width: itemSize)),
                                onDragEnd: (details) {
                                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                                  final localOffset = renderBox.globalToLocal(details.offset);
                                  final newX = (localOffset.dx / constraints.maxWidth).clamp(0.0, 1.0);
                                  final newY = (localOffset.dy / constraints.maxHeight).clamp(0.0, 1.0);
                                  gamification.updateItemPosition(index, newX, newY);
                                },
                                child: Image.asset(itemInfo.imagePath, width: itemSize),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Progress Info & Inventory
            Consumer<GamificationProvider>(
              builder: (context, gamification, _) => Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    gamification.nextUnlockProgress,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: CityInventory(),
            ),

            const SizedBox(height: 20),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Consumer<FocusSessionProvider>(
                    builder: (context, focusData, _) => ElevatedButton.icon(
                      onPressed: focusData.startStopSession,
                      icon: Icon(focusData.isRunning ? Icons.stop : Icons.play_arrow),
                      label: Text(focusData.isRunning
                          ? 'END FOCUS SESSION'
                          : 'START ${focusData.remainingDuration.inMinutes}-MIN FOCUS'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Consumer<GamificationProvider>(
                    builder: (context, gamification, _) => OutlinedButton.icon(
                      onPressed: () => _showResetDialog(context, gamification),
                      icon: const Icon(Icons.refresh),
                      label: const Text('RESET CITY LAYOUT'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
// Helper method for the reset confirmation
Future<void> _showResetDialog(BuildContext context, GamificationProvider gamification) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reset All Data?'),
      content: const Text('This will permanently delete your city layout AND all statistics. This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await gamification.reset(); // Calls the updated async reset in provider
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('City and Statistics Reset Successfully')));
            }
          },
          child: const Text('Reset Everything', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}