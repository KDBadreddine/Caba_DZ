import '../locale/app_locale.dart';

/// CabaDZ strings — Arabic, French, English (follows [appLocale]).
class AppStrings {
  AppStrings._();

  static String _t(String ar, String fr, String en) {
    switch (appLocale.lang) {
      case AppLang.fr:
        return fr;
      case AppLang.en:
        return en;
      case AppLang.ar:
        return ar;
    }
  }

  static String get appName => 'CabaDZ';
  static String get tagline => _t(
    'من الجزائر إلى العالم.\nمعاً. أقرب.',
    "De l'Algérie vers le monde\nEnsemble .. plus proche",
    'From Algeria to the world.\nTogether. Closer.',
  );
  static String get slogan => 'Connect. Travel. Deliver.';
  static String get bridge => _t(
    'لتكن جسراً بين الناس',
    'Soyez un pont entre les gens',
    'Be a bridge between people',
  );

  static String get startNow =>
      _t('إبدأ الآن', 'Commencer maintenant', 'Start now');
  static String get download =>
      _t('حمل التطبيق الآن', "Télécharger l'application", 'Download the app');

  static String get welcome => _t('مرحباً بك', 'Bienvenue', 'Welcome');
  static String get loginSub => _t(
    'سجل الدخول إلى حسابك',
    'Connectez-vous à votre compte',
    'Sign in to your account',
  );
  static String get email => _t('البريد الإلكتروني', 'Email', 'Email');
  static String get password => _t('كلمة المرور', 'Mot de passe', 'Password');
  static String get remember =>
      _t('تذكرني', 'Se souvenir de moi', 'Remember me');
  static String get forgot =>
      _t('نسيت كلمة المرور؟', 'Mot de passe oublié ?', 'Forgot password?');
  static String get loginBtn => _t('تسجيل الدخول', 'Se connecter', 'Sign in');
  static String get orVia =>
      _t('أو تابع عبر', 'Ou continuer avec', 'Or continue with');
  static String get noAccount =>
      _t('ليس لديك حساب؟', 'Pas de compte ?', "Don't have an account?");
  static String get register =>
      _t('إنشاء حساب جديد', 'Créer un nouveau compte', 'Create an account');

  static String get firstName => _t('الإسم', 'Prénom', 'First name');
  static String get lastName => _t('اللقب', 'Nom', 'Last name');
  static String get phone => _t('رقم الهاتف', 'Téléphone', 'Phone number');
  static String get confirmPwd =>
      _t('تأكيد كلمة المرور', 'Confirmer le mot de passe', 'Confirm password');
  static String get agreeTerms => _t(
    'أوافق على الشروط والأحكام',
    "J'accepte les conditions",
    'I agree to the terms',
  );
  static String get createAcc =>
      _t('إنشاء الحساب', 'Créer le compte', 'Create account');
  static String get hasAccount => _t(
    'لديك حساب بالفعل؟',
    'Vous avez déjà un compte ?',
    'Already have an account?',
  );
  static String get addPhoto =>
      _t('إضافة صورة', 'Ajouter une photo', 'Add photo');
  static String get changePhoto =>
      _t('تغيير الصورة', 'Changer la photo', 'Change photo');
  static String get enterEmail => _t(
        'أدخل البريد الإلكتروني',
        'Saisissez votre email',
        'Enter your email',
      );
  static String get enterPhone => _t(
        'أدخل رقم الهاتف',
        'Saisissez votre téléphone',
        'Enter your phone number',
      );
  static String get passwordTooShort => _t(
        'كلمة المرور قصيرة جداً',
        'Mot de passe trop court',
        'Password is too short',
      );
  static String get passwordMismatch => _t(
        'كلمتا المرور غير متطابقتين',
        'Les mots de passe ne correspondent pas',
        'Passwords do not match',
      );
  static String get acceptTerms => _t(
        'يجب الموافقة على الشروط والأحكام',
        'Veuillez accepter les conditions',
        'Please accept the terms and conditions',
      );
  static String get firstNameHint => _t('أيوب', 'Ayoub', 'Ayoub');
  static String get lastNameHint => _t('بن علي', 'Ben Ali', 'Ben Ali');

