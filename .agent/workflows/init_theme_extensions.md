# دليل السمات المخصصة (Theme Extensions Guide)

توضح هذه الصفحة كيفية توسيع قدرات الثيم الأساسي لـ Flutter عبر إضافة خصائص مخصصة.

## 🛠️ مجلد السمات المحصصة (`extensions/`)

توضع هنا الكلاسات التي تحمل ألواناً أو تأثيرات لا تتوفر بشكل افتراضي في `ColorScheme`.

### القواعد:
*   يجب أن يرث الكلاس من `ThemeExtension<T>`.
*   يجب أن يكون `final class`.
*   يجب تنفيذ دوال `copyWith` و `lerp`.

### حالات الاستخدام:
*   إضافة ألوان لدرجات محددة من الظلال (Shadows).
*   إضافة تدرجات لونية (Gradients) مخصصة.
*   إضافة خصائص بصرية معقدة لبعض العناصر المخصصة.

### 🚨 قواعد صارمة (Strict Rules):
*   **التفرد**: لا تُضف خاصية موجودة مسبقاً في `ColorScheme`؛ تأكد من الحاجة الفعلية للـ `Extension`.
*   **النمط الموحد**: يجب أن يبدأ اسم الكلاس بـ `App` وينتهي بـ `ThemeExtension` (مثل `AppShadowThemeExtension`).
*   **التوافق**: يجب تنفيذ الـ `lerp` بشكل صحيح لضمان سلاسة الانتقال بين الثيمات.

### 📝 مثال تطبيقي شامل (Applied Example):
```dart
import 'package:flutter/material.dart';

final class AppShadowThemeExtension extends ThemeExtension<AppShadowThemeExtension> {
  final Color softShadow;

  const AppShadowThemeExtension({required this.softShadow});

  @override
  AppShadowThemeExtension copyWith({Color? softShadow}) {
    return AppShadowThemeExtension(softShadow: softShadow ?? this.softShadow);
  }

  @override
  AppShadowThemeExtension lerp(ThemeExtension<AppShadowThemeExtension>? other, double t) {
    if (other is! AppShadowThemeExtension) return this;
    return AppShadowThemeExtension(
      softShadow: Color.lerp(softShadow, other.softShadow, t)!,
    );
  }
}
```

> [!NOTE]
> استخدم الـ `Extensions` فقط عندما تعجز خصائص `ColorScheme` عن تلبية احتياجات التصميم.

