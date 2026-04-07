import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../focus_city_layout.dart';
import '../../Gamification.dart';

const Color _kGreen = Color(0xFF46AA57);

/// Focus session: title, **Start / Pause·Resume / Finish**; length via edit on title row.
class FocusSessionPanel extends StatefulWidget {
  const FocusSessionPanel({super.key, this.compact = false});

  final bool compact;

  @override
  State<FocusSessionPanel> createState() => _FocusSessionPanelState();
}

class _FocusSessionPanelState extends State<FocusSessionPanel> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final FocusSessionData fd = context.watch<FocusSessionData>();
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool c = widget.compact;
    final double pad = FocusCityLayout.sessionCardPadding(c);
    final double afterTitle = c ? 12 : 14;
    final double btnV = c ? 10 : 12;

    final bool running = fd.currentIsRunning;
    final bool canResume = fd.canResumeSession;
    final bool idleReady = !running && !canResume;
    final bool canFinish = running || canResume;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FocusCityLayout.radius(c)),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(pad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: _kGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      FocusCityLayout.iconBoxRadius(c),
                    ),
                  ),
                  padding: EdgeInsets.all(FocusCityLayout.iconPadding(c)),
                  child: Icon(
                    Icons.timer_outlined,
                    size: c ? 16 : 20,
                    color: _kGreen.withValues(alpha: 0.95),
                  ),
                ),
                SizedBox(width: c ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        l10n.focusSessionTitle,
                        style: (c ? textTheme.labelLarge : textTheme.titleSmall)
                            ?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          l10n.focusMinutesValue(fd.targetMinutes),
                          style: TextStyle(
                            fontSize: c ? 11 : 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!running)
                  IconButton(
                    tooltip: l10n.editLengthTooltip,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      _showEditTimerDialog(context, fd.targetMinutes);
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      size: c ? 20 : 22,
                      color: _kGreen,
                    ),
                  ),
              ],
            ),
            SizedBox(height: afterTitle),
            // Start | Pause or Resume | Finish — stack vertically on narrow widths.
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool narrow = constraints.maxWidth < 360;
                final double gap = c ? 8 : 8;

                final Widget startBtn = FilledButton.icon(
                  onPressed: idleReady
                      ? () {
                          HapticFeedback.mediumImpact();
                          context.read<FocusSessionData>().startFromFull();
                        }
                      : null,
                  icon: Icon(Icons.play_arrow_rounded, size: c ? 19 : 20),
                  label: Text(l10n.startLabel, style: TextStyle(fontSize: c ? 13 : 14)),
                  style: FilledButton.styleFrom(
                    backgroundColor: _kGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: btnV),
                    minimumSize: Size(0, c ? 42 : 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        FocusCityLayout.radius(c),
                      ),
                    ),
                  ),
                );

                final Widget pauseBtn = OutlinedButton.icon(
                  onPressed: running
                      ? () {
                          HapticFeedback.lightImpact();
                          context.read<FocusSessionData>().pauseSession();
                        }
                      : (canResume
                          ? () {
                              HapticFeedback.mediumImpact();
                              context.read<FocusSessionData>().resumeSession();
                            }
                          : null),
                  icon: Icon(
                    running
                        ? Icons.pause_rounded
                        : (canResume
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded),
                    size: c ? 18 : 20,
                  ),
                  label: Text(
                    running
                        ? l10n.pauseLabel
                        : (canResume ? l10n.resumeLabel : l10n.pauseLabel),
                    style: TextStyle(fontSize: c ? 13 : 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade400),
                    padding: EdgeInsets.symmetric(vertical: btnV),
                    minimumSize: Size(0, c ? 42 : 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        FocusCityLayout.radius(c),
                      ),
                    ),
                  ),
                );

                final Widget finishBtn = FilledButton.tonalIcon(
                  onPressed: canFinish
                      ? () {
                          HapticFeedback.mediumImpact();
                          context.read<FocusSessionData>().finishSessionEarly();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  FocusCityLayout.radius(c),
                                ),
                              ),
                              content: Text(
                                l10n.sessionEndedEarlyNoXp,
                              ),
                            ),
                          );
                        }
                      : null,
                  icon: Icon(Icons.flag_rounded, size: c ? 18 : 20),
                  label: Text(
                    l10n.finishLabel,
                    style: TextStyle(fontSize: c ? 13 : 14),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange.shade50,
                    foregroundColor: Colors.orange.shade900,
                    padding: EdgeInsets.symmetric(vertical: btnV),
                    minimumSize: Size(0, c ? 42 : 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        FocusCityLayout.radius(c),
                      ),
                    ),
                  ),
                );

                if (narrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      startBtn,
                      SizedBox(height: gap),
                      pauseBtn,
                      SizedBox(height: gap),
                      finishBtn,
                    ],
                  );
                }

                return Row(
                  children: <Widget>[
                    Expanded(child: startBtn),
                    SizedBox(width: gap),
                    Expanded(child: pauseBtn),
                    SizedBox(width: gap),
                    Expanded(child: finishBtn),
                  ],
                );
              },
            ),
            SizedBox(height: c ? 4 : 6),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditTimerDialog(BuildContext context, int current) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final FocusSessionData session = context.read<FocusSessionData>();
    final TextEditingController controller =
        TextEditingController(text: '$current');
    await showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.editFocusLength),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.setSessionLengthHint,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: l10n.minutesLabel,
                suffixText: l10n.minSuffix,
                hintText: l10n.minutesRangeHint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => Navigator.of(ctx).pop(),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancelLabel),
          ),
          FilledButton(
            onPressed: () {
              final int? m = int.tryParse(controller.text.trim());
              if (m != null) {
                session.setSessionMinutes(m);
              }
              Navigator.of(ctx).pop();
            },
            style: FilledButton.styleFrom(backgroundColor: _kGreen),
            child: Text(l10n.applyLabel),
          ),
        ],
      ),
    );
    controller.dispose();
  }
}