  static String get greeting => _t('مرحباً', 'Bonjour', 'Hello');
  static String get whatToday => _t(
    'ماذا تريد أن تفعل اليوم؟',
    "Que voulez-vous faire aujourd'hui ?",
    'What do you want to do today?',
  );
  static String get addTrip =>
      _t('أضف رحلة', 'Ajouter un voyage', 'Add a trip');
  static String get addTripSub => _t(
    'لديك رحلة؟ شارك مقعداً أو الوزن المتاح',
    'Vous voyagez ? Partagez une place ou le poids disponible',
    'Traveling? Share a seat or leftover weight',
  );
  static String get sendShipment =>
      _t('أرسل شحنة', 'Envoyer un colis', 'Send a shipment');
  static String get sendShipSub => _t(
    'هل تريد إرسال سلعة؟ ابحث عن مسافر موثوق',
    'Vous voulez envoyer un colis ? Trouvez un voyageur fiable',
    'Need to send an item? Find a trusted traveler',
  );
  static String get recent => _t(
    'أحدث الرحلات والشحنات',
    'Derniers voyages et colis',
    'Latest trips and shipments',
  );
  static String get popularDests =>
      _t('وجهات شائعة', 'Destinations populaires', 'Popular destinations');
  static String get showAll => _t('عرض الكل', 'Voir tout', 'See all');
  static String get bannerLine => _t(
    'فرص جديدة في كل رحلة',
    'De nouvelles opportunités à chaque voyage',
    'New opportunities on every trip',
  );

  static String get availableTrips =>
      _t('الرحلات المتاحة', 'Voyages disponibles', 'Available trips');
  static String get addTripTitle =>
      _t('إضافة رحلة', 'Ajouter un voyage', 'Add trip');
  static String get from => _t('من', 'De', 'From');
  static String get to => _t('إلى', 'À', 'To');
  static String get travelDate =>
      _t('تاريخ السفر', 'Date du voyage', 'Travel date');
  static String get departureTime =>
      _t('ساعة المغادرة', 'Heure de départ', 'Departure time');
  static String get availableWeight =>
      _t('الوزن المتاح', 'Poids disponible', 'Available weight');
  static String get notes =>
      _t('ملاحظات (اختياري)', 'Notes (facultatif)', 'Notes (optional)');
  static String get postTrip =>
      _t('نشر الرحلة', 'Publier le voyage', 'Publish trip');
  static String get tripDetails =>
      _t('تفاصيل الرحلة', 'Détails du voyage', 'Trip details');
  static String get contactTraveler => _t(
    'التواصل مع صاحب الرحلة',
    'Contacter le voyageur',
    'Contact the traveler',
  );
  static String get shipDetails =>
      _t('تفاصيل الشحنة', 'Détails du colis', 'Shipment details');
  static String get contactSender =>
      _t('التواصل مع المرسل', 'Contacter l’expéditeur', 'Contact the sender');
  static String get openOrderChat =>
      _t('فتح المحادثة', 'Ouvrir la discussion', 'Open chat');
  static String get orderUnavailable => _t(
    'تعذر فتح الطلب',
    'Impossible d’ouvrir la demande',
    'Could not open the order',
  );
  static String get verifiedUser =>
      _t('مستخدم موثوق', 'Utilisateur vérifié', 'Verified user');
  static String get originCountry =>
      _t('بلد الانطلاق', 'Pays de départ', 'Origin country');
  static String get originCity =>
      _t('مدينة الانطلاق', 'Ville de départ', 'Origin city');
  static String get destCountry =>
      _t('بلد الوصول', 'Pays d’arrivée', 'Destination country');
  static String get chooseCountry =>
      _t('اختر البلد', 'Choisir un pays', 'Choose a country');
  static String get chooseDate =>
      _t('اختر التاريخ', 'Choisir une date', 'Choose a date');
  static String get pricePerKg =>
      _t('السعر لكل كغ', 'Prix par kg', 'Price per kg');
  static String get currency => _t('العملة', 'Devise', 'Currency');
  static String get destCity =>
      _t('اختر الوجهة', 'Choisir la destination', 'Choose destination');

