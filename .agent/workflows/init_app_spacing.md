---
description: كيفية إضافة ثوابت المسافات (App Spacing) لضمان اتساق الواجهات
---

# 📐 سير العمل: تهيئة المسافات (AppSpacing)

نظام موحد للمسافات (H & V) في `lib/core/constants/app_spacing.dart`.

## 🏗️ الخطوات

1.  افتح ملف `lib/core/constants/app_spacing.dart`.
2.  أضف القيمة للمسمى المناسب (extraSmall, small, medium, large, extraLarge).

```dart
sealed class AppSpacing {
  const AppSpacing._();

  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
}
```

## ⚠️ قواعد ذهبية
*   يجب استخدام المسميات المعيارية (extraSmall, small, ...).
*   لا تستخدم `SizedBox` بمسافات عشوائية، دائماً ارجع لهذ الملف.
