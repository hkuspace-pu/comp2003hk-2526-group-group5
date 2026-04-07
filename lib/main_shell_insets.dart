import 'package:flutter/material.dart';

/// Outer padding for main-shell tab scroll views ([MainShellScreen] bodies).
/// Kept tight on left/right so content sits close to the screen edge (small safe inset).
/// ~½ previous step — edge‑to‑edge feel on all five main-shell tabs.
const EdgeInsets kMainTabScrollPadding = EdgeInsets.fromLTRB(12, 8, 12, 12);

double get kMainTabInsetHorizontal => kMainTabScrollPadding.left;
double get kMainTabInsetBottom => kMainTabScrollPadding.bottom;
