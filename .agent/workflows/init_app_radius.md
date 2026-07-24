---
description: كيفية إضافة ثوابت الحواف (App Radius) لضمان اتساق الواجهات
---

# 📐 سير العمل: تهيئة الحواف (AppRadius)

نظام موحد لنصف قطر الزوايا في `lib/core/constants/app_radius.dart`.

## 🏗️ الخطوات

1.  افتح ملف `lib/core/constants/app_radius.dart`.
2.  أضف القيمة للمسمى المناسب (extraSmall, small, medium, large, extraLarge).

```dart
sealed class AppRadius {
  const AppRadius._();

  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 24.0;
}
```

## ⚠️ قواعد ذهبية
*   يجب استخدام المسميات المعيارية (extraSmall, small, ...).
*   لا تستورد قيم حواف مباشرة (Hard-coded) في الـ Widgets.
