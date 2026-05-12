import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupproject_group5/l10n/app_localizations.dart';

import 'app_colors.dart';
import 'main_shell_insets.dart';

class SessionCompleteScreen extends StatefulWidget {
  const SessionCompleteScreen({super.key, this.embedded = false});

  /// When true, omit [Scaffold] app bar and bottom nav for [MainShellScreen].
  final bool embedded;

  @override
  State<SessionCompleteScreen> createState() => _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends State<SessionCompleteScreen> {
  static const Color _brandGreen = Color(0xFF46AA57);

  String? _selectedMediaUrl;
  bool _isMediaAdded = false;
  final TextEditingController _commentController = TextEditingController();
  int _selectedIndex = 0;

  void _togglePlaceholderMedia() {
    HapticFeedback.selectionClick();
    setState(() {
      _isMediaAdded = !_isMediaAdded;
      _selectedMediaUrl = _isMediaAdded
          ? 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'
          : null;
    });
  }

  void _submitSession() {
    HapticFeedback.mediumImpact();
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String comment = _commentController.text.trim();
    final String message;
    if (comment.isEmpty) {
      message =
          _isMediaAdded ? l10n.sessionSavedWithPhoto : l10n.sessionSavedWithoutMedia;
    } else {
      message = _isMediaAdded
          ? l10n.sessionSavedWithPhotoNote
          : l10n.sessionSavedWithoutMediaNote;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _onBackPressed() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.backButtonPressed)),
    );
  }

  void _onItemTapped(int index) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    setState(() => _selectedIndex = index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.navItemTapped('${index + 1}'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    final Widget scroll = CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            12,
            kMainTabScrollPadding.top,
            12,
            kMainTabScrollPadding.bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                if (widget.embedded) ...<Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _brandGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.directions_run_rounded,
                          color: _brandGreen,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              l10n.sessionActivityTitle,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.sessionActivitySubtitle,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.35,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            content: Text(l10n.shareActivitySnack),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _brandGreen,
                        side: BorderSide(color: _brandGreen.withValues(alpha: 0.45)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.share_rounded, size: 20),
                      label: Text(
                        l10n.shareThisActivity,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  l10n.mediaSection,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          l10n.photoOrVideo,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.optionalTapMedia,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _togglePlaceholderMedia,
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _isMediaAdded
                                    ? Colors.grey.shade100
                                    : kMainShellBackground,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _isMediaAdded
                                      ? _brandGreen.withValues(alpha: 0.65)
                                      : Colors.grey.shade300,
                                  width: _isMediaAdded ? 2 : 1.5,
                                ),
                              ),
                              child: _isMediaAdded
                                  ? Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            _selectedMediaUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (BuildContext context, Object _, StackTrace? __) =>
                                                    ColoredBox(
                                              color: Colors.grey.shade300,
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                                size: 48,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Material(
                                            color: Colors.black54,
                                            shape: const CircleBorder(),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.close_rounded,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                              onPressed: _togglePlaceholderMedia,
                                              tooltip: l10n.removeTooltip,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.add_photo_alternate_rounded,
                                          size: 44,
                                          color: _brandGreen.withValues(alpha: 0.75),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          l10n.tapToAddMedia,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          l10n.sampleImageAttached,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.notesSection,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          l10n.reflectionTitle,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.reflectionPrompt,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _commentController,
                          maxLines: 4,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: l10n.reflectionHint,
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: _brandGreen, width: 2),
                            ),
                            filled: true,
                            fillColor: kMainShellBackground,
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _submitSession,
                  style: FilledButton.styleFrom(
                    backgroundColor: _brandGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.check_rounded, size: 22),
                  label: Text(
                    l10n.saveSession,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    if (widget.embedded) {
      return ColoredBox(color: kMainShellBackground, child: scroll);
    }

    return Scaffold(
      backgroundColor: kMainShellBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _onBackPressed,
          color: Colors.white,
        ),
        title: Text(
          l10n.sessionActivityAppBar,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: _brandGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: scroll,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: _brandGreen,
        unselectedItemColor: Colors.grey[600],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.event_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.area_chart_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ''),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