  static String get availableShip =>
      _t('الشحنات المتاحة', 'Colis disponibles', 'Available shipments');
  static String get addShipTitle =>
      _t('إضافة شحنة', 'Ajouter un colis', 'Add shipment');
  static String get weight => _t('الوزن (كغ)', 'Poids (kg)', 'Weight (kg)');
  static String get packageType =>
      _t('نوع السلعة', 'Type de colis', 'Item type');
  static String get postShip =>
      _t('نشر الشحنة', 'Publier le colis', 'Publish shipment');
  static String get itemDesc =>
      _t('وصف السلعة', 'Description', 'Item description');
  static String get maxBudget => _t(
    'الميزانية القصوى (اختياري)',
    'Budget max (facultatif)',
    'Max budget (optional)',
  );

  static const catElectronicsAr = 'إلكترونيات';
  static const catClothingAr = 'ملابس';
  static const catFoodAr = 'مواد غذائية';
  static const catDocumentsAr = 'وثائق';
  static const catOtherAr = 'أخرى';

  static String get messageHint =>
      _t('اكتب رسالتك..', 'Écrire un message..', 'Write a message..');
  static String get online => _t('متصل الآن', 'En ligne', 'Online');
  static String get conversations => _t('الرسائل', 'Messages', 'Messages');
  static String get noConversations =>
      _t('لا توجد محادثات بعد', 'Aucune conversation', 'No conversations yet');
  static String get selfChat => _t(
    'لا يمكنك مراسلة نفسك',
    'Vous ne pouvez pas vous écrire',
    'You cannot message yourself',
  );
  static String get lastSeen =>
      _t('آخر ظهور', 'Dernière connexion', 'Last seen');
  static String get offline => _t('غير متصل', 'Hors ligne', 'Offline');
  static String get startFirstMessage => _t(
    'اكتب أول رسالة',
    'Écrivez le premier message',
    'Write the first message',
  );
  static String get startConversation =>
      _t('ابدأ المحادثة', 'Démarrer la conversation', 'Start the conversation');

  static String get orders => _t('طلباتي', 'Mes demandes', 'My orders');
  static String get all => _t('الكل', 'Tout', 'All');
  static String get trips => _t('رحلاتي', 'Mes voyages', 'My trips');
  static String get shipments => _t('شحناتي', 'Mes colis', 'My shipments');
  static String get tripsTab => _t('رحلات', 'Voyages', 'Trips');
  static String get shipsTab => _t('شحنات', 'Colis', 'Shipments');
  static String get pending => _t('في انتظار الاتفاق', 'En attente', 'Pending');
  static String get agreed => _t('تم الاتفاق', 'Confirmé', 'Agreed');
  static String get completed => _t('مكتمل', 'Terminé', 'Completed');
  static String get cancelled => _t('ملغى', 'Annulé', 'Cancelled');

  static String get notifTitle =>
      _t('الإشعارات', 'Notifications', 'Notifications');
  static String get unread => _t('غير مقروء', 'Non lus', 'Unread');

  static String get search => _t('البحث', 'Recherche', 'Search');
  static String get searchBtn => _t('بحث', 'Rechercher', 'Search');
  static String get date => _t('التاريخ', 'Date', 'Date');

