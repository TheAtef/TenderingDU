import 'package:get/get.dart';

class TranslationsService extends Translations {
  static TranslationsService get to => Get.find();

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      //Splash
      'app_title': 'TenderingDU',
      'app_slogan': 'Smart Bidding Solutions',

      //Login
      'welcome_back': 'Welcome Back!',
      'login_inst': 'Login to continue to your account',
      'email_phone': 'Email or Syrian Mobile (e.g. 09x...)',
      'password': 'Password',
      'password_required': 'Password is required',
      'forgot_password': 'Forgot Password?',
      'login': 'Login',
      'signup': 'Sign Up',
      'dont_have_account': "Don't have an account? ",

      //SignUp
      'create_acc': 'Create Account',
      'step_1': 'Step 1: Personal Information',
      'step_2': 'Step 2: Company Information',
      'step_3': 'Step 3: Security & Finish',
      'personal_details': 'Personal Details',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'email_address': 'Email Address',
      'phone': 'Syrian Mobile (09x / +9639x)',
      'birth': 'Birthdate (YYYY-MM-DD)',
      'birth_format': 'Format: YYYY-MM-DD',
      'req': 'Required',
      'invalid_date': 'Invalid date',
      'future_date': 'Future dates not allowed',
      'sex': 'Sex',
      'male': 'Male',
      'female': 'Female',
      'next': 'Next',
      'business_details': 'Business Details',
      'construction': 'Construction',
      'it': 'IT',
      'healthcare': 'Healthcare',
      'company_name': 'Company Name',
      'crn': 'Commercial Registration Number',
      'business_activity': 'Business Activity',
      'back': 'Back',
      'confirm_password': 'Confirm Password',
      'register': 'Register',
      'have_acc': 'Already have an account? ',

      //validators
      'error': 'Error',
      'select_sex': 'Please select your Sex',
      'select_activity': 'Please select a business activity',
      'req_field': 'This field is required',
      'must_capital': 'First letter\nmust be capitalized',
      'only_letters': 'Only letters allowed',
      'enter_email': 'Please enter your email',
      'enter_valid_email': 'Please enter a valid email',
      'enter_phone': 'Please enter your phone number',
      'enter_valid_phone': 'Must be a valid Syrian mobile (e.g., 09xxxxxxxx)',
      'password_long': 'Must be at least 6 characters',
      'password_upper': 'Must contain at least 1 uppercase letter',
      'passwords_match': 'Passwords do not match',

      //Home
      'greetings': 'Good Morning,',
      'discover_tenders': 'Discover Tenders',
      'active': 'Active',
      'saved': 'Saved',
      'applied': 'Applied',
      'all': 'All',
      'no_tenders_available': 'No tenders available',
      'home': 'Home',
      'search': 'Search',
      'search_hint': 'Search tenders, categories...',
      'profile': 'Profile',

      //Saved
      'saved_tenders': 'Saved Tenders',
      'no_saved': 'No saved tenders yet',

      //Profile
      'email': 'Email',
      'phone_no_hint': 'Phone',
      'birth_no_hint': 'Birthdate',
      'company': 'Company',

      //Menu
      'menu': 'Menu',
      'tenders_results': 'Tenders Results',
      'my_bids': 'My Bids',
      'logout': 'Logout',

      //Tenders Results
      'budget': 'Budget',
      'deadline': 'Deadline',

      //My Bids
      'applied_hint': 'Bids you have applied for',
      'history': 'History',
      'history_hint': 'Bids in your history',
      'category': 'Category',

      //Settings
      'settings': 'Settings',
      'preferences': 'Preferences',
      'dark_mode': 'Dark Mode',
      'dark_mode_enabled': 'Dark mode enabled',
      'light_mode_enabled': 'Light mode enabled',
      'language': 'Language',
      'notifications': 'Notifications',
      'push_notifications': 'Push Notifications',
      'receive_app_notif': 'Receive app notifications',
      'deadline_reminders': 'Deadline Reminders',
      'alert_before_deadline': 'Alert before tenderdeadlines',
      'security': 'Security',
      'change_password': 'Change Password',
      'general': 'General',
      'help_support': 'Help & Support',
      'about': 'About',
      'app_version': 'App Version 1.0.0',

      //Notifications
      'mark_all_read': 'Mark all read',
      'new': 'New',
      'unread': 'Unread',
      'alerts': 'Alerts',

