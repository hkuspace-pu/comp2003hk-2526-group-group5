// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '屏幕時間';

  @override
  String get welcomeTitle => '歡迎';

  @override
  String get welcomeSubtitle => '專注成長，一齊砌你嘅城市。';

  @override
  String get welcomeTagline => '專注時間，建造你的城市';

  @override
  String get bulletFocus => '用專注時段保持專注';

  @override
  String get bulletMood => '記低心情，睇清楚規律';

  @override
  String get bulletDashboard => '喺儀表板睇進度';

  @override
  String get signIn => '登入';

  @override
  String get signUp => '註冊';

  @override
  String get welcomeFooter => '新用戶？開個帳戶保存城市同數據。';

  @override
  String get staffPortalLink => '員工入口';

  @override
  String get staffPortalTitle => '員工入口';

  @override
  String get staffPortalSubtitle => '員工專用 · 管理同檢視使用者資料';

  @override
  String get staffPortalBody => '用員工帳戶登入以開啟總覽同使用者目錄。';

  @override
  String get staffBullet1 => '總覽：參與度同專注趨勢';

  @override
  String get staffBullet2 => '使用者目錄：搜尋同開啟檔案';

  @override
  String get staffBullet3 => '只限獲授權嘅員工帳戶';

  @override
  String get backToStudentApp => '返回學生應用';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageSubtitle => '應用顯示語言';

  @override
  String get languagePickerTitle => '選擇語言';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCantonese => '粵語（繁體）';

  @override
  String get msgEnterEmailPassword => '請輸入電郵同密碼。';

  @override
  String get msgEnterWorkEmailPassword => '請輸入工作電郵同密碼。';

  @override
  String get msgEnterValidEmail => '請輸入有效格式電郵。';

  @override
  String get msgGoogleUnavailable => 'Google 登入暫時未開放。';

  @override
  String get msgEmailPasswordFilled => '已填入電郵同密碼。';

  @override
  String get msgFillAllFields => '請填寫所有欄位。';

  @override
  String get msgPasswordMismatch => '兩次密碼不一致。';

  @override
  String get msgAcceptPrivacy => '請先同意私隱政策先可以註冊。';

  @override
  String get msgEnterYourEmail => '請輸入你嘅電郵。';

  @override
  String get loginNowTitle => '立即登入';

  @override
  String get authContinueHint => '請登入或註冊以繼續使用本應用程式';

  @override
  String get sampleAccountTitle => '示範帳號';

  @override
  String get sampleAccountHint => '可用此示範帳號快速登入。';

  @override
  String get fillFields => '填入欄位';

  @override
  String get quickSignIn => '快速登入';

  @override
  String get emailLabel => '電郵';

  @override
  String get enterEmailHint => '請輸入電郵';

  @override
  String get passwordLabel => '密碼';

  @override
  String get enterPasswordHint => '請輸入密碼';

  @override
  String get forgotPassword => '忘記密碼？';

  @override
  String get loginButton => '登入';

  @override
  String get signInWithGoogle => '使用 Google 登入';

  @override
  String get noAccountPrompt => '未有帳號？';

  @override
  String get userNameLabel => '用戶名稱';

  @override
  String get enterUserNameHint => '請輸入用戶名稱';

  @override
  String get confirmPasswordLabel => '確認密碼';

  @override
  String get confirmPasswordHint => '請再次輸入密碼';

  @override
  String get agreePrivacyPolicy => '我同意私隱政策';

  @override
  String get readFullPolicy => '查看完整政策';

  @override
  String get haveAccountPrompt => '你已經有帳號？';

  @override
  String get resetPasswordTitle => '重設密碼';

  @override
  String get resetPasswordHint => '請輸入你帳號電郵。正式版本會發送重設連結；目前此頁為介面示範。';

  @override
  String get emailExampleHint => 'you@example.com';

  @override
  String get sendResetLink => '發送重設連結';

  @override
  String passwordResetUnavailable(Object email) {
    return '目前未支援向 $email 發送重設郵件。';
  }

  @override
  String get staffWorkAccountTitle => '工作帳號';

  @override
  String get staffWorkAccountHint => '請用員工電郵登入以開啟總覽同使用者目錄。';

  @override
  String get staffDemoAccountTitle => '員工示範帳號';

  @override
  String get staffDemoAccountHint => '一按可填入示範帳號，或者直接快速登入。';

  @override
  String get staffWorkEmailLabel => '工作電郵';

  @override
  String get staffLoginTitle => '員工登入';

  @override
  String get continueLabel => '繼續';

  @override
  String get msgAcceptStaffTerms => '請先同意員工帳號條款。';

  @override
  String get staffAccountTitle => '員工帳號';

  @override
  String get staffRegisterHint => '註冊後可使用總覽、使用者目錄同設定。';

  @override
  String get fullNameLabel => '全名';

  @override
  String get staffAuthorizedConfirm => '我確認此帳號為獲授權員工帳號。';

  @override
  String get signOutConfirmTitle => '確認登出？';

  @override
  String get signOutConfirmBody => '你將會返回歡迎頁。';

  @override
  String get cancelLabel => '取消';

  @override
  String get signOutLabel => '登出';

  @override
  String get staffOverviewTitle => '員工總覽';

  @override
  String get staffUserDirectoryTitle => '使用者目錄';

  @override
  String get settingsLabel => '設定';

  @override
  String get dashboardLabel => '儀表板';

  @override
  String get usersLabel => '使用者';

  @override
  String get privacyPolicyTitle => '私隱政策';

  @override
  String get lastUpdatedLabel => '最後更新';

  @override
  String get privacyWhatWeCollectTitle => '我們收集什麼';

  @override
  String get privacyWhatWeCollectBody =>
      '我們會收集你在應用程式中提供的資料，例如帳號電郵、心情記錄同專注時段記錄，以支援核心功能並改善體驗。';

  @override
  String get privacyHowWeUseItTitle => '我們如何使用';

  @override
  String get privacyHowWeUseItBody => '你的資料會用於顯示儀表板、支援裝置同步，以及維持與生產力和身心健康相關功能。';

  @override
  String get privacyYourChoicesTitle => '你的選擇';

  @override
  String get privacyYourChoicesBody =>
      '當相關功能接通後，你可在設定頁匯出或刪除資料。此頁面用於提供註冊勾選項目的政策連結。';

  @override
  String get leaveAppTitle => '離開應用程式？';

  @override
  String get leaveAppButton => '離開';

  @override
  String get backToWelcomeTooltip => '返回歡迎頁';

  @override
  String get shellTitleBuildCity => '建造你的城市';

  @override
  String get shellTitleMoodLog => '心情記錄';

  @override
  String get shellTitleActivity => '活動';

  @override
  String get tabFocus => '專注';

  @override
  String get tabMood => '心情';

  @override
  String get tabActivity => '活動';

  @override
  String get yourProgress => '你的進度';

  @override
  String get levelLabel => '等級';

  @override
  String get totalXpLabel => '總經驗值';

  @override
  String get overviewLabel => '總覽';

  @override
  String get todaySegment => '今日';

  @override
  String get weekSegment => '本週';

  @override
  String get calendarLabel => '日曆';

  @override
  String get calendarHint => '用箭嘴轉月份。撳某日睇摘要。';

  @override
  String get todaysSummary => '今日摘要';

  @override
  String get focusTimeLabel => '專注時間';

  @override
  String get sessionsCompletedLabel => '完成的專注次數';

  @override
  String get moodCheckInsLabel => '心情記錄次數';

  @override
  String get xpGainedTodayLabel => '今日獲得經驗值';

  @override
  String get weekFocusMinutesTitle => '本週 — 專注分鐘';

  @override
  String get daySummaryTitle => '當日摘要';

  @override
  String get todayLabel => '今日';

  @override
  String get dayStatFocus => '專注';

  @override
  String get dayStatSessions => '次數';

  @override
  String get statPlaceholder => '--';

  @override
  String focusMinutesValue(Object minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get weekChartDayLabels => '一,二,三,四,五,六,日';

  @override
  String unlockNextAtItem(Object xp, Object label, Object description) {
    return '下一個解鎖喺 $xp 經驗值：$label · $description';
  }

  @override
  String unlockNextAtLevel(Object xp, Object level) {
    return '下一個解鎖喺 $xp 經驗值：等級 $level';
  }

  @override
  String get unlockAllDone => '已解鎖所有物件並達到最高等級！';

  @override
  String get itemTree => '樹';

  @override
  String get itemPark => '公園';

  @override
  String get itemHouse => '房屋';

  @override
  String get itemBuilding => '大廈';

  @override
  String get itemRoad => '道路';

  @override
  String get itemRiver => '河流';

  @override
  String get itemBridge => '橋';

  @override
  String get itemDescTree => '為城市增添自然美';

  @override
  String get itemDescPark => '休憩同玩樂嘅綠化空間';

  @override
  String get itemDescHouse => '為居民提供居所';

  @override
  String get itemDescBuilding => '標誌你進度嘅高樓';

  @override
  String get itemDescRoad => '連接城市各區';

  @override
  String get itemDescRiver => '流動嘅水道，景色怡人';

  @override
  String get itemDescBridge => '跨越河流同空隙';

  @override
  String xpAmount(Object xp) {
    return '$xp 經驗值';
  }

  @override
  String levelXpLine(Object level, Object xp) {
    return '等級 $level · $xp 經驗值';
  }

  @override
  String get focusCityProgressTitle => '今日城市進度';

  @override
  String get focusCityProgressSubtitle => '每次專注都砌好你嘅城市';

  @override
  String focusCompletedXp(Object xp) {
    return '完成！+$xp 經驗值！';
  }

  @override
  String get placeItemsTitle => '放置物件';

  @override
  String get pauseDragHint => '暫停或完成專注先可以拖曳';

  @override
  String get placeLabel => '放置';

  @override
  String get pausePlaceTooltip => '暫停或完成專注先可以放到城市';

  @override
  String get demoOn => '示範開';

  @override
  String get demo => '示範';

  @override
  String get endFocusSession => '結束專注時段';

  @override
  String startFocusSessionMinutes(Object minutes) {
    return '開始 $minutes 分鐘專注時段';
  }

  @override
  String get resetCityProgress => '重設城市進度';

  @override
  String get focusCityAppBar => '專注城市';

  @override
  String get focusSessionTitle => '專注時段';

  @override
  String get editLengthTooltip => '編輯長度';

  @override
  String get startLabel => '開始';

  @override
  String get pauseLabel => '暫停';

  @override
  String get resumeLabel => '繼續';

  @override
  String get finishLabel => '完成';

  @override
  String get sessionEndedEarlyNoXp => '已提早結束（無完成經驗值）。';

  @override
  String get editFocusLength => '編輯專注長度';

  @override
  String get setSessionLengthHint => '設定時段長度（1–180 分鐘）。';

  @override
  String get minutesLabel => '分鐘';

  @override
  String get minSuffix => '分鐘';

  @override
  String get minutesRangeHint => '1–180';

  @override
  String get applyLabel => '套用';

  @override
  String get moodLoggingTitle => '心情記錄';

  @override
  String get moodVerySad => '好唔開心！';

  @override
  String get moodBitDown => '有啲低落！';

  @override
  String get moodNormal => '感覺普通！';

  @override
  String get moodGood => '感覺唔錯！';

  @override
  String get moodGreat => '感覺好好！';

  @override
  String get moodScaleVeryLow => '好低';

  @override
  String get moodScaleLow => '低';

  @override
  String get moodScaleNormal => '普通';

  @override
  String get moodScaleGood => '好';

  @override
  String get moodScaleGreat => '好好';

  @override
  String get moodQuestion => '你而家心情點樣？';

  @override
  String get moodInstruction => '撳掣或拉動刻度記低你而家嘅感受。';

  @override
  String moodSaved(Object mood) {
    return '已儲存：$mood';
  }

  @override
  String get moodSaveButton => '儲存心情';

  @override
  String get sessionActivityTitle => '專注活動';

  @override
  String get sessionActivitySubtitle => '加張相同寫低幾句今次專注嘅感受。';

  @override
  String get shareActivitySnack => '分享活動';

  @override
  String get shareThisActivity => '分享這個活動';

  @override
  String get mediaSection => '媒體';

  @override
  String get photoOrVideo => '相片或影片';

  @override
  String get optionalTapMedia => '可選 — 撳範圍附加媒體。';

  @override
  String get removeTooltip => '移除';

  @override
  String get tapToAddMedia => '撳此加入媒體';

  @override
  String get sampleImageAttached => '已附加示範圖片';

  @override
  String get notesSection => '筆記';

  @override
  String get reflectionTitle => '反思';

  @override
  String get reflectionPrompt => '今次有咩特別？';

  @override
  String get reflectionHint => '寫幾句反思…';

  @override
  String get saveSession => '儲存時段';

  @override
  String get sessionSavedWithoutMedia => '已儲存（無媒體）。';

  @override
  String get sessionSavedWithPhoto => '已儲存（有相片）。';

  @override
  String get sessionSavedWithoutMediaNote => '已儲存（無媒體）。已記低筆記。';

  @override
  String get sessionSavedWithPhotoNote => '已儲存（有相片）。已記低筆記。';

  @override
  String get sessionActivityAppBar => '專注活動';

  @override
  String get backButtonPressed => '已撳返回掣！';

  @override
  String navItemTapped(Object index) {
    return '已撳項目：$index';
  }

  @override
  String bottomNavTapped(Object index) {
    return '已撳底部導覽：$index';
  }

  @override
  String get settingsPageTitle => '設定';

  @override
  String get settingsGeneral => '一般';

  @override
  String get settingsNotificationsTitle => '通知';

  @override
  String get settingsNotificationsSubtitle => '提醒同提示';

  @override
  String get settingsAccountGroup => '帳戶';

  @override
  String get settingsPrivacy => '私隱';

  @override
  String get settingsPrivacySubtitle => '資料同可見度';

  @override
  String get settingsSecurity => '安全';

  @override
  String get settingsSecuritySubtitle => '裝置同登入';

  @override
  String get settingsChangePassword => '更改密碼';

  @override
  String get settingsChangePasswordSubtitle => '更新密碼';

  @override
  String get settingsDataSharing => '資料同分享';

  @override
  String get settingsExportImport => '匯出／匯入';

  @override
  String get settingsExportImportSubtitle => '備份進度';

  @override
  String get settingsShareCity => '分享城市';

  @override
  String get settingsShareCitySubtitle => '分享到社交';

  @override
  String get settingsAbout => '關於';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsVersionSubtitle => '組建同更新';

  @override
  String get settingsHelpSupport => '說明同支援';

  @override
  String get settingsHelpSubtitle => '常見問題同聯絡';

  @override
  String get accountAndProfile => '帳戶同個人檔案';

  @override
  String get noAccountLoaded => '未有載入帳戶';

  @override
  String get signInFromWelcome => '請喺歡迎頁登入，或喺下面繼續。';

  @override
  String get settingsSnackPrivacy => '私隱設定';

  @override
  String get settingsSnackSecurity => '安全設定';

  @override
  String get settingsSnackChangePassword => '更改密碼';

  @override
  String get settingsSnackBuild => '組建 1.0.0';

  @override
  String get settingsSnackHelp => '說明同支援';

  @override
  String get buildVersionLabel => '1.0.0';

  @override
  String get accountPageTitle => '帳戶';

  @override
  String get accountNoUser => '未有載入帳戶';

  @override
  String get accountPlaceholderBody => '編輯個人檔案同連結登入方式可喺之後版本提供。';

  @override
  String get notificationsPageTitle => '通知';

  @override
  String get notificationFocusReminders => '專注時段提醒';

  @override
  String get notificationFocusRemindersSubtitle => '預定時段前提示';

  @override
  String get notificationWeeklySummary => '每週摘要';

  @override
  String get notificationWeeklySummarySubtitle => '經驗值同連勝重點';

  @override
  String get notificationPermissionNote => '喺裝置上仍須系統通知權限。';

  @override
  String get exportImportPageTitle => '匯出／匯入';

  @override
  String get exportImportBody => '將城市版面同進度備份到檔案，或從備份還原。正式儲存接通後會實作檔案讀寫。';

  @override
  String get exportStarted => '已開始匯出';

  @override
  String get importStarted => '已開始匯入';

  @override
  String get exportBackupButton => '匯出備份';

  @override
  String get importBackupButton => '匯入備份';

  @override
  String get shareCityPageTitle => '分享城市';

  @override
  String get shareCityBody => '分享快照或邀請朋友睇你嘅專注城市。手機版可再加原生分享。';

  @override
  String get shareOpened => '已開啟分享';

  @override
  String get shareButton => '分享';

  @override
  String staffHelloName(Object name) {
    return '你好，$name';
  }

  @override
  String get staffOverviewIntro => '此總覽顯示目錄範圍指標同示範每週趨勢。接通後端後可換成真實數據。';

  @override
  String get staffOverviewSection => '總覽';

  @override
  String get staffRegistered => '已註冊';

  @override
  String get staffActiveStatus => '活躍（狀態）';

  @override
  String get staffFocusMinutesCohortWeek => '專注分鐘（本週 · 群組）';

  @override
  String get staffAllUsersChartTitle => '所有使用者 — 專注分鐘（示範週）';

  @override
  String get staffUserId => '使用者 ID';

  @override
  String get staffLastActive => '最後活躍';

  @override
  String get staffFocusThisWeek => '專注（本週）';

  @override
  String get staffStatus => '狀態';

  @override
  String get staffSearchHint => '搜尋名稱、電郵或 ID';

  @override
  String get closeLabel => '關閉';

  @override
  String get staffSettingsPreferences => '偏好設定';

  @override
  String get staffPushNotifications => '推送通知';

  @override
  String get staffPushNotificationsSubtitle => '接收帳戶同系統提示。';

  @override
  String get staffWeeklyDigestEmail => '每週摘要電郵';

  @override
  String get staffWeeklyDigestEmailSubtitle => '使用者活動同趨勢摘要。';

  @override
  String get staffCompactUserList => '精簡使用者清單';

  @override
  String get staffCompactUserListSubtitle => '喺使用者目錄顯示更緊密行距。';

  @override
  String get staffSupportSection => '支援';

  @override
  String get staffHelpCenter => '說明中心';

  @override
  String get staffHelpCenterSubtitle => '員工流程使用指南。';

  @override
  String get staffPrivacyDataPolicy => '私隱同資料政策';

  @override
  String get staffPrivacyDataPolicySubtitle => '檢視資料處理同存取範圍。';

  @override
  String get staffContactAdministrator => '聯絡管理員';

  @override
  String get staffContactAdministratorSubtitle => '回報權限或資料問題。';

  @override
  String get staffRoleLabel => '角色：員工';

  @override
  String get userRoleLabel => '角色：用戶';
}

