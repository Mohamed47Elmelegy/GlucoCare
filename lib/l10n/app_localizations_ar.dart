// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'جلوكو كير';

  @override
  String get dashboardTitle => 'أدوية اليوم';

  @override
  String get addMedication => 'إضافة دواء';

  @override
  String get editMedication => 'تعديل الدواء';

  @override
  String get medicationHistory => 'سجل الأدوية';

  @override
  String get noMedicationsScheduled => 'لا توجد أدوية مجدولة لهذا اليوم.';

  @override
  String get taken => 'تم التناول';

  @override
  String get take => 'تناول';

  @override
  String get medicationName => 'اسم الدواء';

  @override
  String get dosageExample => 'الجرعة (مثال: 500 ملغ، 1 قرص)';

  @override
  String get type => 'النوع';

  @override
  String get scheduleTime => 'وقت الجدولة';

  @override
  String get saveMedication => 'حفظ الدواء';

  @override
  String get pickTime => 'اختيار الوقت';

  @override
  String get noTimeSelected => 'لم يتم اختيار وقت';

  @override
  String get pleaseSelectTime => 'يرجى اختيار وقت الجدولة';

  @override
  String get enterMedicationName => 'أدخل اسم الدواء';

  @override
  String get enterDosage => 'أدخل الجرعة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get name => 'الاسم';

  @override
  String get showingHistoryFor => 'عرض سجل التاريخ:';

  @override
  String get noMedicationsRecorded => 'لم يتم تسجيل أي أدوية في هذا التاريخ.';

  @override
  String get medicationId => 'معرف الدواء:';

  @override
  String get takenAt => 'تم تناوله في:';

  @override
  String get onTime => 'في الموعد';

  @override
  String get late => 'متأخر';

  @override
  String get failedToLoadHistory => 'فشل في تحميل السجل';

  @override
  String get goodMorning => 'صباح الخير';

  @override
  String get dailyProgress => 'التقدم اليومي';

  @override
  String get todaysDoses => 'جرعات اليوم';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get labTests => 'الفحوصات المخبرية';

  @override
  String get noLabTests => 'لا توجد فحوصات مخبرية بعد';

  @override
  String get tapToRecordTest => 'اضغط على + لإضافة أول نتيجة فحص';

  @override
  String get addLabTest => 'إضافة فحص مخبري';

  @override
  String get testName => 'اسم الفحص';

  @override
  String get result => 'النتيجة';

  @override
  String get unit => 'الوحدة';

  @override
  String get referenceRange => 'المجال المرجعي';

  @override
  String get category => 'الفئة';

  @override
  String get labTestAdded => 'تم إضافة الفحص المخبري بنجاح.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get add => 'إضافة';

  @override
  String get errorOccurred => 'حدث خطأ ما';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get myMedications => 'أدويتي';

  @override
  String get setupMedicationSchedule => 'إعداد جدول الأدوية';

  @override
  String get intakeTiming => 'وقت التناول';

  @override
  String get unitHint => 'الوحدة (مثال: ملغ، مل)';

  @override
  String get enterUnit => 'يرجى إدخال الوحدة';

  @override
  String get notes => 'ملاحظات';

  @override
  String get medicationUpdated => 'تم تحديث الدواء!';

  @override
  String get updateMedicationDetails => 'تحديث تفاصيل الدواء';

  @override
  String get settings => 'الإعدادات';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String get notifications => 'التنبيهات';

  @override
  String get privacySecurity => 'الخصوصية والأمان';

  @override
  String get language => 'اللغة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get userName => 'اسم المستخدم';

  @override
  String get english => 'الإنجليزية';

  @override
  String get confirmLogout => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get theme => 'الثيم';

  @override
  String get selectTheme => 'اختر الثيم';

  @override
  String get systemDefault => 'الوضع التلقائي';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get arabic => 'العربية';

  @override
  String hey(String name) {
    return 'أهلاً، $name!';
  }

  @override
  String get catAllHealth => 'كل الصحة';

  @override
  String get catGlucose => 'الجلوكوز';

  @override
  String get catMedication => 'الأدوية';

  @override
  String get catDiet => 'نظام غذائي';

  @override
  String get stable => 'مستقر';

  @override
  String get glucoseNormal => 'مستوى الجلوكوز، طبيعي';

  @override
  String get glucose => 'الجلوكوز';

  @override
  String get insulin => 'الأنسولين';

  @override
  String get insulinIntake => 'تناول الأنسولين';

  @override
  String get last4Hours => 'آخر 4 ساعات';

  @override
  String get statusLogged => 'مسجل';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get medication => 'دواء';

  @override
  String get statusRemain => 'يتبقى';

  @override
  String get statusTaken => 'تم أخذها';

  @override
  String get dailyDiet => 'النظام الغذائي اليومي';

  @override
  String get statusOff => 'إيقاف';

  @override
  String get heartRate => 'معدل ضربات القلب';

  @override
  String get bpmAvg => 'متوسط 72 نبضة في الدقيقة';

  @override
  String get kcal1200 => '1,200 سعرة حرارية';

  @override
  String get allTaken => 'تم أخذ الكل';

  @override
  String remainingCount(int count) {
    return 'يتبقى $count';
  }

  @override
  String get noMedicationsToday => 'لا توجد أدوية اليوم';

  @override
  String welcomeBack(String name) {
    return 'مرحباً بعودتك، $name!';
  }

  @override
  String get resetEmailSent => 'تم إرسال بريد إعادة تعيين كلمة المرور!';

  @override
  String get loginTitle => 'مرحباً بعودتك';

  @override
  String get loginSubtitle => 'قم بتسجيل الدخول إلى حسابك للمتابعة';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get enterEmail => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get enterValidEmail => 'يرجى إدخال بريد إلكتروني صحيح';

  @override
  String get enterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get minPasswordLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get noAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUpButton => 'إنشاء حساب';

  @override
  String get createAccountButton => 'إنشاء حساب';

  @override
  String get joinTitle => 'انضم إلى جلوكو كير';

  @override
  String get joinSubtitle => 'ابدأ رحلتك الصحية الشخصية';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get enterFullName => 'يرجى إدخال اسمك الكامل';

  @override
  String get accountCreated => 'تم إنشاء الحساب بنجاح!';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get recoveryTitle => 'استعادة كلمة المرور';

  @override
  String get recoverySubtitle =>
      'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور';

  @override
  String get resetLinkSent => 'تم إرسال رابط إعادة تعيين كلمة المرور!';

  @override
  String get sendRecoveryLink => 'إرسال رابط الاستعادة';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get accountDeleted => 'تم حذف الحساب';

  @override
  String get bloodSugarReading => 'قراءة السكر';

  @override
  String get bloodSugarReadings => 'قراءات السكر';

  @override
  String get readingType => 'نوع القراءة';

  @override
  String get readingValue => 'قيمة القراءة';

  @override
  String get saveReading => 'حفظ القراءة';

  @override
  String get noReadingsRecordedYet => 'لم يتم تسجيل أي قراءات بعد';

  @override
  String get tapToAddFirstReading => 'اضغط على + لإضافة أول قراءة';

  @override
  String get errorLoadingReadings => 'خطأ في تحميل القراءات';

  @override
  String get fasting => 'صائم';

  @override
  String get postprandial => 'بعد الأكل بساعتين';

  @override
  String get beforeSleep => 'قبل النوم';

  @override
  String get hba1c => 'السكر التراكمي (HbA1c)';

  @override
  String get statusNormalLevel => 'طبيعي';

  @override
  String get statusPrediabetes => 'ما قبل السكري';

  @override
  String get statusDiabetes => 'سكري';

  @override
  String get statusLowLevel => 'منخفض';

  @override
  String get statusHighLevel => 'مرتفع';

  @override
  String get statusVeryHigh => 'مرتفع جدًا';

  @override
  String get statusDangerous => 'خطير جدًا';
}
