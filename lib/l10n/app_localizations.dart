import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'GlucoCare'**
  String get appTitle;

  /// Title for the dashboard page showing today''s schedule
  ///
  /// In en, this message translates to:
  /// **'Today\'\'s Medications'**
  String get dashboardTitle;

  /// Button text to add a new medication
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// Title for the edit medication page
  ///
  /// In en, this message translates to:
  /// **'Edit Medication'**
  String get editMedication;

  /// Title for the medication history page
  ///
  /// In en, this message translates to:
  /// **'Medication History'**
  String get medicationHistory;

  /// Message shown when there are no medications for the day
  ///
  /// In en, this message translates to:
  /// **'No medications scheduled for today.'**
  String get noMedicationsScheduled;

  /// Status text indicating a medication was taken
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get taken;

  /// Button text to mark a medication as taken
  ///
  /// In en, this message translates to:
  /// **'Take'**
  String get take;

  /// Label for the medication name input field
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// Label for the medication dosage input field
  ///
  /// In en, this message translates to:
  /// **'Dosage (e.g., 500mg, 1 tablet)'**
  String get dosageExample;

  /// Label for the medication type dropdown
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Label for selecting the medication schedule time
  ///
  /// In en, this message translates to:
  /// **'Schedule Time'**
  String get scheduleTime;

  /// Button text to save the new medication
  ///
  /// In en, this message translates to:
  /// **'Save Medication'**
  String get saveMedication;

  /// Button text to open the time picker
  ///
  /// In en, this message translates to:
  /// **'Pick Time'**
  String get pickTime;

  /// Message shown when no schedule time is selected
  ///
  /// In en, this message translates to:
  /// **'No time selected'**
  String get noTimeSelected;

  /// Validation message when trying to save without a time
  ///
  /// In en, this message translates to:
  /// **'Please select a schedule time'**
  String get pleaseSelectTime;

  /// Validation message when name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter medication name'**
  String get enterMedicationName;

  /// Validation message when dosage is empty
  ///
  /// In en, this message translates to:
  /// **'Enter dosage'**
  String get enterDosage;

  /// Button text for login action
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Title and button text for creating a new account
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Label for email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for name input field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Header text showing the selected date for history
  ///
  /// In en, this message translates to:
  /// **'Showing history for:'**
  String get showingHistoryFor;

  /// Message shown when no history is found for the date
  ///
  /// In en, this message translates to:
  /// **'No medications recorded on this date.'**
  String get noMedicationsRecorded;

  /// Label prefix for the medication ID
  ///
  /// In en, this message translates to:
  /// **'Medication ID:'**
  String get medicationId;

  /// Label prefix for the time the medication was taken
  ///
  /// In en, this message translates to:
  /// **'Taken at:'**
  String get takenAt;

  /// Status indicating medication was taken on time
  ///
  /// In en, this message translates to:
  /// **'On Time'**
  String get onTime;

  /// Status indicating medication was taken late
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get late;

  /// Error message when history fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get failedToLoadHistory;

  /// Greeting message
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// Label for daily progress
  ///
  /// In en, this message translates to:
  /// **'Daily Progress'**
  String get dailyProgress;

  /// Label for today's doses
  ///
  /// In en, this message translates to:
  /// **'Today\'s Doses'**
  String get todaysDoses;

  /// Button text to view all items
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Title for lab tests section
  ///
  /// In en, this message translates to:
  /// **'Lab Tests'**
  String get labTests;

  /// Message shown when no lab tests are available
  ///
  /// In en, this message translates to:
  /// **'No lab tests yet'**
  String get noLabTests;

  /// Instruction to add the first lab test
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first test result'**
  String get tapToRecordTest;

  /// Button text to add a lab test
  ///
  /// In en, this message translates to:
  /// **'Add Lab Test'**
  String get addLabTest;

  /// Label for test name
  ///
  /// In en, this message translates to:
  /// **'Test Name'**
  String get testName;

  /// Label for test result
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// Label for test unit
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// Label for test reference range
  ///
  /// In en, this message translates to:
  /// **'Reference Range'**
  String get referenceRange;

  /// Label for test category
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Success message when a lab test is added
  ///
  /// In en, this message translates to:
  /// **'Lab test added successfully.'**
  String get labTestAdded;

  /// Button text to cancel an action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button text to add an item
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// Button text to retry an action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Title for the medications section
  ///
  /// In en, this message translates to:
  /// **'My Medications'**
  String get myMedications;

  /// Subtext for medication schedule setup
  ///
  /// In en, this message translates to:
  /// **'Setup your medication schedule'**
  String get setupMedicationSchedule;

  /// Label for intake timing
  ///
  /// In en, this message translates to:
  /// **'Intake Timing'**
  String get intakeTiming;

  /// Hint text for unit input
  ///
  /// In en, this message translates to:
  /// **'Unit (e.g., mg, ml)'**
  String get unitHint;

  /// Validation message for missing unit
  ///
  /// In en, this message translates to:
  /// **'Please enter unit'**
  String get enterUnit;

  /// Label for notes field
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Success message when medication is updated
  ///
  /// In en, this message translates to:
  /// **'Medication updated!'**
  String get medicationUpdated;

  /// Title for updating medication details
  ///
  /// In en, this message translates to:
  /// **'Update your medication details'**
  String get updateMedicationDetails;

  /// Title for the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for account information section
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// Label for notifications settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Label for privacy and security settings
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Button text to log out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Label for user name
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// Label for English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Dialog text to confirm logging out
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogout;

  /// Label for theme settings
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Label for selecting a theme
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// Label for system default theme
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Label for light theme
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Label for dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Label for Arabic language
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// Greeting message with name
  ///
  /// In en, this message translates to:
  /// **'Hey, {name}!'**
  String hey(String name);

  /// Label for all health category
  ///
  /// In en, this message translates to:
  /// **'All Health'**
  String get catAllHealth;

  /// Label for glucose category
  ///
  /// In en, this message translates to:
  /// **'Glucose'**
  String get catGlucose;

  /// Label for medication category
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get catMedication;

  /// Label for diet category
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get catDiet;

  /// Status label for stable condition
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// Status label for normal glucose level
  ///
  /// In en, this message translates to:
  /// **'Glucose Level, Normal'**
  String get glucoseNormal;

  /// Label for glucose
  ///
  /// In en, this message translates to:
  /// **'Glucose'**
  String get glucose;

  /// Label for insulin
  ///
  /// In en, this message translates to:
  /// **'Insulin'**
  String get insulin;

  /// Label for insulin intake
  ///
  /// In en, this message translates to:
  /// **'Insulin Intake'**
  String get insulinIntake;

  /// Label for the last 4 hours period
  ///
  /// In en, this message translates to:
  /// **'Last 4 hours'**
  String get last4Hours;

  /// Status label for logged items
  ///
  /// In en, this message translates to:
  /// **'LOGGED'**
  String get statusLogged;

  /// Status label for pending items
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get statusPending;

  /// Label for medication
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// Status label for remaining items
  ///
  /// In en, this message translates to:
  /// **'REMAIN'**
  String get statusRemain;

  /// Status label for taken items
  ///
  /// In en, this message translates to:
  /// **'TAKEN'**
  String get statusTaken;

  /// Label for daily diet
  ///
  /// In en, this message translates to:
  /// **'Daily Diet'**
  String get dailyDiet;

  /// Status label for off state
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get statusOff;

  /// Label for heart rate
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// Label for average heart rate
  ///
  /// In en, this message translates to:
  /// **'72 bpm avg'**
  String get bpmAvg;

  /// Label for calorie intake
  ///
  /// In en, this message translates to:
  /// **'Kcal 1,200'**
  String get kcal1200;

  /// Status label when all doses are taken
  ///
  /// In en, this message translates to:
  /// **'All taken'**
  String get allTaken;

  /// Label showing remaining items count
  ///
  /// In en, this message translates to:
  /// **'{count} remaining'**
  String remainingCount(int count);

  /// Message when no medications are scheduled
  ///
  /// In en, this message translates to:
  /// **'No medications for today'**
  String get noMedicationsToday;

  /// Welcome message for returning user
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBack(String name);

  /// Success message for password reset email
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent!'**
  String get resetEmailSent;

  /// Title for the login page
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// Subtitle for the login page
  ///
  /// In en, this message translates to:
  /// **'Login to your account to continue'**
  String get loginSubtitle;

  /// Label for email field
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// Label for password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Validation message for email
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmail;

  /// Validation message for invalid email
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get enterValidEmail;

  /// Validation message for password
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPassword;

  /// Validation message for short password
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get minPasswordLength;

  /// Link text for forgotten password
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Text for the login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Text asking if user has an account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// Text for the sign up button
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// Text for the create account button
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// Title for the join/sign up page
  ///
  /// In en, this message translates to:
  /// **'Join GlucoCare'**
  String get joinTitle;

  /// Subtitle for the join/sign up page
  ///
  /// In en, this message translates to:
  /// **'Start your personalized health journey'**
  String get joinSubtitle;

  /// Label for full name field
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// Validation message for full name
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get enterFullName;

  /// Success message for account creation
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreated;

  /// Text asking if user already has an account
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Title for the password recovery page
  ///
  /// In en, this message translates to:
  /// **'Password Recovery'**
  String get recoveryTitle;

  /// Subtitle for the password recovery page
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset your password'**
  String get recoverySubtitle;

  /// Success message for password reset link
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent!'**
  String get resetLinkSent;

  /// Button text to send recovery link
  ///
  /// In en, this message translates to:
  /// **'Send Recovery Link'**
  String get sendRecoveryLink;

  /// Button text to save profile changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Button text to delete account
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Label for new password input field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Success message when profile is updated
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// Success message when account is deleted
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get accountDeleted;

  /// Title for a single blood sugar reading
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar Reading'**
  String get bloodSugarReading;

  /// Title for the blood sugar readings history page
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar Readings'**
  String get bloodSugarReadings;

  /// Label for the type of blood sugar reading (e.g., Fasting)
  ///
  /// In en, this message translates to:
  /// **'Reading Type'**
  String get readingType;

  /// Label for the numerical value of the blood sugar reading
  ///
  /// In en, this message translates to:
  /// **'Reading value'**
  String get readingValue;

  /// Button text to save a blood sugar reading
  ///
  /// In en, this message translates to:
  /// **'Save Reading'**
  String get saveReading;

  /// Message shown when there are no blood sugar readings
  ///
  /// In en, this message translates to:
  /// **'No readings recorded yet'**
  String get noReadingsRecordedYet;

  /// Instructions to add the first blood sugar reading
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first reading'**
  String get tapToAddFirstReading;

  /// Error message when blood sugar readings fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading readings'**
  String get errorLoadingReadings;

  /// Label for fasting blood sugar reading type
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get fasting;

  /// Label for postprandial blood sugar reading type
  ///
  /// In en, this message translates to:
  /// **'2h Postprandial'**
  String get postprandial;

  /// Label for before sleep blood sugar reading type
  ///
  /// In en, this message translates to:
  /// **'Before Sleep'**
  String get beforeSleep;

  /// Label for HbA1c blood sugar reading type
  ///
  /// In en, this message translates to:
  /// **'HbA1c'**
  String get hba1c;

  /// Health status label for normal blood sugar levels
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get statusNormalLevel;

  /// Health status label for prediabetes blood sugar levels
  ///
  /// In en, this message translates to:
  /// **'Prediabetes'**
  String get statusPrediabetes;

  /// Health status label for diabetes blood sugar levels
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get statusDiabetes;

  /// Health status label for low blood sugar levels
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get statusLowLevel;

  /// Health status label for high blood sugar levels
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get statusHighLevel;

  /// Health status label for very high blood sugar levels
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get statusVeryHigh;

  /// Health status label for dangerous blood sugar levels
  ///
  /// In en, this message translates to:
  /// **'Dangerous'**
  String get statusDangerous;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
