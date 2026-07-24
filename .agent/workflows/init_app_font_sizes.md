# دليل أحجام الخطوط (App Font Sizes Guide)

تحدد هذه الصفحة أحجام الخطوط القياسية المستخدمة في التطبيق لضمان الاتساق البصري.

## 📏 أحجام الخطوط (`app_font_sizes.dart`)

يتم تعريف الأحجام في كلاس `AppFontSizes` لتسهيل تغييرها مستقبلاً في كامل التطبيق.

### القواعد:
*   يجب أن يكون الكلاس هو `AppFontSizes` من نوع `sealed class`.
*   يحتوي على قيم `static const double` فقط.
*   تُسمى المتغيرات بأسماء واضحة (مثل `s12`, `s14`, `s24`).

### 🚨 قواعد صارمة (Strict Rules):
*   **ثبات القيم**: لا تُغير قيمة حجم خط موجود مسبقاً إذا كان مستخدماً في الواجهات؛ أضف حجماً جديداً إذا لزم الأمر.
*   **منع الأرقام المباشرة (Magic Numbers)**: يُمنع كتابة حجم الخط يدوياً في `TextStyle`؛ استخدم دائماً `AppFontSizes`.

### 📝 مثال تطبيقي شامل (Applied Example):
```dart
sealed class AppFontSizes {
  // Display
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;

  // Headline
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;

  // Title
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;

  // Body
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;

  // Label
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
}
```

> [!NOTE]
> يفضل دائماً استخدام مضاعفات الرقم 2 أو 4 في تحديد أحجام الخطوط.

