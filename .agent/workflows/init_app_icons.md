---
description: خطوات تهيئة كلاس AppIcons
---

# 🎨 سير العمل: تهيئة الأيقونات (AppIcons)

نظام موحد لتخزين الأيقونات في `lib/core/constants/app_icons.dart` لضمان سهولة التخصيص.

## 🏗️ الخطوات

1.  افتح ملف `lib/core/constants/app_icons.dart`.
2.  يجب أن يكون جميع الحقول من نوع `IconData`.
3. ان تكون جميع الحقول `static const`.
4. اعمل comment لكل حقل توضح ماهي ايقونة الحقل باللغة العربية

```dart
import 'package:flutter/material.dart';

sealed class AppIcons {
  const AppIcons._();

  // ايقونة الصفحة الرئيسية
  static const IconData home = Icons.home;
  static const IconData settings = Icons.settings;
  static const IconData menu = Icons.menu;
}
```