      // Add more English translations here
    },
    'ar_SY': {
      //Splash
      'app_title': 'ناقصني',
      'app_slogan': 'حلول ذكية للمناقصات',

      //Login
      'welcome_back': 'مرحباً بعودتك!',
      'login_inst': 'سجل الدخول للوصول لحسابك',
      'email_phone': 'البريد الإلكتروني أو رقم الهاتف (09XX)',
      'password': 'كلمة المرور',
      'password_required': 'كلمة المرور مطلوبة',
      'forgot_password': 'نسيت كلمة المرور؟',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'dont_have_account': "لا تملك حساب؟ ",

      //SignUp
      'create_acc': 'إنشاء حساب',
      'step_1': 'الخطوة 1: المعلومات الشخصية',
      'step_2': 'الخطوة 2: معلومات الشركة',
      'step_3': 'الخطوة 3: الأمان والانتهاء',
      'personal_details': 'التفاصيل الشخصية',
      'first_name': 'الاسم',
      'last_name': 'الكنية',
      'email_address': 'البريد الإلكتروني',
      'phone': 'رقم الهاتف (09XX / +9639XX)',
      'birth': 'تاريخ الميلاد (سنة-شهر-يوم)',
      'birth_format': 'الصيغة: سنة-شهر-يوم',
      'req': 'حقل مطلوب',
      'invalid_date': 'تاريخ غير صالح',
      'future_date': 'التواريخ المسقبلية غير مقبولة',
      'sex': 'الجنس',
      'male': 'ذكر',
      'female': 'أنثى',
      'next': 'التالي',
      'business_details': 'تفاصيل العمل',
      'construction': 'بناء',
      'it': 'معلوماتي',
      'healthcare': 'رعاية صحية',
      'company_name': 'اسم الشركة',
      'crn': 'رقم السجل التجاري',
      'business_activity': 'نشاط الشركة',
      'back': 'العودة',
      'confirm_password': 'تأكيد كلمة المرور',
      'register': 'تسجيل',
      'have_acc': 'تملك حساب؟ ',

      //validators
      'error': 'خطأ',
      'select_sex': 'اختر جنسك',
      'select_activity': 'اختر نشاط الشركة',
      'req_field': 'هذا الحقل مطلوب',
      'must_capital': 'الحرف الأول\nيجب أن يكون كبير',
      'only_letters': 'مسموح أحرف فقط',
      'enter_email': 'ادخل بريدك الإلكتروني',
      'enter_valid_email': 'ادخل بريد صالح',
      'enter_phone': 'ادخل رقم الهاتف',
      'enter_valid_phone': 'يجب أن يكون رقم سوري (09XX)',
      'password_long': 'مطلوب 6 محارف على الأقل',
      'password_upper': 'مطلوب حرف كبير على الأقل',
      'passwords_match': 'كلمتا المرور غير متطابقتين',

      //Home
      'greetings': 'صباح الخير،',
      'discover_tenders': 'تصفح المناقصات',
      'active': 'نشطة',
      'saved': 'محفوظة',
      'applied': 'مقدمة',
      'all': 'الكل',
      'no_tenders_available': 'لا توجد مناقصات متاحة',
      'home': 'الرئيسية',
      'search': 'البحث',
      'search_hint': 'ابحث عن مناقصات أو تصنيفات...',
      'profile': 'الملف الشخصي',

      //Saved
      'saved_tenders': 'المناقصات المحفوطة',
      'no_saved': 'لا يوجد مناقصات محفوظة',

      //Profile
      'email': 'البريد',
      'phone_no_hint': 'الهاتف',
      'birth_no_hint': 'تاريخ الميلاد',
      'company': 'الشركة',

      //Menu
      'menu': 'القائمة',
      'tenders_results': 'نتائج المناقصات',
      'my_bids': 'عروضي',
      'logout': 'تسجيل الخروج',

      //Tenders Results
      'budget': 'الميزانية',
      'deadline': 'الموعد النهائي',

      //My Bids
      'applied_hint': 'مناقصات قمت بالتقديم إليها',
      'history': 'السجل',
      'history_hint': 'المناقصات في سجلك',
      'category': 'النوع',

      //Settings
      'settings': 'الإعدادات',
      'preferences': 'التفضيلات',
      'dark_mode': 'الوضع الداكن',
      'dark_mode_enabled': 'الوضع الداكن مفعّل',
      'light_mode_enabled': 'الوضع الفاتح مفعّل',
      'language': 'اللغة',
      'notifications': 'الإشعارات',
      'push_notifications': 'الإشعارات المنبثقة',
      'receive_app_notif': 'تلقي إشعارات التطبيق',
      'deadline_reminders': 'تذكير المواعيد النهائية',
      'alert_before_deadline': 'الإنذار قبل المواعيد النهائية للمناقصات',
      'security': 'الأمان',
      'change_password': 'تغيير كلمة المرور',
      'general': 'العامة',
      'help_support': 'المساعدة والدعم',
      'about': 'عن التطبيق',
      'app_version': 'الإصدار 1.0.0',

      //Notifications
      'mark_all_read': 'تمييز الكل كمقروء',
      'new': 'جديد',
      'unread': 'غير مقروء',
      'alerts': 'تنبيهات',
    },
    // Add more languages here
  };
}
