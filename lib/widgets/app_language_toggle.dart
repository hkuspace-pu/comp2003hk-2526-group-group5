import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:groupproject_group5/l10n/locale_controller.dart';

class AppLanguageToggle extends StatelessWidget {
  const AppLanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final LocaleController tr = context.watch<LocaleController>();
    return IconButton(
      tooltip: tr.isEnglish ? 'Switch to 繁體中文' : 'Switch to English',
      icon: Icon(tr.isEnglish ? Icons.translate : Icons.translate_outlined),
      onPressed: () {
        tr.setLanguage(
          tr.isEnglish ? AppLanguage.cantonese : AppLanguage.english,
        );
      },
    );
  }
}
