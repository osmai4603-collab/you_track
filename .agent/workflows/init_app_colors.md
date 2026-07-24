# دليل ألوان التطبيق (App Colors Guide)

توضح هذه الصفحة كيفية تعريف وإدارة الألوان الخام (Raw Colors) في المشروع.

## 🎨 كلاس الألوان الخام (`app_colors.dart`)

يتم تعريف الألوان في كلاس `AppColors` لضمان وجود مصدر وحيد للحقيقة لجميع درجات الألوان المستخدمة.

### القواعد البرمجية:
*   يجب استيراد مكتبة الـ `material`.
*   **فئات الألوان (`CategoryColors`)**: كلاس `final` يحتوي على 10 درجات لونية (من 50 إلى 900).
*   **الكلاس الأساسي (`AppColors`)**:
    *   يجب أن يكون `final class`.
    *   يحتوي على `const private constructor` باسم `AppColors._()`.
    *   يحتوي على 6 فئات أساسية: `brand`, `success`, `error`, `warning`, `info`, `neutral`.
    *   يحتوي على نسختين ثابتتين `static const` للوضعين `light` و `dark`.

### 🚨 قواعد صارمة (Strict Rules):
*   **منع الألوان المباشرة**: يُمنع استقاء الألوان من `Colors` أو تعريفها بـ `0xFF...` خارج هذا الملف.
*   **التسمية الموحدة**: يجب أن تتبع التسمية نمط `color50` إلى `color900` داخل كل فئة.
*   **عدم التكرار**: لا تُعرف لوناً مرتين؛ إذا كان اللون مستخدماً في أكثر من مكان، ضعه في الفئة الأقرب لوظيفته.
*   **تجنب المهجور (Deprecated)**: يُمنع استخدام أي قيم لونية مصنفة كـ deprecated في مكتبة Flutter.
*   **تجنب التسمية الثابتة (Fixed)**: لا تستخدم كلمة `fixed` في تسمية متغيرات الألوان لتجنب الخلط مع الـ Fixed Roles في الـ ColorScheme.


### 📝 مثال تطبيقي شامل (Applied Example):
```dart
import 'package:flutter/material.dart';

final class CategoryColors {
  final Color color50;
  // ... (تكملة الدرجات من 100 إلى 800)
  final Color color900;

  const CategoryColors({
    required this.color50,
    required this.color900,
  });
}

final class AppColors {
  AppColors._();

  final CategoryColors brand;
  final CategoryColors neutral;
  // ... (success, error, warning, info)

  static const light = AppColors._(
    brand: CategoryColors(color50: Color(0xFFE3F2FD), color900: Color(0xFF0D47A1)),
    neutral: CategoryColors(color50: Color(0xFFFAFAFA), color900: Color(0xFF212121)),
  );

  static const dark = AppColors._(
    brand: CategoryColors(color50: Color(0xFF1A237E), color900: Color(0xFFE8EAF6)),
    neutral: CategoryColors(color50: Color(0xFF121212), color900: Color(0xFFEEEEEE)),
  );
}
```

> [!IMPORTANT]
> يُمنع استخدام الألوان مباشرة من مكتبة Material (مثل `Colors.blue`)؛ يجب دائماً تعريف اللون في `AppColors` أولاً.

