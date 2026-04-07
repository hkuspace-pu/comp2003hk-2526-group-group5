import 'package:flutter/material.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../locale_controller.dart';

class _LangOption {
  const _LangOption(this.code, this.label);
  final String code;
  final String Function(AppLocalizations l10n) label;
}

/// Opens a bottom sheet to pick one of the supported UI languages.
Future<void> showAppLanguagePicker(BuildContext context) async {
  final AppLocalizations l10n = AppLocalizations.of(context)!;
  final LocaleController ctrl = context.read<LocaleController>();

  final List<_LangOption> options = <_LangOption>[
    _LangOption('en', (AppLocalizations l) => l.languageEnglish),
    _LangOption('zh_HK', (AppLocalizations l) => l.languageCantonese),
  ];

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (BuildContext ctx) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  l10n.languagePickerTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              for (final _LangOption o in options)
                RadioListTile<String>(
                  value: o.code,
                  groupValue: ctrl.currentCode,
                  title: Text(o.label(l10n)),
                  onChanged: (String? v) async {
                    if (v == null) {
                      return;
                    }
                    await ctrl.setLocaleFromCode(v);
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                    }
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}

/// Top-left language control for welcome screens.
class AppLanguageIconButton extends StatelessWidget {
  const AppLanguageIconButton({super.key, this.iconColor});

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations? l10n = AppLocalizations.of(context);
    return IconButton(
      icon: const Icon(Icons.language_rounded),
      tooltip: l10n?.settingsLanguage ?? 'Language',
      color: iconColor,
      onPressed: () => showAppLanguagePicker(context),
    );
  }
}
