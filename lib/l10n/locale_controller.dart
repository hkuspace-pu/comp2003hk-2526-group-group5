import 'package:flutter/material.dart';

/// English vs Traditional Chinese (Hong Kong) — use [text] getters everywhere in UI.
enum AppLanguage { english, cantonese }

class LocaleController extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;

  Locale get locale => _language == AppLanguage.english
      ? const Locale('en')
      : const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK');

  void setLanguage(AppLanguage value) {
    if (_language == value) return;
    _language = value;
    notifyListeners();
  }

  bool get isEnglish => _language == AppLanguage.english;

  // —— Main shell ——
  String get navFocus => isEnglish ? 'Focus' : '專注';
  String get navMood => isEnglish ? 'Mood' : '心情';
  String get navDashboard => isEnglish ? 'Dashboard' : '儀表板';
  String get navActivity => isEnglish ? 'Activity' : '活動';
  String get navSettings => isEnglish ? 'Settings' : '設定';

  // —— Focus / Gamification ——
  String get focusCityTitle => isEnglish ? 'Focus City' : '專注城市';
  String get focusSessionHistory => isEnglish ? 'Session history' : 'Session 紀錄';
  String get focusTodaysCity => isEnglish ? "TODAY'S CITY" : '今日城市';
  String get focusBuildCityTagline =>
      isEnglish ? 'Build your city with focus sessions' : '用專注時間建設你嘅城市';
  String get focusTimerCountdown => isEnglish ? 'Countdown (auto log)' : '倒數（自動記錄）';
  String get focusTimerStopwatch => isEnglish ? 'Stopwatch (manual stop)' : '碼表（手動停止）';
  String get focusStart => isEnglish ? 'Start' : '開始';
  String get focusPause => isEnglish ? 'Pause' : '暫停';
  String get focusResume => isEnglish ? 'Resume' : '繼續';
  String get focusFinish => isEnglish ? 'Finish' : '結束';
  String get focusDragHint => isEnglish
      ? 'Drag unlocked items from below into the green area to build your city'
      : '從下方拖曳已解鎖嘅圖示到綠色區域，組裝你嘅城市';
  String get focusNoSessionsYet => isEnglish
      ? 'No focus logs yet (complete a session to see entries)'
      : '尚無專注紀錄（完成一次計時後會顯示）';
  String get focusMinutesXp => isEnglish ? 'min · +' : '分鐘 · +';
  String get focusAutoComplete => isEnglish ? 'Auto (countdown ended)' : '自動完成（倒數結束）';
  String get focusManualEnd => isEnglish ? 'Manual end' : '手動結束';
  String get focusLoggedXp => isEnglish ? 'Session saved · +' : '已記錄專注 · +';

  // —— Settings ——
  String get settingsTitle => isEnglish ? 'Settings' : '設定';
  String get settingsReminders => isEnglish ? 'Reminders' : '提醒';
  String get settingsFocusStartReminder => isEnglish ? 'Focus start reminder' : '專注開始提醒';
  String get settingsFocusStartReminderSub =>
      isEnglish ? 'Local notifications later' : '之後可接本地通知';
  String get settingsBreakReminder => isEnglish ? 'Break reminder' : '休息提醒';
  String get settingsBreakReminderSub => isEnglish ? 'Local reminder placeholder' : '本地提醒占位';
  String get settingsOn => isEnglish ? 'On' : '已開啟';
  String get settingsOff => isEnglish ? 'Off' : '已關閉';
  String get settingsProfile => isEnglish ? 'Profile' : '個人檔';
  String get settingsAddProfile => isEnglish ? 'Add profile' : '新增 profile';
  String get settingsProfileAdded => isEnglish ? 'Profile added' : '已新增 profile';
  String get settingsAccount => isEnglish ? 'Account settings' : '帳戶設定';
  String get settingsPrivacy => isEnglish ? 'Privacy' : '私隱';
  String get settingsSecurity => isEnglish ? 'Security' : '安全性';
  String get settingsChangePassword => isEnglish ? 'Change password' : '更改密碼';
  String get settingsPrivacySnack => isEnglish ? 'Privacy settings' : '私隱設定';
  String get settingsSecuritySnack => isEnglish ? 'Security settings' : '安全性設定';
  String get settingsPasswordSnack => isEnglish ? 'Change password' : '更改密碼';
  String get settingsData => isEnglish ? 'Data' : '資料';
  String get settingsExportTsv => isEnglish ? 'Export TSV' : '匯出 TSV';
  String get settingsExportTsvSub => isEnglish ? 'File export later' : '之後接真檔案';
  String get settingsImportTsv => isEnglish ? 'Import TSV' : '匯入 TSV';
  String get settingsExportSnack => isEnglish ? 'Export — coming soon' : '匯出 — 功能稍後接';
  String get settingsImportSnack => isEnglish ? 'Import — coming soon' : '匯入 — 功能稍後接';
  String get settingsHealthMock => isEnglish ? 'Health (mock)' : 'Health（mock）';
  String get settingsHealthMockSub => isEnglish ? 'Preview: 6234 steps today' : '預覽：今日步數 6234';
  String get settingsHealthSnack =>
      isEnglish ? 'Apple Health / Google Fit later' : 'Apple Health / Google Fit 之後接';
  String get settingsShareCity => isEnglish ? 'Share city' : '分享城市';
  String get settingsShareCitySub =>
      isEnglish ? 'Share your progress as text' : '以文字分享進度';
  String get settingsLanguage => isEnglish ? 'Language' : '語言';
  String get settingsLanguageEnglish => isEnglish ? 'English' : 'English';
  String get settingsLanguageCantonese => isEnglish ? 'Cantonese' : '廣東話';
  String get settingsAbout => isEnglish ? 'About app' : '關於';
  String get settingsVersion => isEnglish ? 'Version' : '版本';
  String get settingsHelp => isEnglish ? 'Help & support' : '說明與支援';
  String get settingsVersionSnack => isEnglish ? 'App version info' : '應用程式版本';
  String get settingsHelpSnack => isEnglish ? 'Help & support' : '說明與支援';
  String get settingsLogout => isEnglish ? 'Log out' : '登出';
  String get settingsNoUser => isEnglish ? 'No user logged in' : '未登入';
  String get settingsDemoLogin => isEnglish ? 'Log in (demo)' : '登入（示範）';
  String get settingsUserProfileTap => isEnglish ? 'User profile tapped' : '已點選個人檔';
  String shareCityMessage(int level, int xp) => isEnglish
      ? 'My Focus City — Level $level, Total XP: $xp. Built with Focus Wellbeing!'
      : '我嘅專注城市 — Lv $level，總 XP：$xp。Focus Wellbeing 出品！';

  // —— Activity ——
  String get activityTitle => isEnglish ? 'Activity log' : '活動紀錄';
  String get activityType => isEnglish ? 'Type' : '類型';
  String get activityTypeHint => isEnglish ? 'e.g. Study / Exercise' : '例如 Study / Exercise';
  String get activityContent => isEnglish ? 'Details' : '內容';
  String get activityContentHint => isEnglish ? 'What did you do?' : '做了啲乜…';
  String get activityMediaUrl => isEnglish ? 'Media link (optional)' : '媒體連結（可選）';
  String get activityMediaUrlHint => isEnglish ? 'Image / video URL' : '圖片／影片 URL';
  String get activityMediaFile => isEnglish ? 'Or pick a file' : '或選擇檔案';
  String get activityPickFile => isEnglish ? 'Choose file' : '選擇檔案';
  String get activityClearFile => isEnglish ? 'Clear file' : '清除檔案';
  String get activitySubmit => isEnglish ? 'Submit' : '提交';
  String get activitySaved => isEnglish ? 'Saved' : '已儲存';
  String get activityRecent => isEnglish ? 'Recent' : '最近紀錄';
  String get activityNone => isEnglish ? 'None yet' : '暫無';

  // —— Dashboard ——
  String get dashTitle => isEnglish ? 'Dashboard' : '儀表板';
  String get dashToday => isEnglish ? 'Today' : '今日';
  String get dashWeek => isEnglish ? 'Week' : '本週';
  String get dashMonth => isEnglish ? 'Month' : '本月';
  String get dashFocusPreview => isEnglish ? 'Focus time (preview)' : '專注時間（預覽）';
  String get dashMinutes => isEnglish ? 'min' : '分鐘';
  String get dashSessionsStored => isEnglish ? 'sessions stored' : '筆 session';
  String get dashMoodPreview => isEnglish ? 'Latest mood (preview)' : '最近心情（預覽）';
  String get dashMoodRecords => isEnglish ? 'mood records' : '筆心情紀錄';
  String get dashGamification => isEnglish ? 'Gamification' : '遊戲化進度';
  String get dashCalendarHint =>
      isEnglish ? 'Calendar (green dot = has logs)' : '日曆（有紀錄的日子會有綠點）';

  List<String> get calendarWeekdayLabels => isEnglish
      ? ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
      : ['日', '一', '二', '三', '四', '五', '六'];

  String calendarMonthTitle(int year, int month) =>
      isEnglish ? '$year / ${month.toString().padLeft(2, '0')}' : '$year 年 $month 月';

  // —— Mood ——
  String get moodTitle => isEnglish ? 'Mood' : '心情';
  String get moodHowToday => isEnglish ? 'How is your mood today?' : '今日心情點呀？';
  String get moodReflection => isEnglish ? 'Reflection' : '感想';
  String get moodReflectionHint =>
      isEnglish ? 'Write a few words about today…' : '寫幾句今日感受…';
  String get moodSaved => isEnglish ? 'Saved:' : '已記錄：';
  List<String> get moodLabels => isEnglish
      ? [
          'I feel very sad!',
          'I feel a bit down!',
          'I feel normal!',
          'I feel good!',
          'I feel great!',
        ]
      : [
          '好唔開心…',
          '有啲低落',
          '還好',
          '唔錯',
          '好正！',
        ];
}
