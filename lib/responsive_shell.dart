import 'package:flutter/material.dart';

/// Shared responsive layout for [MainShellScreen] tab bodies: content grows with
/// viewport width (up to a cap) so wide Chrome windows are not mostly empty margin.
abstract final class ResponsiveShell {
  ResponsiveShell._();

  /// Upper bound for readable line length on ultrawide; content still tracks window up to here.
  static const double kMaxContentWidth = 1400;

  /// Fraction of viewport used for the content column (rest becomes side margin).
  static const double kWidthFraction = 0.96;

  static double contentMaxWidth(double viewportWidth) {
    if (viewportWidth <= 0) return kMaxContentWidth;
    return (viewportWidth * kWidthFraction).clamp(320.0, kMaxContentWidth);
  }
}

/// Centers [child] and constrains its max width based on available width.
class ResponsiveShellBody extends StatelessWidget {
  const ResponsiveShellBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxW = ResponsiveShell.contentMaxWidth(constraints.maxWidth);
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: child,
          ),
        );
      },
    );
  }
}