  static String get account => _t('حسابي', 'Mon compte', 'My account');
  static String get personalInfo =>
      _t('المعلومات الشخصية', 'Informations personnelles', 'Personal info');
  static String get myOrders => _t('طلباتي', 'Mes demandes', 'My orders');
  static String get settings => _t('الإعدادات', 'Paramètres', 'Settings');
  static String get help => _t('مساعدة', 'Aide', 'Help');
  static String get logout => _t('تسجيل الخروج', 'Déconnexion', 'Log out');
  static String get rating => _t('التقييم', 'Note', 'Rating');
  static String get editProfile =>
      _t('تعديل الملف', 'Modifier le profil', 'Edit profile');
  static String get profileUpdated =>
      _t('تم حفظ التغييرات', 'Modifications enregistrées', 'Changes saved');
  static String get profileUpdatedSub => _t(
    'تم تحديث معلوماتك بنجاح',
    'Votre profil a été mis à jour',
    'Your profile was updated',
  );
  static String get country => _t('البلد', 'Pays', 'Country');
  static String get city => _t('المدينة', 'Ville', 'City');
  static String get role => _t('الدور', 'Rôle', 'Role');
  static String get roleSender => _t('مرسل', 'Expéditeur', 'Sender');
  static String get roleTraveler => _t('مسافر', 'Voyageur', 'Traveler');
  static String get roleBoth => _t('الاثنان', 'Les deux', 'Both');
  static String get language => _t('اللغة', 'Langue', 'Language');
  static String get langArabic => 'العربية';
  static String get langFrench => 'Français';
  static String get langEnglish => 'English';
  static String get helpBody => _t(
    'CabaDZ يربط المسافرين والمرسلين لنقل الطرود بثقة. للتواصل: support@cabadz.com',
    'CabaDZ relie voyageurs et expéditeurs. Contact : support@cabadz.com',
    'CabaDZ connects travelers and senders. Contact: support@cabadz.com',
  );
  static String get requiredField => _t('مطلوب', 'Obligatoire', 'Required');
  static String get saveChanges =>
      _t('حفظ التغييرات', 'Enregistrer', 'Save changes');
  static String get profileFailed => _t(
    'تعذر حفظ التغييرات',
    'Impossible d’enregistrer',
    'Could not save changes',
  );
  static String get loginFailed => _t(
    'بيانات الدخول غير صحيحة',
    'Identifiants incorrects',
    'Incorrect login details',
  );
  static String get registerFailed => _t(
    'تعذر إنشاء الحساب. تحقق من البريد أو الهاتف',
    'Impossible de créer le compte',
    'Could not create the account',
  );
  static String get tripIncomplete => _t(
    'أكمل بلد الانطلاق والوجهة والتاريخ',
    'Complétez le départ, la destination et la date',
    'Complete origin, destination and date',
  );
  static String get tripFailed => _t(
    'تعذر نشر الرحلة',
    'Impossible de publier le voyage',
    'Could not publish trip',
  );
  static String get shipFailed => _t(
    'تعذر نشر الشحنة',
    'Impossible de publier le colis',
    'Could not publish shipment',
  );

  static String get navHome => _t('الرئيسية', 'Accueil', 'Home');
  static String get navSearch => _t('البحث', 'Recherche', 'Search');
  static String get navMessages => _t('الرسائل', 'Messages', 'Messages');
  static String get navAccount => _t('حسابي', 'Compte', 'Account');

