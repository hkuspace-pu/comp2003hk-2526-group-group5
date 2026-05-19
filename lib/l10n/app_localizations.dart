import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'HK'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen time'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Grow your focus. Build your city.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Focus time, build your city'**
  String get welcomeTagline;

  /// No description provided for @bulletFocus.
  ///
  /// In en, this message translates to:
  /// **'Stay on task with focus sessions'**
  String get bulletFocus;

  /// No description provided for @bulletMood.
  ///
  /// In en, this message translates to:
  /// **'Log mood and see your patterns'**
  String get bulletMood;

  /// No description provided for @bulletDashboard.
  ///
  /// In en, this message translates to:
  /// **'Track progress on your dashboard'**
  String get bulletDashboard;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @welcomeFooter.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account to save your city and stats.'**
  String get welcomeFooter;

  /// No description provided for @staffPortalLink.
  ///
  /// In en, this message translates to:
  /// **'Staff portal'**
  String get staffPortalLink;

  /// No description provided for @staffPortalTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff portal'**
  String get staffPortalTitle;

  /// No description provided for @staffPortalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For staff · manage and view user data'**
  String get staffPortalSubtitle;

  /// No description provided for @staffPortalBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your staff account to open the dashboard and user directory.'**
  String get staffPortalBody;

  /// No description provided for @staffBullet1.
  ///
  /// In en, this message translates to:
  /// **'Overview: engagement and focus trends'**
  String get staffBullet1;

  /// No description provided for @staffBullet2.
  ///
  /// In en, this message translates to:
  /// **'User directory: search and open profiles'**
  String get staffBullet2;

  /// No description provided for @staffBullet3.
  ///
  /// In en, this message translates to:
  /// **'Restricted to authorised staff accounts'**
  String get staffBullet3;

  /// No description provided for @backToStudentApp.
  ///
  /// In en, this message translates to:
  /// **'Back to User portal'**
  String get backToStudentApp;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App display language'**
  String get settingsLanguageSubtitle;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get languagePickerTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageCantonese.
  ///
  /// In en, this message translates to:
  /// **'Cantonese (Traditional)'**
  String get languageCantonese;

  /// No description provided for @msgEnterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password.'**
  String get msgEnterEmailPassword;

  /// No description provided for @msgEnterWorkEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter work email and password.'**
  String get msgEnterWorkEmailPassword;

  /// No description provided for @msgEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid-looking email.'**
  String get msgEnterValidEmail;

  /// No description provided for @msgGoogleUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in is not available yet.'**
  String get msgGoogleUnavailable;

  /// No description provided for @msgEmailPasswordFilled.
  ///
  /// In en, this message translates to:
  /// **'Email and password filled.'**
  String get msgEmailPasswordFilled;

  /// No description provided for @msgFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get msgFillAllFields;

  /// No description provided for @msgPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get msgPasswordMismatch;

  /// No description provided for @msgAcceptPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Please accept the privacy policy to sign up.'**
  String get msgAcceptPrivacy;

  /// No description provided for @msgEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get msgEnterYourEmail;

  /// No description provided for @loginNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get loginNowTitle;

  /// No description provided for @authContinueHint.
  ///
  /// In en, this message translates to:
  /// **'Please login or sign up to continue using our app'**
  String get authContinueHint;

  /// No description provided for @sampleAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Sample account'**
  String get sampleAccountTitle;

  /// No description provided for @sampleAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Use this sample account for quick sign-in.'**
  String get sampleAccountHint;

  /// No description provided for @fillFields.
  ///
  /// In en, this message translates to:
  /// **'Fill fields'**
  String get fillFields;

  /// No description provided for @quickSignIn.
  ///
  /// In en, this message translates to:
  /// **'Quick sign in'**
  String get quickSignIn;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @enterEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @enterPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPasswordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccountPrompt;

  /// No description provided for @userNameLabel.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userNameLabel;

  /// No description provided for @enterUserNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your user name'**
  String get enterUserNameHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @agreePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'I agree with the privacy policy'**
  String get agreePrivacyPolicy;

  /// No description provided for @readFullPolicy.
  ///
  /// In en, this message translates to:
  /// **'Read full policy'**
  String get readFullPolicy;

  /// No description provided for @haveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'You already have an account? '**
  String get haveAccountPrompt;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the email for your account. In a real app we would send a reset link — this screen is layout only.'**
  String get resetPasswordHint;

  /// No description provided for @emailExampleHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailExampleHint;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get sendResetLink;

  /// No description provided for @passwordResetUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Password reset is not available yet for {email}.'**
  String passwordResetUnavailable(Object email);

  /// No description provided for @staffWorkAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Work account'**
  String get staffWorkAccountTitle;

  /// No description provided for @staffWorkAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Use your staff email to access the dashboard and user directory.'**
  String get staffWorkAccountHint;

  /// No description provided for @staffDemoAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo staff account'**
  String get staffDemoAccountTitle;

  /// No description provided for @staffDemoAccountHint.
  ///
  /// In en, this message translates to:
  /// **'One tap to fill the demo credentials, or quick sign in.'**
  String get staffDemoAccountHint;

  /// No description provided for @staffWorkEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Work email'**
  String get staffWorkEmailLabel;

  /// No description provided for @staffLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff sign in'**
  String get staffLoginTitle;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @msgAcceptStaffTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept staff account terms.'**
  String get msgAcceptStaffTerms;

  /// No description provided for @staffAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff account'**
  String get staffAccountTitle;

  /// No description provided for @staffRegisterHint.
  ///
  /// In en, this message translates to:
  /// **'Register to access overview, user directory, and settings.'**
  String get staffRegisterHint;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @staffAuthorizedConfirm.
  ///
  /// In en, this message translates to:
  /// **'I confirm this is an authorised staff account.'**
  String get staffAuthorizedConfirm;

  /// No description provided for @signOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutConfirmTitle;

  /// No description provided for @signOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You will return to the welcome screen.'**
  String get signOutConfirmBody;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @signOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutLabel;

  /// No description provided for @staffOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff overview'**
  String get staffOverviewTitle;

  /// No description provided for @staffUserDirectoryTitle.
  ///
  /// In en, this message translates to:
  /// **'User directory'**
  String get staffUserDirectoryTitle;

  /// No description provided for @settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsLabel;

  /// No description provided for @dashboardLabel.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardLabel;

  /// No description provided for @usersLabel.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersLabel;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicyTitle;

  /// No description provided for @lastUpdatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdatedLabel;

  /// No description provided for @privacyWhatWeCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'What we collect'**
  String get privacyWhatWeCollectTitle;

  /// No description provided for @privacyWhatWeCollectBody.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide in the app, such as account email, mood logs, and focus session records, to support core features and improve your experience.'**
  String get privacyWhatWeCollectBody;

  /// No description provided for @privacyHowWeUseItTitle.
  ///
  /// In en, this message translates to:
  /// **'How we use it'**
  String get privacyHowWeUseItTitle;

  /// No description provided for @privacyHowWeUseItBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is used to show your dashboard, help sync your experience across supported devices, and maintain app features related to productivity and wellbeing.'**
  String get privacyHowWeUseItBody;

  /// No description provided for @privacyYourChoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your choices'**
  String get privacyYourChoicesTitle;

  /// No description provided for @privacyYourChoicesBody.
  ///
  /// In en, this message translates to:
  /// **'You can export or delete data from Settings when those screens are wired. This page exists so the sign-up checkbox has somewhere to link.'**
  String get privacyYourChoicesBody;

  /// No description provided for @leaveAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave app?'**
  String get leaveAppTitle;

  /// No description provided for @leaveAppButton.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveAppButton;

  /// No description provided for @backToWelcomeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back to welcome'**
  String get backToWelcomeTooltip;

  /// No description provided for @shellTitleBuildCity.
  ///
  /// In en, this message translates to:
  /// **'Build Your City'**
  String get shellTitleBuildCity;

  /// No description provided for @shellTitleMoodLog.
  ///
  /// In en, this message translates to:
  /// **'Mood log'**
  String get shellTitleMoodLog;

  /// No description provided for @shellTitleActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get shellTitleActivity;

  /// No description provided for @tabFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get tabFocus;

  /// No description provided for @tabMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get tabMood;

  /// No description provided for @tabActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get tabActivity;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get yourProgress;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelLabel;

  /// No description provided for @totalXpLabel.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get totalXpLabel;

  /// No description provided for @overviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewLabel;

  /// No description provided for @todaySegment.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todaySegment;

  /// No description provided for @weekSegment.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get weekSegment;

  /// No description provided for @calendarLabel.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarLabel;

  /// No description provided for @calendarHint.
  ///
  /// In en, this message translates to:
  /// **'Use arrows to change month. Tap a day to see its summary.'**
  String get calendarHint;

  /// No description provided for @todaysSummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s summary'**
  String get todaysSummary;

  /// No description provided for @focusTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus time'**
  String get focusTimeLabel;

  /// No description provided for @sessionsCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Sessions completed'**
  String get sessionsCompletedLabel;

  /// No description provided for @moodCheckInsLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood check-ins'**
  String get moodCheckInsLabel;

  /// No description provided for @xpGainedTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'XP gained today'**
  String get xpGainedTodayLabel;

  /// No description provided for @weekFocusMinutesTitle.
  ///
  /// In en, this message translates to:
  /// **'This week — focus minutes'**
  String get weekFocusMinutesTitle;

  /// No description provided for @daySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Day summary'**
  String get daySummaryTitle;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @dayStatFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get dayStatFocus;

  /// No description provided for @dayStatSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get dayStatSessions;

  /// No description provided for @statPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get statPlaceholder;

  /// No description provided for @focusMinutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String focusMinutesValue(Object minutes);

  /// No description provided for @weekChartDayLabels.
  ///
  /// In en, this message translates to:
  /// **'M,T,W,T,F,S,S'**
  String get weekChartDayLabels;

  /// No description provided for @unlockNextAtItem.
  ///
  /// In en, this message translates to:
  /// **'NEXT UNLOCK AT {xp} XP: {label} • {description}'**
  String unlockNextAtItem(Object xp, Object label, Object description);

  /// No description provided for @unlockNextAtLevel.
  ///
  /// In en, this message translates to:
  /// **'NEXT UNLOCK AT {xp} XP: Level {level}'**
  String unlockNextAtLevel(Object xp, Object level);

  /// No description provided for @unlockAllDone.
  ///
  /// In en, this message translates to:
  /// **'All items unlocked and maximum level achieved!'**
  String get unlockAllDone;

  /// No description provided for @itemTree.
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get itemTree;

  /// No description provided for @itemPark.
  ///
  /// In en, this message translates to:
  /// **'Park'**
  String get itemPark;

  /// No description provided for @itemHouse.
  ///
  /// In en, this message translates to:
  /// **'House'**
  String get itemHouse;

  /// No description provided for @itemBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get itemBuilding;

  /// No description provided for @itemRoad.
  ///
  /// In en, this message translates to:
  /// **'Road'**
  String get itemRoad;

  /// No description provided for @itemRiver.
  ///
  /// In en, this message translates to:
  /// **'River'**
  String get itemRiver;

  /// No description provided for @itemBridge.
  ///
  /// In en, this message translates to:
  /// **'Bridge'**
  String get itemBridge;

  /// No description provided for @itemDescTree.
  ///
  /// In en, this message translates to:
  /// **'Adds natural beauty to your city'**
  String get itemDescTree;

  /// No description provided for @itemDescPark.
  ///
  /// In en, this message translates to:
  /// **'A green space for relaxation and play'**
  String get itemDescPark;

  /// No description provided for @itemDescHouse.
  ///
  /// In en, this message translates to:
  /// **'Provides shelter for citizens'**
  String get itemDescHouse;

  /// No description provided for @itemDescBuilding.
  ///
  /// In en, this message translates to:
  /// **'A tall structure to mark your progress'**
  String get itemDescBuilding;

  /// No description provided for @itemDescRoad.
  ///
  /// In en, this message translates to:
  /// **'Connects your city\'s areas'**
  String get itemDescRoad;

  /// No description provided for @itemDescRiver.
  ///
  /// In en, this message translates to:
  /// **'A flowing waterway for scenic beauty'**
  String get itemDescRiver;

  /// No description provided for @itemDescBridge.
  ///
  /// In en, this message translates to:
  /// **'Spans over rivers and gaps'**
  String get itemDescBridge;

  /// No description provided for @xpAmount.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP'**
  String xpAmount(Object xp);

  /// No description provided for @levelXpLine.
  ///
  /// In en, this message translates to:
  /// **'Level {level} · {xp} XP'**
  String levelXpLine(Object level, Object xp);

  /// No description provided for @focusCityProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S CITY PROGRESS'**
  String get focusCityProgressTitle;

  /// No description provided for @focusCityProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build your city with each focus session'**
  String get focusCityProgressSubtitle;

  /// No description provided for @focusCompletedXp.
  ///
  /// In en, this message translates to:
  /// **'Completed! +{xp} XP!'**
  String focusCompletedXp(Object xp);

  /// No description provided for @placeItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Place items'**
  String get placeItemsTitle;

  /// No description provided for @pauseDragHint.
  ///
  /// In en, this message translates to:
  /// **'Pause or finish focus to drag'**
  String get pauseDragHint;

  /// No description provided for @placeLabel.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get placeLabel;

  /// No description provided for @pausePlaceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Pause or finish focus to place on the city'**
  String get pausePlaceTooltip;

  /// No description provided for @demoOn.
  ///
  /// In en, this message translates to:
  /// **'Demo on'**
  String get demoOn;

  /// No description provided for @demo.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get demo;

  /// No description provided for @endFocusSession.
  ///
  /// In en, this message translates to:
  /// **'END FOCUS SESSION'**
  String get endFocusSession;

  /// No description provided for @startFocusSessionMinutes.
  ///
  /// In en, this message translates to:
  /// **'START {minutes}-MIN FOCUS SESSION'**
  String startFocusSessionMinutes(Object minutes);

  /// No description provided for @resetCityProgress.
  ///
  /// In en, this message translates to:
  /// **'Reset city progress'**
  String get resetCityProgress;

  /// No description provided for @focusCityAppBar.
  ///
  /// In en, this message translates to:
  /// **'Focus City'**
  String get focusCityAppBar;

  /// No description provided for @focusSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus session'**
  String get focusSessionTitle;

  /// No description provided for @editLengthTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit length'**
  String get editLengthTooltip;

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startLabel;

  /// No description provided for @pauseLabel.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseLabel;

  /// No description provided for @resumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resumeLabel;

  /// No description provided for @finishLabel.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishLabel;

  /// No description provided for @sessionEndedEarlyNoXp.
  ///
  /// In en, this message translates to:
  /// **'Session ended early (no completion XP).'**
  String get sessionEndedEarlyNoXp;

  /// No description provided for @editFocusLength.
  ///
  /// In en, this message translates to:
  /// **'Edit focus length'**
  String get editFocusLength;

  /// No description provided for @setSessionLengthHint.
  ///
  /// In en, this message translates to:
  /// **'Set session length in minutes (1–180).'**
  String get setSessionLengthHint;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutesLabel;

  /// No description provided for @minSuffix.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minSuffix;

  /// No description provided for @minutesRangeHint.
  ///
  /// In en, this message translates to:
  /// **'1–180'**
  String get minutesRangeHint;

  /// No description provided for @applyLabel.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyLabel;

  /// No description provided for @moodLoggingTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Logging'**
  String get moodLoggingTitle;

  /// No description provided for @moodVerySad.
  ///
  /// In en, this message translates to:
  /// **'I feel very sad!'**
  String get moodVerySad;

  /// No description provided for @moodBitDown.
  ///
  /// In en, this message translates to:
  /// **'I feel a bit down!'**
  String get moodBitDown;

  /// No description provided for @moodNormal.
  ///
  /// In en, this message translates to:
  /// **'I feel normal!'**
  String get moodNormal;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'I feel good!'**
  String get moodGood;

  /// No description provided for @moodGreat.
  ///
  /// In en, this message translates to:
  /// **'I feel great!'**
  String get moodGreat;

  /// No description provided for @moodScaleVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very low'**
  String get moodScaleVeryLow;

  /// No description provided for @moodScaleLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get moodScaleLow;

  /// No description provided for @moodScaleNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get moodScaleNormal;

  /// No description provided for @moodScaleGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodScaleGood;

  /// No description provided for @moodScaleGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodScaleGreat;

  /// No description provided for @moodQuestion.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get moodQuestion;

  /// No description provided for @moodInstruction.
  ///
  /// In en, this message translates to:
  /// **'Move along the scale or tap an icon to log how you feel right now.'**
  String get moodInstruction;

  /// No description provided for @moodSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved: {mood}'**
  String moodSaved(Object mood);

  /// No description provided for @moodSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save mood'**
  String get moodSaveButton;

  /// No description provided for @sessionActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Session activity'**
  String get sessionActivityTitle;

  /// No description provided for @sessionActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a snapshot and a short note about your focus session.'**
  String get sessionActivitySubtitle;

  /// No description provided for @shareActivitySnack.
  ///
  /// In en, this message translates to:
  /// **'Share activity'**
  String get shareActivitySnack;

  /// No description provided for @shareThisActivity.
  ///
  /// In en, this message translates to:
  /// **'Share this activity'**
  String get shareThisActivity;

  /// No description provided for @mediaSection.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get mediaSection;

  /// No description provided for @photoOrVideo.
  ///
  /// In en, this message translates to:
  /// **'Photo or video'**
  String get photoOrVideo;

  /// No description provided for @optionalTapMedia.
  ///
  /// In en, this message translates to:
  /// **'Optional — tap the area to attach media.'**
  String get optionalTapMedia;

  /// No description provided for @removeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeTooltip;

  /// No description provided for @tapToAddMedia.
  ///
  /// In en, this message translates to:
  /// **'Tap to add media'**
  String get tapToAddMedia;

  /// No description provided for @sampleImageAttached.
  ///
  /// In en, this message translates to:
  /// **'Sample image attached'**
  String get sampleImageAttached;

  /// No description provided for @notesSection.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesSection;

  /// No description provided for @reflectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reflection'**
  String get reflectionTitle;

  /// No description provided for @reflectionPrompt.
  ///
  /// In en, this message translates to:
  /// **'What stood out during this session?'**
  String get reflectionPrompt;

  /// No description provided for @reflectionHint.
  ///
  /// In en, this message translates to:
  /// **'Write a short reflection…'**
  String get reflectionHint;

  /// No description provided for @saveSession.
  ///
  /// In en, this message translates to:
  /// **'Save session'**
  String get saveSession;

  /// No description provided for @sessionSavedWithoutMedia.
  ///
  /// In en, this message translates to:
  /// **'Session saved without media.'**
  String get sessionSavedWithoutMedia;

  /// No description provided for @sessionSavedWithPhoto.
  ///
  /// In en, this message translates to:
  /// **'Session saved with photo.'**
  String get sessionSavedWithPhoto;

  /// No description provided for @sessionSavedWithoutMediaNote.
  ///
  /// In en, this message translates to:
  /// **'Session saved without media. Note recorded.'**
  String get sessionSavedWithoutMediaNote;

  /// No description provided for @sessionSavedWithPhotoNote.
  ///
  /// In en, this message translates to:
  /// **'Session saved with photo. Note recorded.'**
  String get sessionSavedWithPhotoNote;

  /// No description provided for @sessionActivityAppBar.
  ///
  /// In en, this message translates to:
  /// **'Session Activity'**
  String get sessionActivityAppBar;

  /// No description provided for @backButtonPressed.
  ///
  /// In en, this message translates to:
  /// **'Back button pressed!'**
  String get backButtonPressed;

  /// No description provided for @navItemTapped.
  ///
  /// In en, this message translates to:
  /// **'Tapped item: {index}'**
  String navItemTapped(Object index);

  /// No description provided for @bottomNavTapped.
  ///
  /// In en, this message translates to:
  /// **'Bottom nav item tapped: {index}'**
  String bottomNavTapped(Object index);

  /// No description provided for @settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders & alerts'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsAccountGroup.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountGroup;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Data & visibility'**
  String get settingsPrivacySubtitle;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Devices & sign-in'**
  String get settingsSecuritySubtitle;

  /// No description provided for @settingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingsChangePassword;

  /// No description provided for @settingsChangePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your password'**
  String get settingsChangePasswordSubtitle;

  /// No description provided for @settingsDataSharing.
  ///
  /// In en, this message translates to:
  /// **'Data & sharing'**
  String get settingsDataSharing;

  /// No description provided for @settingsExportImport.
  ///
  /// In en, this message translates to:
  /// **'Export / import'**
  String get settingsExportImport;

  /// No description provided for @settingsExportImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Backup your progress'**
  String get settingsExportImportSubtitle;

  /// No description provided for @settingsShareCity.
  ///
  /// In en, this message translates to:
  /// **'Share city'**
  String get settingsShareCity;

  /// No description provided for @settingsShareCitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Post your city to social'**
  String get settingsShareCitySubtitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsVersionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build & updates'**
  String get settingsVersionSubtitle;

  /// No description provided for @settingsHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get settingsHelpSupport;

  /// No description provided for @settingsHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs & contact'**
  String get settingsHelpSubtitle;

  /// No description provided for @accountAndProfile.
  ///
  /// In en, this message translates to:
  /// **'Account & profile'**
  String get accountAndProfile;

  /// No description provided for @noAccountLoaded.
  ///
  /// In en, this message translates to:
  /// **'No account loaded'**
  String get noAccountLoaded;

  /// No description provided for @signInFromWelcome.
  ///
  /// In en, this message translates to:
  /// **'Sign in from the welcome screen, or continue below.'**
  String get signInFromWelcome;

  /// No description provided for @settingsSnackPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy settings'**
  String get settingsSnackPrivacy;

  /// No description provided for @settingsSnackSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security settings'**
  String get settingsSnackSecurity;

  /// No description provided for @settingsSnackChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settingsSnackChangePassword;

  /// No description provided for @settingsSnackBuild.
  ///
  /// In en, this message translates to:
  /// **'Build 1.0.0'**
  String get settingsSnackBuild;

  /// No description provided for @settingsSnackHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get settingsSnackHelp;

  /// No description provided for @buildVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get buildVersionLabel;

  /// No description provided for @accountPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountPageTitle;

  /// No description provided for @accountNoUser.
  ///
  /// In en, this message translates to:
  /// **'No account loaded'**
  String get accountNoUser;

  /// No description provided for @accountPlaceholderBody.
  ///
  /// In en, this message translates to:
  /// **'Profile editing and linked sign-in methods can ship in a later build.'**
  String get accountPlaceholderBody;

  /// No description provided for @notificationsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsPageTitle;

  /// No description provided for @notificationFocusReminders.
  ///
  /// In en, this message translates to:
  /// **'Focus session reminders'**
  String get notificationFocusReminders;

  /// No description provided for @notificationFocusRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nudge before a scheduled session'**
  String get notificationFocusRemindersSubtitle;

  /// No description provided for @notificationWeeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly summary'**
  String get notificationWeeklySummary;

  /// No description provided for @notificationWeeklySummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'XP and streak highlights'**
  String get notificationWeeklySummarySubtitle;

  /// No description provided for @notificationPermissionNote.
  ///
  /// In en, this message translates to:
  /// **'System permission for alerts is still required on device builds.'**
  String get notificationPermissionNote;

  /// No description provided for @exportImportPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Export / import'**
  String get exportImportPageTitle;

  /// No description provided for @exportImportBody.
  ///
  /// In en, this message translates to:
  /// **'Back up your city layout and progress to a file, or restore from a backup. File I/O will be wired when persistence is finalized.'**
  String get exportImportBody;

  /// No description provided for @exportStarted.
  ///
  /// In en, this message translates to:
  /// **'Export started'**
  String get exportStarted;

  /// No description provided for @importStarted.
  ///
  /// In en, this message translates to:
  /// **'Import started'**
  String get importStarted;

  /// No description provided for @exportBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get exportBackupButton;

  /// No description provided for @importBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get importBackupButton;

  /// No description provided for @shareCityPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Share city'**
  String get shareCityPageTitle;

  /// No description provided for @shareCityBody.
  ///
  /// In en, this message translates to:
  /// **'Share a snapshot or invite friends to see your Focus City. Native share sheet integration can be added for mobile.'**
  String get shareCityBody;

  /// No description provided for @shareOpened.
  ///
  /// In en, this message translates to:
  /// **'Share opened'**
  String get shareOpened;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @staffHelloName.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String staffHelloName(Object name);

  /// No description provided for @staffOverviewIntro.
  ///
  /// In en, this message translates to:
  /// **'This overview shows directory-wide metrics and sample weekly trends. Connect to your backend when ready.'**
  String get staffOverviewIntro;

  /// No description provided for @staffOverviewSection.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get staffOverviewSection;

  /// No description provided for @staffRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get staffRegistered;

  /// No description provided for @staffActiveStatus.
  ///
  /// In en, this message translates to:
  /// **'Active (status)'**
  String get staffActiveStatus;

  /// No description provided for @staffFocusMinutesCohortWeek.
  ///
  /// In en, this message translates to:
  /// **'Focus minutes (this week · cohort)'**
  String get staffFocusMinutesCohortWeek;

  /// No description provided for @staffAllUsersChartTitle.
  ///
  /// In en, this message translates to:
  /// **'All users — focus minutes (sample week)'**
  String get staffAllUsersChartTitle;

  /// No description provided for @staffUserId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get staffUserId;

  /// No description provided for @staffLastActive.
  ///
  /// In en, this message translates to:
  /// **'Last active'**
  String get staffLastActive;

  /// No description provided for @staffFocusThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Focus (this week)'**
  String get staffFocusThisWeek;

  /// No description provided for @staffStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get staffStatus;

  /// No description provided for @staffSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, email, or ID'**
  String get staffSearchHint;

  /// No description provided for @closeLabel.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeLabel;

  /// No description provided for @staffSettingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get staffSettingsPreferences;

  /// No description provided for @staffPushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get staffPushNotifications;

  /// No description provided for @staffPushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive account and system alerts.'**
  String get staffPushNotificationsSubtitle;

  /// No description provided for @staffWeeklyDigestEmail.
  ///
  /// In en, this message translates to:
  /// **'Weekly digest email'**
  String get staffWeeklyDigestEmail;

  /// No description provided for @staffWeeklyDigestEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Summary of user activity and trends.'**
  String get staffWeeklyDigestEmailSubtitle;

  /// No description provided for @staffCompactUserList.
  ///
  /// In en, this message translates to:
  /// **'Compact user list'**
  String get staffCompactUserList;

  /// No description provided for @staffCompactUserListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display denser rows in User directory.'**
  String get staffCompactUserListSubtitle;

  /// No description provided for @staffSupportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get staffSupportSection;

  /// No description provided for @staffHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help center'**
  String get staffHelpCenter;

  /// No description provided for @staffHelpCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Guides for staff workflows.'**
  String get staffHelpCenterSubtitle;

  /// No description provided for @staffPrivacyDataPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & data policy'**
  String get staffPrivacyDataPolicy;

  /// No description provided for @staffPrivacyDataPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review data handling and access scope.'**
  String get staffPrivacyDataPolicySubtitle;

  /// No description provided for @staffContactAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Contact administrator'**
  String get staffContactAdministrator;

  /// No description provided for @staffContactAdministratorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report access or data issues.'**
  String get staffContactAdministratorSubtitle;

  /// No description provided for @staffRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role: Staff'**
  String get staffRoleLabel;

  /// No description provided for @userRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role: User'**
  String get userRoleLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'HK':
            return AppLocalizationsZhHk();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