/// The translations for Chinese, as used in Hong Kong (`zh_HK`).
class AppLocalizationsZhHk extends AppLocalizationsZh {
  AppLocalizationsZhHk() : super('zh_HK');

  @override
  String get appTitle => '屏幕時間';

  @override
  String get welcomeTitle => '歡迎';

  @override
  String get welcomeSubtitle => '專注成長，一齊砌你嘅城市。';

  @override
  String get welcomeTagline => '專注時間，建造你的城市';

  @override
  String get bulletFocus => '用專注時段保持專注';

  @override
  String get bulletMood => '記低心情，睇清楚規律';

  @override
  String get bulletDashboard => '喺儀表板睇進度';

  @override
  String get signIn => '登入';

  @override
  String get signUp => '註冊';

  @override
  String get welcomeFooter => '新用戶？開個帳戶保存城市同數據。';

  @override
  String get staffPortalLink => '員工入口';

  @override
  String get staffPortalTitle => '員工入口';

  @override
  String get staffPortalSubtitle => '員工專用 · 管理同檢視使用者資料';

  @override
  String get staffPortalBody => '用員工帳戶登入以開啟總覽同使用者目錄。';

  @override
  String get staffBullet1 => '總覽：參與度同專注趨勢';

  @override
  String get staffBullet2 => '使用者目錄：搜尋同開啟檔案';

