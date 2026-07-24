# دليل سمات النصوص (App Text Theme Guide)

توضح هذه الصفحة كيفية بناء وتوزيع أنماط النصوص (Text Styles) في التطبيق.

## 📝 سمات النصوص (`app_text_theme.dart`)

يربط هذا الملف بين أحجام الخطوط وعائلات الخطوط لتكوين الـ `TextTheme` المعتمد.

### التصنيفات المدعومة (15 نمطاً):
1.  **Display**: للعناوين الكبيرة جداً والبارزة.
    *   `displayLarge`, `displayMedium`, `displaySmall`
2.  **Headline**: للعناوين الرئيسية في الصفحات.
    *   `headlineLarge`, `headlineMedium`, `headlineSmall`
3.  **Title**: لعناوين العناصر والقوائم.
    *   `titleLarge`, `titleMedium`, `titleSmall`
4.  **Body**: للنصوص الطويلة والمحتوى الأساسي.
    *   `bodyLarge`, `bodyMedium`, `bodySmall`
5.  **Label**: للنصوص الصغيرة، التنبيهات، وعناوين الأزرار.
    *   `labelLarge`, `labelMedium`, `labelSmall`


### القواعد:
*   يجب أن يكون الكلاس `sealed class` باسم `AppTextTheme`.
*   يحتوي على ثابت `static const TextTheme textTheme` **يجب أن يغطي كافة الخصائص الـ 15 بالكامل**.
*   يُمنع استخدام `GoogleFonts` داخل هذا الملف؛ استخدم القيم من `AppFonts` و `AppFontSizes`.


### 🚨 قواعد صارمة (Strict Rules):
*   **ثبات الأنماط**: لا تُضف أنماطاً خارج التصنيفات الـ 15 القياسية لـ Material 3 في هذا الملف.
*   **منع تعريف الألوان**: التزم بعدم تعريف `color` داخل `TextStyle` هنا؛ ليتم توريث اللون تلقائياً من الثيم بناءً على مكان الاستخدام.
*   **استخدام الثوابت**: يجب استقاء كافة الأحجام والعائلات من ملفات `AppFontSizes` و `AppFonts`.

### 📝 مثال تطبيقي شامل (Applied Example):
```dart
import 'package:flutter/material.dart';
import 'app_font_sizes.dart';
import 'app_fonts.dart';

sealed class AppTextTheme {
  // يجب تعريف كافة الخصائص الـ 15 (Large, Medium, Small) لكل فئة
  static const textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: AppFonts.primary,
      fontSize: AppFontSizes.s32,
      fontWeight: FontWeight.bold,
    ),
    // ... (تكملة جميع الخصائص الـ 15 بالكامل)
  );
}
```

> [!TIP]
> اجعل أنماط النصوص مرنة بحيث تعمل بشكل جيد مع الوضعين الفاتح والداكن عبر الاعتماد على الـ `onSurface` الافتراضي في الـ `ThemeData`.

