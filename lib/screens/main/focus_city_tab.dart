import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../Gamification.dart';
import 'focus_session_panel.dart';

/// Focus tab body — uses the same [AppBar] as other shell tabs (see [MainShellScreen]).
class FocusCityTab extends StatelessWidget {
  const FocusCityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kMainShellBackground,
      child: FocusCityBody(
        compact: true,
        progressTitle: "TODAY'S CITY PROGRESS",
        progressSubtitle: 'Build your city with each focus session',
        showBottomStartStopButton: false,
        sessionToolbar: FocusSessionPanel(compact: true),
      ),
    );
  }
}
