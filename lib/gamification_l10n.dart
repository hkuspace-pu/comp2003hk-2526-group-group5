import 'package:groupproject_group5/Gamification.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

String localizedItemLabel(ItemType type, AppLocalizations l10n) {
  switch (type) {
    case ItemType.tree:
      return l10n.itemTree;
    case ItemType.park:
      return l10n.itemPark;
    case ItemType.house:
      return l10n.itemHouse;
    case ItemType.building:
      return l10n.itemBuilding;
    case ItemType.road:
      return l10n.itemRoad;
    case ItemType.river:
      return l10n.itemRiver;
    case ItemType.bridge:
      return l10n.itemBridge;
  }
}

String localizedItemDescription(ItemType type, AppLocalizations l10n) {
  switch (type) {
    case ItemType.tree:
      return l10n.itemDescTree;
    case ItemType.park:
      return l10n.itemDescPark;
    case ItemType.house:
      return l10n.itemDescHouse;
    case ItemType.building:
      return l10n.itemDescBuilding;
    case ItemType.road:
      return l10n.itemDescRoad;
    case ItemType.river:
      return l10n.itemDescRiver;
    case ItemType.bridge:
      return l10n.itemDescBridge;
  }
}

/// Localized equivalent of the former [GamificationData.nextUnlockProgress] getter.
String localizedNextUnlockProgress(GamificationData g, AppLocalizations l10n) {
  ItemInfo? nextItemToUnlock;
  final List<ItemInfo> sortedItems = List<ItemInfo>.from(GamificationData.allItems)
    ..sort((ItemInfo a, ItemInfo b) => a.unlockXp.compareTo(b.unlockXp));

  for (final ItemInfo item in sortedItems) {
    if (!g.currentUnlockedItemTypes.contains(item.type)) {
      nextItemToUnlock = item;
      break;
    }
  }

  final int nextLevel = g.currentCurrentLevel + 1;
  final int? nextLevelXpThreshold = GamificationData.levelXpThresholds[nextLevel];

  if (nextItemToUnlock != null && nextLevelXpThreshold != null) {
    if (nextItemToUnlock.unlockXp <= nextLevelXpThreshold) {
      return l10n.unlockNextAtItem(
        nextItemToUnlock.unlockXp,
        localizedItemLabel(nextItemToUnlock.type, l10n),
        localizedItemDescription(nextItemToUnlock.type, l10n),
      );
    } else {
      return l10n.unlockNextAtLevel(nextLevelXpThreshold, nextLevel);
    }
  } else if (nextItemToUnlock != null) {
    return l10n.unlockNextAtItem(
      nextItemToUnlock.unlockXp,
      localizedItemLabel(nextItemToUnlock.type, l10n),
      localizedItemDescription(nextItemToUnlock.type, l10n),
    );
  } else if (nextLevelXpThreshold != null) {
    return l10n.unlockNextAtLevel(nextLevelXpThreshold, nextLevel);
  }
  return l10n.unlockAllDone;
}