  static String get confirm => _t('تأكيد', 'Confirmer', 'Confirm');
  static String get cancel => _t('إلغاء', 'Annuler', 'Cancel');
  static String get yesterday => _t('أمس', 'Hier', 'Yesterday');
  static String get save => _t('حفظ', 'Enregistrer', 'Save');
  static String get edit => _t('تعديل', 'Modifier', 'Edit');
  static String get delete => _t('حذف', 'Supprimer', 'Delete');
  static String get loading =>
      _t('جاري التحميل...', 'Chargement...', 'Loading...');
  static String get error =>
      _t('حدث خطأ ما', 'Une erreur est survenue', 'Something went wrong');
  static String get retry => _t('إعادة المحاولة', 'Réessayer', 'Try again');
  static String get ok => _t('حسناً', 'OK', 'OK');
  static String get tripPosted =>
      _t('تم نشر رحلتك بنجاح', 'Voyage publié', 'Trip published');
  static String get tripPostedSub => _t(
    'ستظهر رحلتك الآن في الرئيسية وللمسافرين',
    'Votre voyage apparaît maintenant sur l’accueil',
    'Your trip now appears on the home screen',
  );
  static String get shipPosted =>
      _t('تم نشر شحنتك بنجاح', 'Colis publié', 'Shipment published');
  static String get shipPostedSub => _t(
    'ستظهر شحنتك الآن في الرئيسية وللمرسلين',
    'Votre colis apparaît maintenant sur l’accueil',
    'Your shipment now appears on the home screen',
  );
  static String get editTrip =>
      _t('تعديل الرحلة', 'Modifier le voyage', 'Edit trip');
  static String get editShip =>
      _t('تعديل الشحنة', 'Modifier le colis', 'Edit shipment');
  static String get tripUpdated =>
      _t('تم تحديث الرحلة', 'Voyage mis à jour', 'Trip updated');
  static String get tripUpdatedSub => _t(
    'تم حفظ تغييرات رحلتك',
    'Les modifications du voyage ont été enregistrées',
    'Your trip changes were saved',
  );
  static String get shipUpdated =>
      _t('تم تحديث الشحنة', 'Colis mis à jour', 'Shipment updated');
  static String get shipUpdatedSub => _t(
    'تم حفظ تغييرات شحنتك',
    'Les modifications du colis ont été enregistrées',
    'Your shipment changes were saved',
  );
  static String get cannotEditMatched => _t(
    'لا يمكن تعديل طلب تمّت مطابقته',
    'Impossible de modifier une demande déjà associée',
    'A matched order cannot be edited',
  );
  static String get accountCreated =>
      _t('تم إنشاء حسابك بنجاح', 'Compte créé', 'Account created');
  static String get accountCreatedSub =>
      _t('مرحباً بك في CabaDZ', 'Bienvenue sur CabaDZ', 'Welcome to CabaDZ');
  static String get emptyTrips =>
      _t('لا توجد رحلات', 'Aucun voyage', 'No trips');
  static String get emptyTripsSub => _t(
    'لا توجد رحلات متاحة حالياً',
    'Aucun voyage disponible pour le moment',
    'No trips available right now',
  );
  static String get emptyShips =>
      _t('لا توجد شحنات', 'Aucun colis', 'No shipments');
  static String get emptyShipsSub => _t(
    'لا توجد شحنات متاحة حالياً',
    'Aucun colis disponible pour le moment',
    'No shipments available right now',
  );
  static String get emptyOrders =>
      _t('لا توجد طلبات', 'Aucune demande', 'No orders');
  static String get emptyOrdersSub => _t(
    'لم تضف أي رحلة أو شحنة بعد',
    'Vous n’avez pas encore ajouté de voyage ou de colis',
    'You have not added a trip or shipment yet',
  );
  static String get emptyNotifs =>
      _t('لا توجد إشعارات', 'Aucune notification', 'No notifications');
  static String get emptyNotifsSub => _t(
    'ستظهر إشعاراتك هنا عند وصول جديد',
    'Vos notifications apparaîtront ici',
    'Your notifications will show up here',
  );
  static String get emptySearch =>
      _t('لا توجد نتائج', 'Aucun résultat', 'No results');
  static String get emptySearchSub => _t(
    'جرّب وجهة أو تاريخاً آخر',
    'Essayez une autre destination ou date',
    'Try another destination or date',
  );
  static String get emptyMessagesSub => _t(
    'ستظهر محادثاتك هنا بعد التواصل مع مسافر',
    'Vos conversations apparaîtront ici',
    'Your chats will appear here after you contact a traveler',
  );
  static String get kg => _t('كغ', 'kg', 'kg');
  static String get cm => _t('سم', 'cm', 'cm');

