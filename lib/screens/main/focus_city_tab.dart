import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import '../../app_colors.dart';
import '../../Gamification.dart';
import 'focus_session_panel.dart';

/// Focus tab body — uses the same [AppBar] as other shell tabs (see [MainShellScreen]).
class FocusCityTab extends StatelessWidget {
  const FocusCityTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return ColoredBox(
      color: kMainShellBackground,
      child: FocusCityBody(
        compact: true,
        progressTitle: l10n.focusCityProgressTitle,
        progressSubtitle: l10n.focusCityProgressSubtitle,
        showBottomStartStopButton: false,
        sessionToolbar: FocusSessionPanel(compact: true),
      ),
    );
  }
}
