// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GlucoCare';

  @override
  String get dashboardTitle => 'Today\'\'s Medications';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get editMedication => 'Edit Medication';

  @override
  String get medicationHistory => 'Medication History';

  @override
  String get noMedicationsScheduled => 'No medications scheduled for today.';

  @override
  String get taken => 'Taken';

  @override
  String get take => 'Take';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get dosageExample => 'Dosage (e.g., 500mg, 1 tablet)';

  @override
  String get type => 'Type';

  @override
  String get scheduleTime => 'Schedule Time';

  @override
  String get saveMedication => 'Save Medication';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get noTimeSelected => 'No time selected';

  @override
  String get pleaseSelectTime => 'Please select a schedule time';

  @override
  String get enterMedicationName => 'Enter medication name';

  @override
  String get enterDosage => 'Enter dosage';

  @override
  String get login => 'Login';

  @override
  String get createAccount => 'Create Account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get showingHistoryFor => 'Showing history for:';

  @override
  String get noMedicationsRecorded => 'No medications recorded on this date.';

  @override
  String get medicationId => 'Medication ID:';

  @override
  String get takenAt => 'Taken at:';

  @override
  String get onTime => 'On Time';

  @override
  String get late => 'Late';

  @override
  String get failedToLoadHistory => 'Failed to load history';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get dailyProgress => 'Daily Progress';

  @override
  String get todaysDoses => 'Today\'s Doses';

  @override
  String get viewAll => 'View All';

  @override
  String get labTests => 'Lab Tests';

  @override
  String get noLabTests => 'No lab tests yet';

  @override
  String get tapToRecordTest => 'Tap + to add your first test result';

  @override
  String get addLabTest => 'Add Lab Test';

  @override
  String get testName => 'Test Name';

  @override
  String get result => 'Result';

  @override
  String get unit => 'Unit';

  @override
  String get referenceRange => 'Reference Range';

  @override
  String get category => 'Category';

  @override
  String get labTestAdded => 'Lab test added successfully.';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get myMedications => 'My Medications';

  @override
  String get setupMedicationSchedule => 'Setup your medication schedule';

  @override
  String get intakeTiming => 'Intake Timing';

  @override
  String get unitHint => 'Unit (e.g., mg, ml)';

  @override
  String get enterUnit => 'Please enter unit';

  @override
  String get notes => 'Notes';

  @override
  String get medicationUpdated => 'Medication updated!';

  @override
  String get updateMedicationDetails => 'Update your medication details';

  @override
  String get settings => 'Settings';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get language => 'Language';

  @override
  String get logout => 'Logout';

  @override
  String get userName => 'User Name';

  @override
  String get english => 'English';

  @override
  String get confirmLogout => 'Are you sure you want to log out?';

  @override
  String get theme => 'Theme';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get systemDefault => 'System Default';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get arabic => 'Arabic';

  @override
  String hey(String name) {
    return 'Hey, $name!';
  }

  @override
  String get catAllHealth => 'All Health';

  @override
  String get catGlucose => 'Glucose';

  @override
  String get catMedication => 'Medication';

  @override
  String get catDiet => 'Diet';

  @override
  String get stable => 'Stable';

  @override
  String get glucoseNormal => 'Glucose Level, Normal';

  @override
  String get glucose => 'Glucose';

  @override
  String get insulin => 'Insulin';

  @override
  String get insulinIntake => 'Insulin Intake';

  @override
  String get last4Hours => 'Last 4 hours';

  @override
  String get statusLogged => 'LOGGED';

  @override
  String get statusPending => 'PENDING';

  @override
  String get medication => 'Medication';

  @override
  String get statusRemain => 'REMAIN';

  @override
  String get statusTaken => 'TAKEN';

  @override
  String get dailyDiet => 'Daily Diet';

  @override
  String get statusOff => 'OFF';

  @override
  String get heartRate => 'Heart Rate';

  @override
  String get bpmAvg => '72 bpm avg';

  @override
  String get kcal1200 => 'Kcal 1,200';

  @override
  String get allTaken => 'All taken';

  @override
  String remainingCount(int count) {
    return '$count remaining';
  }

  @override
  String get noMedicationsToday => 'No medications for today';

  @override
  String welcomeBack(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get resetEmailSent => 'Password reset email sent!';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Login to your account to continue';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get minPasswordLength => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get joinTitle => 'Join GlucoCare';

  @override
  String get joinSubtitle => 'Start your personalized health journey';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get enterFullName => 'Please enter your full name';

  @override
  String get accountCreated => 'Account created successfully!';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get recoveryTitle => 'Password Recovery';

  @override
  String get recoverySubtitle => 'Enter your email to reset your password';

  @override
  String get resetLinkSent => 'Password reset link sent!';

  @override
  String get sendRecoveryLink => 'Send Recovery Link';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get newPassword => 'New Password';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get accountDeleted => 'Account deleted';

  @override
  String get bloodSugarReading => 'Blood Sugar Reading';

  @override
  String get bloodSugarReadings => 'Blood Sugar Readings';

  @override
  String get readingType => 'Reading Type';

  @override
  String get readingValue => 'Reading value';

  @override
  String get saveReading => 'Save Reading';

  @override
  String get noReadingsRecordedYet => 'No readings recorded yet';

  @override
  String get tapToAddFirstReading => 'Tap + to add your first reading';

  @override
  String get errorLoadingReadings => 'Error loading readings';

  @override
  String get fasting => 'Fasting';

  @override
  String get postprandial => '2h Postprandial';

  @override
  String get beforeSleep => 'Before Sleep';

  @override
  String get hba1c => 'HbA1c';

  @override
  String get statusNormalLevel => 'Normal';

  @override
  String get statusPrediabetes => 'Prediabetes';

  @override
  String get statusDiabetes => 'Diabetes';

  @override
  String get statusLowLevel => 'Low';

  @override
  String get statusHighLevel => 'High';

  @override
  String get statusVeryHigh => 'Very High';

  @override
  String get statusDangerous => 'Dangerous';
}