  static String get match => _t('مطابقة', 'Associer', 'Match');
  static String get confirmMatch =>
      _t('تأكيد المطابقة', 'Confirmer l’association', 'Confirm match');
  static String get matchDialogTitle =>
      _t('تأكيد المطابقة', 'Confirmer l’association', 'Confirm match');
  static String matchDialogBody(String name) => _t(
    'هل توافق على المطابقة مع $name؟ يجب أن يؤكد الطرفان (المسافر والمرسل) قبل إنشاء رمز التسليم.',
    'Acceptez-vous l’association avec $name ? Les deux parties doivent confirmer.',
    'Do you agree to match with $name? Both of you must confirm before a delivery QR is created.',
  );
  static String get iAmTraveler =>
      _t('أنا المسافر', 'Je suis le voyageur', 'I am the traveler');
  static String get iAmTravelerSub => _t(
    'سأقلّ الشحنة في رحلتي',
    'Je transporterai le colis dans mon vol',
    'I will carry the package on my flight',
  );
  static String get iAmSender =>
      _t('أنا المرسل', 'Je suis l’expéditeur', 'I am the sender');
  static String get iAmSenderSub => _t(
    'سأرسل شحنة مع هذا المسافر',
    'J’envoie un colis avec ce voyageur',
    'I will send a package with this traveler',
  );
  static String get pickYourRole => _t(
    'اختر دورك في هذه المطابقة',
    'Choisissez votre rôle',
    'Choose your role in this match',
  );
  static String waitingForConfirm(String name) => _t(
    'بانتظار تأكيد $name',
    'En attente de $name',
    'Waiting for $name to confirm',
  );
  static String get theyConfirmedMatch => _t(
    'الطرف الآخر أكّد. أكّد أنت لإتمام المطابقة.',
    'L’autre a confirmé. Confirmez pour finaliser.',
    'The other person confirmed. Confirm to complete the match.',
  );
  static String get youConfirmedWait => _t(
    'تم تأكيدك. بانتظار الطرف الآخر.',
    'Vous avez confirmé. En attente de l’autre.',
    'You confirmed. Waiting for the other person.',
  );
  static String get matchWaitingTitle =>
      _t('بانتظار التأكيد', 'En attente', 'Waiting for confirmation');
  static String get matchWaitingSub => _t(
    'تم تسجيل تأكيدك. عندما يؤكد الطرف الآخر سيتم إنشاء رمز QR للمرسل.',
    'Votre confirmation est enregistrée. Le QR sera créé après la confirmation de l’autre.',
    'Your confirmation is saved. A QR code is generated for the sender after both confirm.',
  );
  static String get matchReadyTitle =>
      _t('تمت المطابقة', 'Association confirmée', 'You’re matched');
  static String get matchReadySub => _t(
    'تم إنشاء رمز QR للمرسل. عند التسليم يمسحه المسافر لإكمال العملية.',
    'Un QR a été créé pour l’expéditeur. Le voyageur le scanne à la livraison.',
    'A QR code was created for the sender. The traveler scans it on delivery to complete.',
  );
  static String get viewQr => _t('عرض رمز QR', 'Voir le QR', 'View QR code');
  static String get downloadQrPdf =>
      _t('تحميل PDF', 'Télécharger le PDF', 'Download PDF');
  static String get scanToComplete =>
      _t('مسح رمز التسليم', 'Scanner le QR', 'Scan delivery QR');
  static String get deliveryCompleted =>
      _t('تم التسليم', 'Livraison effectuée', 'Delivered');
  static String get matchQrTitle =>
      _t('رمز تسليم الشحنة', 'QR de livraison', 'Delivery QR');
  static String get matchQrHint => _t(
    'اعرض هذا الرمز للمسافر عند التسليم، أو حمّله كملف PDF.',
    'Montrez ce QR au voyageur à la livraison, ou téléchargez-le en PDF.',
    'Show this QR to the traveler on delivery, or download it as a PDF.',
  );
  static String get deliveryCodeLabel =>
      _t('رمز التسليم', 'Code de livraison', 'Delivery code');
  static String get scanTitle =>
      _t('مسح رمز التسليم', 'Scanner le QR', 'Scan delivery QR');
  static String get scanHint => _t(
    'وجّه الكاميرا نحو رمز QR الخاص بالمرسل لإكمال التسليم.',
    'Pointez la caméra vers le QR de l’expéditeur pour terminer.',
    'Point the camera at the sender’s QR code to complete delivery.',
  );
  static String get deliverySuccessTitle =>
      _t('تم تأكيد التسليم', 'Livraison confirmée', 'Delivery confirmed');
  static String get deliverySuccessSub => _t(
    'تم تحديث حالة الشحنة إلى مكتمل.',
    'Le statut du colis est passé à terminé.',
    'The shipment status is now completed.',
  );
  static String get alreadyDelivered =>
      _t('تم تسليم هذه الشحنة مسبقاً', 'Déjà livré', 'Already delivered');
  static String get invalidQr =>
      _t('رمز QR غير صالح', 'QR invalide', 'Invalid QR code');
  static String get scanNotTraveler => _t(
    'المسافر فقط يمكنه مسح الرمز لإكمال التسليم',
    'Seul le voyageur peut scanner pour terminer',
    'Only the traveler can scan to complete delivery',
  );
  static String get matchNotReady => _t(
    'المطابقة غير جاهزة للتسليم بعد',
    'L’association n’est pas prête',
    'This match is not ready for delivery yet',
  );
  static String get matchFailed => _t(
    'تعذر تأكيد المطابقة. شغّل ترحيل قاعدة البيانات إن لزم.',
    'Impossible de confirmer. Exécutez la migration si besoin.',
    'Could not confirm the match. Run the database migration if needed.',
  );
  static String get pdfFailed => _t(
    'تعذر إنشاء ملف PDF',
    'Impossible de créer le PDF',
    'Could not create PDF',
  );
  static String get pdfReady => _t('تم تجهيز ملف PDF', 'PDF prêt', 'PDF ready');
  static String get chooseRoleFirst => _t(
    'اختر دورك أولاً',
    'Choisissez d’abord votre rôle',
    'Choose your role first',
  );