  @override
  String get staffBullet3 => '只限獲授權嘅員工帳戶';

  @override
  String get backToStudentApp => '返回學生應用';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageSubtitle => '應用顯示語言';

  @override
  String get languagePickerTitle => '選擇語言';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCantonese => '粵語（繁體）';

  @override
  String get msgEnterEmailPassword => '請輸入電郵同密碼。';

  @override
  String get msgEnterWorkEmailPassword => '請輸入工作電郵同密碼。';

  @override
  String get msgEnterValidEmail => '請輸入有效格式電郵。';

  @override
  String get msgGoogleUnavailable => 'Google 登入暫時未開放。';

  @override
  String get msgEmailPasswordFilled => '已填入電郵同密碼。';

  @override
  String get msgFillAllFields => '請填寫所有欄位。';

  @override
  String get msgPasswordMismatch => '兩次密碼不一致。';

  @override
  String get msgAcceptPrivacy => '請先同意私隱政策先可以註冊。';

  @override
  String get msgEnterYourEmail => '請輸入你嘅電郵。';

  @override
  String get loginNowTitle => '立即登入';

  @override
  String get authContinueHint => '請登入或註冊以繼續使用本應用程式';

  @override
  String get sampleAccountTitle => '示範帳號';

  @override
  String get sampleAccountHint => '可用此示範帳號快速登入。';

