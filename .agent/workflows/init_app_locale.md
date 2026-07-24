---
description: خطوات انشاء كلاس AppLocale
---

# 🏗️ سير العمل: تهيئة ملف اللغات (AppLocale)

تجميع إعدادات الترجمة واللغات المدعومة بشكل مركزي في المشروع.

## 🏗️ خطوات التنفيذ

### 1. إنشاء ملف `lib/core/localization/app_locale.dart`
أضف الكود التالي مع استبدال `[app_name]` باسم مشروعك:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:[app_name]/lib/core/localization/app_localizations.dart';

sealed class AppLocale {
  const AppLocale._();

  static const Locale ar = Locale('ar');
  static const Locale en = Locale('en');

  static const List<Locale> supportedLocales = [ar, en];

  static const List<LocalizationsDelegate> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
```

## ⚠️ قواعد ذهبية
*   يجب استخدام `AppLocale.supportedLocales` و `AppLocale.localizationsDelegates` داخل الـ `MaterialApp` لضمان عمل الترجمة بشكل صحيح.
*   تأكد من استيراد `AppLocalizations` المولد آلياً.