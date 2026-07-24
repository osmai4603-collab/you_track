# دليل عائلات الخطوط (App Fonts Guide)

تحدد هذه الصفحة الخطوط (Font Families) المستخدمة في المشروع.

## 🖋️ عائلات الخطوط (`app_fonts.dart`)

يتم تعريف أسماء الخطوط في ملف منفصل لضمان كتابتها بشكل صحيح في كامل التطبيق.

### القواعد:
*   يجب أن يكون الكلاس `sealed class`.
*   يحتوي على قيم `static const String`.

### 🚨 قواعد صارمة (Strict Rules):
*   **التطابق**: يجب أن يتطابق اسم الخط تماماً مع الاسم المعرف في `pubspec.yaml`.
*   **تجنب الـ Hardcoding**: يُمنع كتابة اسم الخط كـ `String` مباشر في أي مكان؛ استخدم `AppFonts`.

### 📝 مثال تطبيقي شامل (Applied Example):
```dart
sealed class AppFonts {
  static const String primary = 'Inter';
  static const String secondary = 'Cairo';
}
```

> [!IMPORTANT]
> تأكد من تعريف الخطوط في ملف `pubspec.yaml` قبل استخدامها هنا.