  @override
  String get fillFields => '填入欄位';

  @override
  String get quickSignIn => '快速登入';

  @override
  String get emailLabel => '電郵';

  @override
  String get enterEmailHint => '請輸入電郵';

  @override
  String get passwordLabel => '密碼';

  @override
  String get enterPasswordHint => '請輸入密碼';

  @override
  String get forgotPassword => '忘記密碼？';

  @override
  String get loginButton => '登入';

  @override
  String get signInWithGoogle => '使用 Google 登入';

  @override
  String get noAccountPrompt => '未有帳號？';

  @override
  String get userNameLabel => '用戶名稱';

  @override
  String get enterUserNameHint => '請輸入用戶名稱';

  @override
  String get confirmPasswordLabel => '確認密碼';

  @override
  String get confirmPasswordHint => '請再次輸入密碼';

  @override
  String get agreePrivacyPolicy => '我同意私隱政策';

  @override
  String get readFullPolicy => '查看完整政策';

  @override
  String get haveAccountPrompt => '你已經有帳號？';

  @override
  String get resetPasswordTitle => '重設密碼';

  @override
  String get resetPasswordHint => '請輸入你帳號電郵。正式版本會發送重設連結；目前此頁為介面示範。';

  @override
  String get emailExampleHint => 'you@example.com';