  // Back-compat aliases used across current screens
  static String get startNowAr => startNow;
  static String get welcomeAr => welcome;
  static String get loginSubAr => loginSub;
  static String get emailAr => email;
  static String get passwordAr => password;
  static String get rememberAr => remember;
  static String get forgotAr => forgot;
  static String get loginBtnAr => loginBtn;
  static String get orViaAr => orVia;
  static String get noAccountAr => noAccount;
  static String get registerAr => register;
  static String get firstNameAr => firstName;
  static String get lastNameAr => lastName;
  static String get phoneAr => phone;
  static String get confirmPwdAr => confirmPwd;
  static String get createAccAr => createAcc;
  static String get hasAccountAr => hasAccount;
  static String get addPhotoAr => addPhoto;
  static String get greetingAr => greeting;
  static String get whatTodayAr => whatToday;
  static String get addTripAr => addTrip;
  static String get addTripSubAr => addTripSub;
  static String get sendShipmentAr => sendShipment;
  static String get sendShipSubAr => sendShipSub;
  static String get showAllAr => showAll;
  static String get availableTripsAr => availableTrips;
  static String get addTripTitleAr => addTripTitle;
  static String get fromAr => from;
  static String get toAr => to;
  static String get travelDateAr => travelDate;
  static String get availableWeightAr => availableWeight;
  static String get notesAr => notes;
  static String get postTripAr => postTrip;
  static String get tripDetailsAr => tripDetails;
  static String get contactTravelerAr => contactTraveler;
  static String get verifiedUserAr => verifiedUser;
  static String get availableShipAr => availableShip;
  static String get addShipTitleAr => addShipTitle;
  static String get weightAr => weight;
  static String get packageTypeAr => packageType;
  static String get postShipAr => postShip;
  static String get messageHintAr => messageHint;
  static String get onlineAr => online;
  static String get conversationsAr => conversations;
  static String get noConversationsAr => noConversations;
  static String get selfChatAr => selfChat;
  static String get lastSeenAr => lastSeen;
  static String get offlineAr => offline;
  static String get emptyMessagesSubAr => emptyMessagesSub;
  static String get ordersAr => orders;
  static String get allAr => all;
  static String get tripsAr => trips;
  static String get shipmentsAr => shipments;
  static String get pendingAr => pending;
  static String get agreedAr => agreed;
  static String get completedAr => completed;
  static String get cancelledAr => cancelled;
  static String get notifTitleAr => notifTitle;
  static String get searchAr => search;
  static String get searchBtnAr => searchBtn;
  static String get dateAr => date;
  static String get accountAr => account;
  static String get personalInfoAr => personalInfo;
  static String get myOrdersAr => myOrders;
  static String get settingsAr => settings;
  static String get helpAr => help;
  static String get logoutAr => logout;
  static String get okAr => ok;
  static String get tripPostedAr => tripPosted;
  static String get tripPostedSubAr => tripPostedSub;
  static String get shipPostedAr => shipPosted;
  static String get shipPostedSubAr => shipPostedSub;
  static String get accountCreatedAr => accountCreated;
  static String get accountCreatedSubAr => accountCreatedSub;
  static String get emptyTripsAr => emptyTrips;
  static String get emptyTripsSubAr => emptyTripsSub;
  static String get emptyShipsAr => emptyShips;
  static String get emptyShipsSubAr => emptyShipsSub;
  static String get emptyOrdersAr => emptyOrders;
  static String get emptyOrdersSubAr => emptyOrdersSub;
  static String get emptyNotifsAr => emptyNotifs;
  static String get emptyNotifsSubAr => emptyNotifsSub;
  static String get emptySearchAr => emptySearch;
  static String get emptySearchSubAr => emptySearchSub;
  static String get kgAr => kg;
  static String get sloganAr => slogan;
}
