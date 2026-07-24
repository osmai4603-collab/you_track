# دليل بناء الثيم العام (App Theme Guide)

توضح هذه الصفحة كيفية تجميع كافة مكونات الهوية البصرية في كائن `ThemeData` النهائي.

## 🏛️ الثيم العام (`app_theme.dart`)

يمثل هذا الملف نقطة التجميع النهائية للهوية البصرية.

### القواعد البرمجية:
*   يجب أن يكون الكلاس `sealed class` باسم `AppTheme`.
*   يحتوي على `static ThemeData get lightTheme` و `darkTheme`.
*   **دالة التجميع (`_buildTheme`)**:
    *   يجب أن تكون `private`.
    *   تستقبل البارامترات كـ **Named Arguments**.
    *   يجب أن تستقبل قائمة من السمات المخصصة `Iterable<ThemeExtension<dynamic>>? extensions`.
    *   يتم إسناد الـ `textTheme` الممرر لخاصية `textTheme` يدوياً.
    *   يتم تمرير القائمة المستلمة `extensions` لخاصية `extensions` داخل `ThemeData`.

### دالة الوصول:
*   يحتوي على دالة `static ThemeData of(BuildContext context)` لإرجاع الثيم الحالي بناءً على إعدادات النظام.

### 🚨 قواعد صارمة (Strict Rules):
*   **التجريد التام**: يُمنع استخدام أي ويدجت (Widget) داخل هذا الملف؛ الاعتماد فقط على كلاسات التوصيف.
*   **فصل الأنماط**: يجب أن يتم بناء الثيم عبر الدالة الخاصة `_buildTheme` لضمان توحيد الإعدادات المشتركة بين الثيمين.
*   **السمات المخصصة**: يجب تسجيل كافة الـ `Extensions` في كلا الثيمين (الفاتح والداكن).

### 📝 مثال تطبيقي شامل (Applied Example):
```dart
import 'package:flutter/material.dart';
import 'app_color_scheme.dart';
import 'app_text_theme.dart';

sealed class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    colorScheme: AppColorScheme.light,
    textTheme: AppTextTheme.textTheme,
    extensions: [
        // AppShadowThemeExtension(softShadow: ...)
    ],
  );

  static ThemeData get darkTheme => _buildTheme(
    colorScheme: AppColorScheme.dark,
    textTheme: AppTextTheme.textTheme,
    extensions: [
        // AppShadowThemeExtension(softShadow: ...)
    ],
  );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    Iterable<ThemeExtension<dynamic>>? extensions,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      extensions: extensions,
    );
  }

  static ThemeData of(BuildContext context) => Theme.of(context);
}
```

> [!CAUTION]
> لا تضف أي منطق خاص بالواجهات داخل هذا الملف؛ وظيفته هي التوصيف فقط.