  @override
  String get sendResetLink => '發送重設連結';

  @override
  String passwordResetUnavailable(Object email) {
    return '目前未支援向 $email 發送重設郵件。';
  }

  @override
  String get staffWorkAccountTitle => '工作帳號';

  @override
  String get staffWorkAccountHint => '請用員工電郵登入以開啟總覽同使用者目錄。';

  @override
  String get staffDemoAccountTitle => '員工示範帳號';

  @override
  String get staffDemoAccountHint => '一按可填入示範帳號，或者直接快速登入。';

  @override
  String get staffWorkEmailLabel => '工作電郵';

  @override
  String get staffLoginTitle => '員工登入';

  @override
  String get continueLabel => '繼續';

  @override
  String get msgAcceptStaffTerms => '請先同意員工帳號條款。';

  @override
  String get staffAccountTitle => '員工帳號';

  @override
  String get staffRegisterHint => '註冊後可使用總覽、使用者目錄同設定。';

  @override
  String get fullNameLabel => '全名';

  @override
  String get staffAuthorizedConfirm => '我確認此帳號為獲授權員工帳號。';

  @override
  String get signOutConfirmTitle => '確認登出？';

  @override
  String get signOutConfirmBody => '你將會返回歡迎頁。';

  @override
  String get cancelLabel => '取消';

