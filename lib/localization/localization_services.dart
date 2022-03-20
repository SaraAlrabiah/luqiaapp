import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'lang/ar_AR.dart';
import 'lang/en_US.dart';

class LocalizationService extends Translations {
  // Default locale
  static final locale = Locale('en', 'US');

  // fallbackLocale saves the day when the locale gets in trouble
  static final fallbackLocale = Locale('ar', 'AE');

  // Supported languages
  // Needs to be same order with locales
  static final langs = ['English',  'Arabic'];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    const Locale('en', 'US'),
    const Locale('ar', 'AE'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS, // lang/en_us.dart
    'ar_AE': arAE, // lang/ar_AE.dart
  };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = getLocaleFromLanguage(lang);

    final box = GetStorage();
    box.write('lng', lang);

    Get.updateLocale(locale!);
    print(locale);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale? getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }

  Locale? getCurrentLocale() {
    final box = GetStorage();
    Locale? defaultLocale;

    if (box.read('lng') != null) {
      final locale =
      LocalizationService().getLocaleFromLanguage(box.read('lng'));

      defaultLocale = locale;
    } else {
      defaultLocale = const Locale(
        'en',
        'US',
      );
    }

    return defaultLocale;
  }

  String getCurrentLang() {
    final box = GetStorage();

    return box.read('lng') ?? "English";
  }
}