---
description: كيفية إضافة صورة جديدة (App Asset) وإدارتها عبر الثوابت
---

# 🖼️ سير العمل: تهيئة الصور (AppAssets)

تجميع مسارات الصور في `lib/core/constants/app_assets.dart` لتجنب استخدام الـ Strings المباشرة.

## 🏗️ الخطوات

1.  تأكد من وجود الصورة في مجلد `assets/images/`.
2.  أضف المسار في `lib/core/constants/app_assets.dart`.
3.  يجب أن يبدأ اسم الثابت بـ `img`.

```dart
sealed class AppAssets {
  const AppAssets._();

  static const String imgLogo = 'assets/images/img_logo.png';
  static const String imgPlaceholder = 'assets/images/img_placeholder.jpg';
}
```

## ⚠️ قواعد ذهبية
*   دائماً أضف الصورة في `pubspec.yaml` تحت `assets`.
*   استخدم `AppAssets.imgName` للوصول للصور من أي مكان.
*   تأكد من تنظيف اللاحقة `.png` أو `.jpg` لنمط منظم.
