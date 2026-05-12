/// Matched sizes for [FocusCityBody] + [FocusSessionPanel] on the main-shell Focus tab.
abstract final class FocusCityLayout {
  FocusCityLayout._();

  static const double wideBreakpoint = 720;

  /// On viewports wider than [wideBreakpoint], avoid a skinny column: use almost
  /// full width with a modest cap so lines do not get absurdly long on ultrawide.
  /// Align with [ResponsiveShell.kMaxContentWidth] so Focus scales with shell on wide web.
  static const double wideContentMaxCap = 1400;
  /// Total horizontal margin vs viewport on wide screens (tighter = closer to left/right edge).
  static const double wideContentHorizontalBleed = 8;

  static double contentMaxWidth(double shellWidth) {
    if (shellWidth <= wideBreakpoint) return shellWidth;
    final double expanded = shellWidth - wideContentHorizontalBleed;
    return expanded < wideContentMaxCap ? expanded : wideContentMaxCap;
  }

  static const int flexToolbarCompact = 40;
  static const int flexGreenCompact = 60;
  static const int flexToolbarFull = 44;
  static const int flexGreenFull = 56;

  /// Horizontal gutter for [compact] main-shell Focus tab — near screen edge, small inset.
  static double gutter(bool compact) => compact ? 4 : 20;

  /// Bottom gap above system keyboard / nav when [compact].
  static double scrollBottomPadding(bool compact, double keyboardInset) =>
      keyboardInset + (compact ? 8 : 8);

  /// Shared corner radius for cards + green canvas + strips.
  static double radius(bool compact) => compact ? 12 : 14;

  static double cardPaddingH(bool compact) => compact ? 8 : 14;
  static double cardPaddingV(bool compact) => compact ? 10 : 12;

  /// Focus session card inner padding (matches [cardPaddingH/V] rhythm).
  static double sessionCardPadding(bool compact) => compact ? 10 : 16;

  /// Place-items palette tile (compact shell).
  static const double placeTileCompact = 30;
  static const double placeTileFull = 32;

  static double placeColExtra(bool compact) => compact ? 12 : 18;

  /// Icon chip behind progress / session header icons (matches between cards).
  static double iconBoxRadius(bool compact) => compact ? 8 : 12;

  static double iconPadding(bool compact) => compact ? 6 : 10;
}
