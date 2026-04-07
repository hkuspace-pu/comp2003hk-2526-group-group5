// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Screen time';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeSubtitle => 'Grow your focus. Build your city.';

  @override
  String get welcomeTagline => 'Focus time, build your city';

  @override
  String get bulletFocus => 'Stay on task with focus sessions';

  @override
  String get bulletMood => 'Log mood and see your patterns';

  @override
  String get bulletDashboard => 'Track progress on your dashboard';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get welcomeFooter =>
      'New here? Create an account to save your city and stats.';

  @override
  String get staffPortalLink => 'Staff portal';

  @override
  String get staffPortalTitle => 'Staff portal';

  @override
  String get staffPortalSubtitle => 'For staff · manage and view user data';

  @override
  String get staffPortalBody =>
      'Sign in with your staff account to open the dashboard and user directory.';

  @override
  String get staffBullet1 => 'Overview: engagement and focus trends';

  @override
  String get staffBullet2 => 'User directory: search and open profiles';

  @override
  String get staffBullet3 => 'Restricted to authorised staff accounts';

  @override
  String get backToStudentApp => 'Back to student app';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSubtitle => 'App display language';

  @override
  String get languagePickerTitle => 'Choose language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageCantonese => 'Cantonese (Traditional)';

  @override
  String get msgEnterEmailPassword => 'Please enter email and password.';

  @override
  String get msgEnterWorkEmailPassword =>
      'Please enter work email and password.';

  @override
  String get msgEnterValidEmail => 'Please enter a valid-looking email.';

  @override
  String get msgGoogleUnavailable => 'Google sign-in is not available yet.';

  @override
  String get msgEmailPasswordFilled => 'Email and password filled.';

  @override
  String get msgFillAllFields => 'Please fill in all fields.';

  @override
  String get msgPasswordMismatch => 'Passwords do not match.';

  @override
  String get msgAcceptPrivacy => 'Please accept the privacy policy to sign up.';

  @override
  String get msgEnterYourEmail => 'Please enter your email.';

  @override
  String get loginNowTitle => 'Login Now';

  @override
  String get authContinueHint =>
      'Please login or sign up to continue using our app';

  @override
  String get sampleAccountTitle => 'Sample account';

  @override
  String get sampleAccountHint => 'Use this sample account for quick sign-in.';

  @override
  String get fillFields => 'Fill fields';

  @override
  String get quickSignIn => 'Quick sign in';

  @override
  String get emailLabel => 'Email';

  @override
  String get enterEmailHint => 'Enter your email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get enterPasswordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get loginButton => 'Login';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get noAccountPrompt => 'Don\'t have an account? ';

  @override
  String get userNameLabel => 'User Name';

  @override
  String get enterUserNameHint => 'Enter your user name';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get agreePrivacyPolicy => 'I agree with the privacy policy';

  @override
  String get readFullPolicy => 'Read full policy';

  @override
  String get haveAccountPrompt => 'You already have an account? ';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String get resetPasswordHint =>
      'Enter the email for your account. In a real app we would send a reset link — this screen is layout only.';

  @override
  String get emailExampleHint => 'you@example.com';

  @override
  String get sendResetLink => 'Send reset link';

  @override
  String passwordResetUnavailable(Object email) {
    return 'Password reset is not available yet for $email.';
  }

  @override
  String get staffWorkAccountTitle => 'Work account';

  @override
  String get staffWorkAccountHint =>
      'Use your staff email to access the dashboard and user directory.';

  @override
  String get staffDemoAccountTitle => 'Demo staff account';

  @override
  String get staffDemoAccountHint =>
      'One tap to fill the demo credentials, or quick sign in.';

  @override
  String get staffWorkEmailLabel => 'Work email';

  @override
  String get staffLoginTitle => 'Staff sign in';

  @override
  String get continueLabel => 'Continue';

  @override
  String get msgAcceptStaffTerms => 'Please accept staff account terms.';

  @override
  String get staffAccountTitle => 'Staff account';

  @override
  String get staffRegisterHint =>
      'Register to access overview, user directory, and settings.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get staffAuthorizedConfirm =>
      'I confirm this is an authorised staff account.';

  @override
  String get signOutConfirmTitle => 'Sign out?';

  @override
  String get signOutConfirmBody => 'You will return to the welcome screen.';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get signOutLabel => 'Sign out';

  @override
  String get staffOverviewTitle => 'Staff overview';

  @override
  String get staffUserDirectoryTitle => 'User directory';

  @override
  String get settingsLabel => 'Settings';

  @override
  String get dashboardLabel => 'Dashboard';

  @override
  String get usersLabel => 'Users';

  @override
  String get privacyPolicyTitle => 'Privacy policy';

  @override
  String get lastUpdatedLabel => 'Last updated';

  @override
  String get privacyWhatWeCollectTitle => 'What we collect';

  @override
  String get privacyWhatWeCollectBody =>
      'We collect information you provide in the app, such as account email, mood logs, and focus session records, to support core features and improve your experience.';

  @override
  String get privacyHowWeUseItTitle => 'How we use it';

  @override
  String get privacyHowWeUseItBody =>
      'Your data is used to show your dashboard, help sync your experience across supported devices, and maintain app features related to productivity and wellbeing.';

  @override
  String get privacyYourChoicesTitle => 'Your choices';

  @override
  String get privacyYourChoicesBody =>
      'You can export or delete data from Settings when those screens are wired. This page exists so the sign-up checkbox has somewhere to link.';

  @override
  String get leaveAppTitle => 'Leave app?';

  @override
  String get leaveAppButton => 'Leave';

  @override
  String get backToWelcomeTooltip => 'Back to welcome';

  @override
  String get shellTitleBuildCity => 'Build Your City';

  @override
  String get shellTitleMoodLog => 'Mood log';

  @override
  String get shellTitleActivity => 'Activity';

  @override
  String get tabFocus => 'Focus';

  @override
  String get tabMood => 'Mood';

  @override
  String get tabActivity => 'Activity';

  @override
  String get yourProgress => 'Your progress';

  @override
  String get levelLabel => 'Level';

  @override
  String get totalXpLabel => 'Total XP';

  @override
  String get overviewLabel => 'Overview';

  @override
  String get todaySegment => 'Today';

  @override
  String get weekSegment => 'Week';

  @override
  String get calendarLabel => 'Calendar';

  @override
  String get calendarHint =>
      'Use arrows to change month. Tap a day to see its summary.';

  @override
  String get todaysSummary => 'Today\'s summary';

  @override
  String get focusTimeLabel => 'Focus time';

  @override
  String get sessionsCompletedLabel => 'Sessions completed';

  @override
  String get moodCheckInsLabel => 'Mood check-ins';

  @override
  String get xpGainedTodayLabel => 'XP gained today';

  @override
  String get weekFocusMinutesTitle => 'This week — focus minutes';

  @override
  String get daySummaryTitle => 'Day summary';

  @override
  String get todayLabel => 'Today';

  @override
  String get dayStatFocus => 'Focus';

  @override
  String get dayStatSessions => 'Sessions';

  @override
  String get statPlaceholder => '--';

  @override
  String focusMinutesValue(Object minutes) {
    return '$minutes min';
  }

  @override
  String get weekChartDayLabels => 'M,T,W,T,F,S,S';

  @override
  String unlockNextAtItem(Object xp, Object label, Object description) {
    return 'NEXT UNLOCK AT $xp XP: $label • $description';
  }

  @override
  String unlockNextAtLevel(Object xp, Object level) {
    return 'NEXT UNLOCK AT $xp XP: Level $level';
  }

  @override
  String get unlockAllDone => 'All items unlocked and maximum level achieved!';

  @override
  String get itemTree => 'Tree';

  @override
  String get itemPark => 'Park';

  @override
  String get itemHouse => 'House';

  @override
  String get itemBuilding => 'Building';

  @override
  String get itemRoad => 'Road';

  @override
  String get itemRiver => 'River';

  @override
  String get itemBridge => 'Bridge';

  @override
  String get itemDescTree => 'Adds natural beauty to your city';

  @override
  String get itemDescPark => 'A green space for relaxation and play';

  @override
  String get itemDescHouse => 'Provides shelter for citizens';

  @override
  String get itemDescBuilding => 'A tall structure to mark your progress';

  @override
  String get itemDescRoad => 'Connects your city\'s areas';

  @override
  String get itemDescRiver => 'A flowing waterway for scenic beauty';

  @override
  String get itemDescBridge => 'Spans over rivers and gaps';

  @override
  String xpAmount(Object xp) {
    return '$xp XP';
  }

  @override
  String levelXpLine(Object level, Object xp) {
    return 'Level $level · $xp XP';
  }

  @override
  String get focusCityProgressTitle => 'TODAY\'S CITY PROGRESS';

  @override
  String get focusCityProgressSubtitle =>
      'Build your city with each focus session';

  @override
  String focusCompletedXp(Object xp) {
    return 'Completed! +$xp XP!';
  }

  @override
  String get placeItemsTitle => 'Place items';

  @override
  String get pauseDragHint => 'Pause or finish focus to drag';

  @override
  String get placeLabel => 'Place';

  @override
  String get pausePlaceTooltip => 'Pause or finish focus to place on the city';

  @override
  String get demoOn => 'Demo on';

  @override
  String get demo => 'Demo';

  @override
  String get endFocusSession => 'END FOCUS SESSION';

  @override
  String startFocusSessionMinutes(Object minutes) {
    return 'START $minutes-MIN FOCUS SESSION';
  }

  @override
  String get resetCityProgress => 'Reset city progress';

  @override
  String get focusCityAppBar => 'Focus City';

  @override
  String get focusSessionTitle => 'Focus session';

  @override
  String get editLengthTooltip => 'Edit length';

  @override
  String get startLabel => 'Start';

  @override
  String get pauseLabel => 'Pause';

  @override
  String get resumeLabel => 'Resume';

  @override
  String get finishLabel => 'Finish';

  @override
  String get sessionEndedEarlyNoXp => 'Session ended early (no completion XP).';

  @override
  String get editFocusLength => 'Edit focus length';

  @override
  String get setSessionLengthHint => 'Set session length in minutes (1–180).';

  @override
  String get minutesLabel => 'Minutes';

  @override
  String get minSuffix => 'min';

  @override
  String get minutesRangeHint => '1–180';

  @override
  String get applyLabel => 'Apply';

  @override
  String get moodLoggingTitle => 'Mood Logging';

  @override
  String get moodVerySad => 'I feel very sad!';

  @override
  String get moodBitDown => 'I feel a bit down!';

  @override
  String get moodNormal => 'I feel normal!';

  @override
  String get moodGood => 'I feel good!';

  @override
  String get moodGreat => 'I feel great!';

  @override
  String get moodScaleVeryLow => 'Very low';

  @override
  String get moodScaleLow => 'Low';

  @override
  String get moodScaleNormal => 'Normal';

  @override
  String get moodScaleGood => 'Good';

  @override
  String get moodScaleGreat => 'Great';

  @override
  String get moodQuestion => 'How are you feeling?';

  @override
  String get moodInstruction =>
      'Move along the scale or tap an icon to log how you feel right now.';

  @override
  String moodSaved(Object mood) {
    return 'Saved: $mood';
  }

  @override
  String get moodSaveButton => 'Save mood';

  @override
  String get sessionActivityTitle => 'Session activity';

  @override
  String get sessionActivitySubtitle =>
      'Add a snapshot and a short note about your focus session.';

  @override
  String get shareActivitySnack => 'Share activity';

  @override
  String get shareThisActivity => 'Share this activity';

  @override
  String get mediaSection => 'Media';

  @override
  String get photoOrVideo => 'Photo or video';

  @override
  String get optionalTapMedia => 'Optional — tap the area to attach media.';

  @override
  String get removeTooltip => 'Remove';

  @override
  String get tapToAddMedia => 'Tap to add media';

  @override
  String get sampleImageAttached => 'Sample image attached';

  @override
  String get notesSection => 'Notes';

  @override
  String get reflectionTitle => 'Reflection';

  @override
  String get reflectionPrompt => 'What stood out during this session?';

  @override
  String get reflectionHint => 'Write a short reflection…';

  @override
  String get saveSession => 'Save session';

  @override
  String get sessionSavedWithoutMedia => 'Session saved without media.';

  @override
  String get sessionSavedWithPhoto => 'Session saved with photo.';

  @override
  String get sessionSavedWithoutMediaNote =>
      'Session saved without media. Note recorded.';

  @override
  String get sessionSavedWithPhotoNote =>
      'Session saved with photo. Note recorded.';

  @override
  String get sessionActivityAppBar => 'Session Activity';

  @override
  String get backButtonPressed => 'Back button pressed!';

  @override
  String navItemTapped(Object index) {
    return 'Tapped item: $index';
  }

  @override
  String bottomNavTapped(Object index) {
    return 'Bottom nav item tapped: $index';
  }

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsSubtitle => 'Reminders & alerts';

  @override
  String get settingsAccountGroup => 'Account';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsPrivacySubtitle => 'Data & visibility';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsSecuritySubtitle => 'Devices & sign-in';

  @override
  String get settingsChangePassword => 'Change password';

  @override
  String get settingsChangePasswordSubtitle => 'Update your password';

  @override
  String get settingsDataSharing => 'Data & sharing';

  @override
  String get settingsExportImport => 'Export / import';

  @override
  String get settingsExportImportSubtitle => 'Backup your progress';

  @override
  String get settingsShareCity => 'Share city';

  @override
  String get settingsShareCitySubtitle => 'Post your city to social';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsVersionSubtitle => 'Build & updates';

  @override
  String get settingsHelpSupport => 'Help & support';

  @override
  String get settingsHelpSubtitle => 'FAQs & contact';

  @override
  String get accountAndProfile => 'Account & profile';

  @override
  String get noAccountLoaded => 'No account loaded';

  @override
  String get signInFromWelcome =>
      'Sign in from the welcome screen, or continue below.';

  @override
  String get settingsSnackPrivacy => 'Privacy settings';

  @override
  String get settingsSnackSecurity => 'Security settings';

  @override
  String get settingsSnackChangePassword => 'Change password';

  @override
  String get settingsSnackBuild => 'Build 1.0.0';

  @override
  String get settingsSnackHelp => 'Help & support';

  @override
  String get buildVersionLabel => '1.0.0';

  @override
  String get accountPageTitle => 'Account';

  @override
  String get accountNoUser => 'No account loaded';

  @override
  String get accountPlaceholderBody =>
      'Profile editing and linked sign-in methods can ship in a later build.';

  @override
  String get notificationsPageTitle => 'Notifications';

  @override
  String get notificationFocusReminders => 'Focus session reminders';

  @override
  String get notificationFocusRemindersSubtitle =>
      'Nudge before a scheduled session';

  @override
  String get notificationWeeklySummary => 'Weekly summary';

  @override
  String get notificationWeeklySummarySubtitle => 'XP and streak highlights';

  @override
  String get notificationPermissionNote =>
      'System permission for alerts is still required on device builds.';

  @override
  String get exportImportPageTitle => 'Export / import';

  @override
  String get exportImportBody =>
      'Back up your city layout and progress to a file, or restore from a backup. File I/O will be wired when persistence is finalized.';

  @override
  String get exportStarted => 'Export started';

  @override
  String get importStarted => 'Import started';

  @override
  String get exportBackupButton => 'Export backup';

  @override
  String get importBackupButton => 'Import backup';

  @override
  String get shareCityPageTitle => 'Share city';

  @override
  String get shareCityBody =>
      'Share a snapshot or invite friends to see your Focus City. Native share sheet integration can be added for mobile.';

  @override
  String get shareOpened => 'Share opened';

  @override
  String get shareButton => 'Share';

  @override
  String staffHelloName(Object name) {
    return 'Hello, $name';
  }

  @override
  String get staffOverviewIntro =>
      'This overview shows directory-wide metrics and sample weekly trends. Connect to your backend when ready.';

  @override
  String get staffOverviewSection => 'Overview';

  @override
  String get staffRegistered => 'Registered';

  @override
  String get staffActiveStatus => 'Active (status)';

  @override
  String get staffFocusMinutesCohortWeek =>
      'Focus minutes (this week · cohort)';

  @override
  String get staffAllUsersChartTitle =>
      'All users — focus minutes (sample week)';

  @override
  String get staffUserId => 'User ID';

  @override
  String get staffLastActive => 'Last active';

  @override
  String get staffFocusThisWeek => 'Focus (this week)';

  @override
  String get staffStatus => 'Status';

  @override
  String get staffSearchHint => 'Search name, email, or ID';

  @override
  String get closeLabel => 'Close';

  @override
  String get staffSettingsPreferences => 'Preferences';

  @override
  String get staffPushNotifications => 'Push notifications';

  @override
  String get staffPushNotificationsSubtitle =>
      'Receive account and system alerts.';

  @override
  String get staffWeeklyDigestEmail => 'Weekly digest email';

  @override
  String get staffWeeklyDigestEmailSubtitle =>
      'Summary of user activity and trends.';

  @override
  String get staffCompactUserList => 'Compact user list';

  @override
  String get staffCompactUserListSubtitle =>
      'Display denser rows in User directory.';

  @override
  String get staffSupportSection => 'Support';

  @override
  String get staffHelpCenter => 'Help center';

  @override
  String get staffHelpCenterSubtitle => 'Guides for staff workflows.';

  @override
  String get staffPrivacyDataPolicy => 'Privacy & data policy';

  @override
  String get staffPrivacyDataPolicySubtitle =>
      'Review data handling and access scope.';

  @override
  String get staffContactAdministrator => 'Contact administrator';

  @override
  String get staffContactAdministratorSubtitle =>
      'Report access or data issues.';

  @override
  String get staffRoleLabel => 'Role: Staff';

  @override
  String get userRoleLabel => 'Role: User';
}