  @override
  String get signOutLabel => '登出';

  @override
  String get staffOverviewTitle => '員工總覽';

  @override
  String get staffUserDirectoryTitle => '使用者目錄';

  @override
  String get settingsLabel => '設定';

  @override
  String get dashboardLabel => '儀表板';

  @override
  String get usersLabel => '使用者';

  @override
  String get privacyPolicyTitle => '私隱政策';

  @override
  String get lastUpdatedLabel => '最後更新';

  @override
  String get privacyWhatWeCollectTitle => '我們收集什麼';

  @override
  String get privacyWhatWeCollectBody =>
      '我們會收集你在應用程式中提供的資料，例如帳號電郵、心情記錄同專注時段記錄，以支援核心功能並改善體驗。';

  @override
  String get privacyHowWeUseItTitle => '我們如何使用';

  @override
  String get privacyHowWeUseItBody => '你的資料會用於顯示儀表板、支援裝置同步，以及維持與生產力和身心健康相關功能。';

  @override
  String get privacyYourChoicesTitle => '你的選擇';

  @override
  String get privacyYourChoicesBody =>
      '當相關功能接通後，你可在設定頁匯出或刪除資料。此頁面用於提供註冊勾選項目的政策連結。';

  @override
  String get leaveAppTitle => '離開應用程式？';

  @override
  String get leaveAppButton => '離開';

  @override
  String get backToWelcomeTooltip => '返回歡迎頁';

  @override
  String get shellTitleBuildCity => '建造你的城市';

  @override
  String get shellTitleMoodLog => '心情記錄';

  @override
  String get shellTitleActivity => '活動';

  @override
  String get tabFocus => '專注';

  @override
  String get tabMood => '心情';

  @override
  String get tabActivity => '活動';

  @override
  String get yourProgress => '你的進度';

  @override
  String get levelLabel => '等級';

  @override
  String get totalXpLabel => '總經驗值';

  @override
  String get overviewLabel => '總覽';

  @override
  String get todaySegment => '今日';

  @override
  String get weekSegment => '本週';

  @override
  String get calendarLabel => '日曆';

  @override
  String get calendarHint => '用箭嘴轉月份。撳某日睇摘要。';

  @override
  String get todaysSummary => '今日摘要';

  @override
  String get focusTimeLabel => '專注時間';

  @override
  String get sessionsCompletedLabel => '完成的專注次數';

  @override
  String get moodCheckInsLabel => '心情記錄次數';

  @override
  String get xpGainedTodayLabel => '今日獲得經驗值';

  @override
  String get weekFocusMinutesTitle => '本週 — 專注分鐘';

  @override
  String get daySummaryTitle => '當日摘要';

  @override
  String get todayLabel => '今日';

  @override
  String get dayStatFocus => '專注';

  @override
  String get dayStatSessions => '次數';

  @override
  String get statPlaceholder => '--';

