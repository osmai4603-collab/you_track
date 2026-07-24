---
description: تعريف مفاتيح التفضيلات (App Preferences Keys) في المشروع
---

# 🔑 سير العمل: تهيئة مفاتيح التخزين (AppPrefs)

إدارة مفاتيح الـ `Shared Preferences` في `lib/core/constants/app_prefs.dart` لمنع الأخطاء المطبعية (Typos).

## 🏗️ خطوات التنفيذ

1.  افتح ملف `lib/core/constants/app_prefs.dart`.
2.  أضف مفتاح التخزين كـ `static const String`.

```dart
sealed class AppPrefs {
  const AppPrefs._();

  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String id = 'id';
}
```

## ⚠️ قواعد ذهبية
*   يجب أن يكون اسم المتغير مطابقاً لقيمته (Snake Case).
*   لا تستخدم String مباشرة عند القراءة أو الكتابة في التخزين المحلي.
