# بناء منسق البيانات (AppFormatter Implementation)

يوضح هذا الدليل كيفية بناء كلاس `AppFormatter` المسؤول عن تنسيق وعرض البيانات (مثل التواريخ، الأرقام، والعملات) بصورة محلية (Localized) بناءً على لغة المستخدم الحالية.

## 📂 موقع الملف والمسار
*   **المسار**: `lib/core/utils/app_formatter.dart`
*   **التبعية الأساسية**: يعتمد بشكل كلي على مكتبة `intl`.

## 🏗️ الهيكلية البرمجية المقترحة

```dart
import 'package:intl/intl.dart';

sealed class AppFormatter {
  /// تنسيق التاريخ بصيغة (يوم/شهر/سنة) حسب اللغة
  static String formatDate(DateTime date, String locale) {
    return DateFormat.yMd(locale).format(date);
  }

  /// تنسيق العملات (مثال: الريال السعودي)
  static String formatCurrency(double amount, String locale, {String symbol = 'SAR'}) {
    return NumberFormat.simpleCurrency(
      locale: locale,
      name: symbol,
    ).format(amount);
  }

  /// تنسيق الأرقام مع فواصل الآلاف
  static String formatNumber(num number, String locale) {
    return NumberFormat.decimalPattern(locale).format(number);
  }

  /// تنسيق الأرقام المختصرة (مثل: 1.2K)
  static String formatCompactNumber(num number, String locale) {
    return NumberFormat.compact(locale: locale).format(number);
  }
}
```

## 🛠️ قواعد الاستخدام والدمج مع الترجمة
1.  **تمرير الـ Locale**: يجب دائماً تمرير `localization.localeName` من الواجهة البرمجية لضمان عرض الأرقام والتواريخ باللغة الصحيحة (العربية أو الإنجليزية).
2.  **استقلالية المنطق**: الكلاس يجب أن يكون `static` ولا يحتاج لعمل `instantiate` (عبر استخدام `sealed class` أو `abstract class`).
3.  **التعامل مع القيم الفارغة**: يفضل إضافة تحقق للقيم قبل محاولة تنسيقها لتجنب الأخطاء.

---
> [!IMPORTANT]
> تأكد من مراجعة [دليل مكتبة Intl](../../core_localization/resources/intl_guide.md) لفهم كيفية عمل التنسيقات المتقدمة.