  @override
  String focusMinutesValue(Object minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get weekChartDayLabels => '一,二,三,四,五,六,日';

  @override
  String unlockNextAtItem(Object xp, Object label, Object description) {
    return '下一個解鎖喺 $xp 經驗值：$label · $description';
  }

  @override
  String unlockNextAtLevel(Object xp, Object level) {
    return '下一個解鎖喺 $xp 經驗值：等級 $level';
  }

  @override
  String get unlockAllDone => '已解鎖所有物件並達到最高等級！';

  @override
  String get itemTree => '樹';

  @override
  String get itemPark => '公園';

  @override
  String get itemHouse => '房屋';

  @override
  String get itemBuilding => '大廈';

  @override
  String get itemRoad => '道路';

  @override
  String get itemRiver => '河流';

  @override
  String get itemBridge => '橋';

  @override
  String get itemDescTree => '為城市增添自然美';

  @override
  String get itemDescPark => '休憩同玩樂嘅綠化空間';

  @override
  String get itemDescHouse => '為居民提供居所';

  @override
  String get itemDescBuilding => '標誌你進度嘅高樓';

  @override
  String get itemDescRoad => '連接城市各區';

  @override
  String get itemDescRiver => '流動嘅水道，景色怡人';

  @override
  String get itemDescBridge => '跨越河流同空隙';

  @override
  String xpAmount(Object xp) {
    return '$xp 經驗值';
  }

  @override
  String levelXpLine(Object level, Object xp) {
    return '等級 $level · $xp 經驗值';
  }

  @override
  String get focusCityProgressTitle => '今日城市進度';

  @override
  String get focusCityProgressSubtitle => '每次專注都砌好你嘅城市';

  @override
  String focusCompletedXp(Object xp) {
    return '完成！+$xp 經驗值！';
  }

  @override
  String get placeItemsTitle => '放置物件';

  @override
  String get pauseDragHint => '暫停或完成專注先可以拖曳';

  @override
  String get placeLabel => '放置';

  @override
  String get pausePlaceTooltip => '暫停或完成專注先可以放到城市';

  @override
  String get demoOn => '示範開';

  @override
  String get demo => '示範';

  @override
  String get endFocusSession => '結束專注時段';

  @override
  String startFocusSessionMinutes(Object minutes) {
    return '開始 $minutes 分鐘專注時段';
  }

  @override
  String get resetCityProgress => '重設城市進度';

  @override
  String get focusCityAppBar => '專注城市';

  @override
  String get focusSessionTitle => '專注時段';

  @override
  String get editLengthTooltip => '編輯長度';

  @override
  String get startLabel => '開始';

  @override
  String get pauseLabel => '暫停';

  @override
  String get resumeLabel => '繼續';

  @override
  String get finishLabel => '完成';

  @override
  String get sessionEndedEarlyNoXp => '已提早結束（無完成經驗值）。';

  @override
  String get editFocusLength => '編輯專注長度';

  @override
  String get setSessionLengthHint => '設定時段長度（1–180 分鐘）。';

  @override
  String get minutesLabel => '分鐘';

  @override
  String get minSuffix => '分鐘';

  @override
  String get minutesRangeHint => '1–180';

  @override
  String get applyLabel => '套用';

  @override
  String get moodLoggingTitle => '心情記錄';

  @override
  String get moodVerySad => '好唔開心！';

  @override
  String get moodBitDown => '有啲低落！';

  @override
  String get moodNormal => '感覺普通！';

  @override
  String get moodGood => '感覺唔錯！';

  @override
  String get moodGreat => '感覺好好！';

  @override
  String get moodScaleVeryLow => '好低';

  @override
  String get moodScaleLow => '低';

  @override
  String get moodScaleNormal => '普通';

  @override
  String get moodScaleGood => '好';

  @override
  String get moodScaleGreat => '好好';

  @override
  String get moodQuestion => '你而家心情點樣？';

  @override
  String get moodInstruction => '撳掣或拉動刻度記低你而家嘅感受。';

  @override
  String moodSaved(Object mood) {
    return '已儲存：$mood';
  }

  @override
  String get moodSaveButton => '儲存心情';

  @override
  String get sessionActivityTitle => '專注活動';

  @override
  String get sessionActivitySubtitle => '加張相同寫低幾句今次專注嘅感受。';

  @override
  String get shareActivitySnack => '分享活動';

  @override
  String get shareThisActivity => '分享這個活動';

  @override
  String get mediaSection => '媒體';

  @override
  String get photoOrVideo => '相片或影片';

  @override
  String get optionalTapMedia => '可選 — 撳範圍附加媒體。';

  @override
  String get removeTooltip => '移除';

  @override
  String get tapToAddMedia => '撳此加入媒體';

  @override
  String get sampleImageAttached => '已附加示範圖片';

  @override
  String get notesSection => '筆記';

  @override
  String get reflectionTitle => '反思';

  @override
  String get reflectionPrompt => '今次有咩特別？';

  @override
  String get reflectionHint => '寫幾句反思…';

  @override
  String get saveSession => '儲存時段';

  @override
  String get sessionSavedWithoutMedia => '已儲存（無媒體）。';

  @override
  String get sessionSavedWithPhoto => '已儲存（有相片）。';

  @override
  String get sessionSavedWithoutMediaNote => '已儲存（無媒體）。已記低筆記。';

  @override
  String get sessionSavedWithPhotoNote => '已儲存（有相片）。已記低筆記。';

  @override
  String get sessionActivityAppBar => '專注活動';

  @override
  String get backButtonPressed => '已撳返回掣！';

  @override
  String navItemTapped(Object index) {
    return '已撳項目：$index';
  }

  @override
  String bottomNavTapped(Object index) {
    return '已撳底部導覽：$index';
  }

  @override
  String get settingsPageTitle => '設定';

  @override
  String get settingsGeneral => '一般';

  @override
  String get settingsNotificationsTitle => '通知';

  @override
  String get settingsNotificationsSubtitle => '提醒同提示';

  @override
  String get settingsAccountGroup => '帳戶';

  @override
  String get settingsPrivacy => '私隱';

  @override
  String get settingsPrivacySubtitle => '資料同可見度';

  @override
  String get settingsSecurity => '安全';

  @override
  String get settingsSecuritySubtitle => '裝置同登入';

  @override
  String get settingsChangePassword => '更改密碼';

  @override
  String get settingsChangePasswordSubtitle => '更新密碼';

  @override
  String get settingsDataSharing => '資料同分享';

  @override
  String get settingsExportImport => '匯出／匯入';

  @override
  String get settingsExportImportSubtitle => '備份進度';

  @override
  String get settingsShareCity => '分享城市';

  @override
  String get settingsShareCitySubtitle => '分享到社交';

  @override
  String get settingsAbout => '關於';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsVersionSubtitle => '組建同更新';

  @override
  String get settingsHelpSupport => '說明同支援';

  @override
  String get settingsHelpSubtitle => '常見問題同聯絡';

  @override
  String get accountAndProfile => '帳戶同個人檔案';

  @override
  String get noAccountLoaded => '未有載入帳戶';

  @override
  String get signInFromWelcome => '請喺歡迎頁登入，或喺下面繼續。';

  @override
  String get settingsSnackPrivacy => '私隱設定';

  @override
  String get settingsSnackSecurity => '安全設定';

  @override
  String get settingsSnackChangePassword => '更改密碼';

  @override
  String get settingsSnackBuild => '組建 1.0.0';

  @override
  String get settingsSnackHelp => '說明同支援';

  @override
  String get buildVersionLabel => '1.0.0';

  @override
  String get accountPageTitle => '帳戶';

  @override
  String get accountNoUser => '未有載入帳戶';

  @override
  String get accountPlaceholderBody => '編輯個人檔案同連結登入方式可喺之後版本提供。';

  @override
  String get notificationsPageTitle => '通知';

  @override
  String get notificationFocusReminders => '專注時段提醒';

  @override
  String get notificationFocusRemindersSubtitle => '預定時段前提示';

  @override
  String get notificationWeeklySummary => '每週摘要';

  @override
  String get notificationWeeklySummarySubtitle => '經驗值同連勝重點';

  @override
  String get notificationPermissionNote => '喺裝置上仍須系統通知權限。';

  @override
  String get exportImportPageTitle => '匯出／匯入';

  @override
  String get exportImportBody => '將城市版面同進度備份到檔案，或從備份還原。正式儲存接通後會實作檔案讀寫。';

  @override
  String get exportStarted => '已開始匯出';

  @override
  String get importStarted => '已開始匯入';

  @override
  String get exportBackupButton => '匯出備份';

  @override
  String get importBackupButton => '匯入備份';

  @override
  String get shareCityPageTitle => '分享城市';

  @override
  String get shareCityBody => '分享快照或邀請朋友睇你嘅專注城市。手機版可再加原生分享。';

  @override
  String get shareOpened => '已開啟分享';

  @override
  String get shareButton => '分享';

  @override
  String staffHelloName(Object name) {
    return '你好，$name';
  }

  @override
  String get staffOverviewIntro => '此總覽顯示目錄範圍指標同示範每週趨勢。接通後端後可換成真實數據。';

  @override
  String get staffOverviewSection => '總覽';

  @override
  String get staffRegistered => '已註冊';

  @override
  String get staffActiveStatus => '活躍（狀態）';

  @override
  String get staffFocusMinutesCohortWeek => '專注分鐘（本週 · 群組）';

  @override
  String get staffAllUsersChartTitle => '所有使用者 — 專注分鐘（示範週）';

  @override
  String get staffUserId => '使用者 ID';

  @override
  String get staffLastActive => '最後活躍';

  @override
  String get staffFocusThisWeek => '專注（本週）';

  @override
  String get staffStatus => '狀態';

  @override
  String get staffSearchHint => '搜尋名稱、電郵或 ID';

  @override
  String get closeLabel => '關閉';

  @override
  String get staffSettingsPreferences => '偏好設定';

  @override
  String get staffPushNotifications => '推送通知';

  @override
  String get staffPushNotificationsSubtitle => '接收帳戶同系統提示。';

  @override
  String get staffWeeklyDigestEmail => '每週摘要電郵';

  @override
  String get staffWeeklyDigestEmailSubtitle => '使用者活動同趨勢摘要。';

  @override
  String get staffCompactUserList => '精簡使用者清單';

  @override
  String get staffCompactUserListSubtitle => '喺使用者目錄顯示更緊密行距。';

  @override
  String get staffSupportSection => '支援';

  @override
  String get staffHelpCenter => '說明中心';

  @override
  String get staffHelpCenterSubtitle => '員工流程使用指南。';

  @override
  String get staffPrivacyDataPolicy => '私隱同資料政策';

  @override
  String get staffPrivacyDataPolicySubtitle => '檢視資料處理同存取範圍。';

  @override
  String get staffContactAdministrator => '聯絡管理員';

  @override
  String get staffContactAdministratorSubtitle => '回報權限或資料問題。';

  @override
  String get staffRoleLabel => '角色：員工';

  @override
  String get userRoleLabel => '角色：用戶';
}
