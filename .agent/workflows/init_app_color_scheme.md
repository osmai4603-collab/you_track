# دليل مخطط الألوان (App Color Scheme Guide)

توضح هذه الصفحة القواعد الصارمة لبناء وتوزيع الألوان في مخطط الألوان (ColorScheme).

## 🌈 مخطط الألوان (`app_color_scheme.dart`)

يربط هذا الملف بين الألوان الخام في `AppColors` وخصائص Material 3 في Flutter.

### القواعد الصارمة للتوزيع:
1.  **العلامة التجارية (Brand)**:
    *   `primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`: تُستقى من فئة `brand`.
2.  **المعلومات والعمليات (Info & Secondary)**:
    *   `secondary`, `onSecondary`, `secondaryContainer`, `onSecondaryContainer`: تُستقى من فئة `info`.
3.  **النجاح (Success & Tertiary)**:
    *   `tertiary`, `onTertiary`, `tertiaryContainer`, `onTertiaryContainer`: تُستقى من فئة `success`.
4.  **الأخطاء (Error)**:
    *   `error`, `onError`, `errorContainer`, `onErrorContainer`: تُستقى من فئة `error`.
5.  **الأسطح والمحايد (Surface & Neutral)**:
    *   `surface`, `onSurface`, `surfaceContainer` (بجميع درجاتها): تُستقى من فئة `neutral`.
    *   `shadow`, `scrim`: تُستقى من فئة `neutral` بدرجات (400 أو 600).

### القيود البرمجية:
*   يجب أن يكون الكلاس `sealed class`.
*   **التحديد اليدوي الكامل**: يجب تعريف جميع الخصائص يدوياً.
*   **منع التوليد التلقائي**: يُمنع استخدام `ColorScheme.fromSeed`.
*   **تجنب المهجور**: يُمنع استخدام الخصائص المهجورة مثل `background` أو `surfaceVariant`.

### 🚨 قواعد صارمة (Strict Rules):
*   **التوافق مع Material 3**: يجب عدم استخدام `ColorScheme.light` أو `ColorScheme.dark` الجاهزة؛ استخدم الـ `Default Constructor`.
*   **الوصول للسياق**: دالة `of(context)` هي الطريقة المعتمدة للوصول لمخطط الألوان في الواجهات.
*   **الارتباط المطلق**: كل خاصية في المخطط يجب أن ترتبط حصراً بمتغير من `AppColors`.
*   **تجنب المهجور (Deprecated)**: يُمنع منعاً باتاً استخدام الخصائص المهجورة مثل `background` أو `onBackground` أو `surfaceVariant`.
*   **تجنب الخصائص الثابتة (Fixed Roles)**: يُمنع استخدام الخصائص التي تحتوي على كلمة `fixed` (مثل `primaryFixed`, `secondaryFixed`, إلخ) لتبسيط التصميم والاعتماد على الأدوار القياسية.


### 📝 مثال تطبيقي شامل (Applied Example):
```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

sealed class AppColorScheme {
  static final light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.light.brand.color500,
    onPrimary: AppColors.light.brand.color50,
    // ... (تكملة جميع الخصائص يدوياً)
    error: AppColors.light.error.color600,
    onError: AppColors.light.neutral.color50,
    surface: AppColors.light.neutral.color50,
    onSurface: AppColors.light.neutral.color900,
  );

  static final dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.dark.brand.color500,
    onPrimary: AppColors.dark.brand.color900,
    // ... (dark mode properties)
    surface: AppColors.dark.neutral.color900,
    onSurface: AppColors.dark.neutral.color50,
  );

  static ColorScheme of(BuildContext context) => Theme.of(context).colorScheme;
}
```

> [!TIP]
> تأكد دائماً من تحقيق تباين عالي (Contrast) بين لون الحاوية (Container) ولون النص الذي يعلوها (OnContainer).

