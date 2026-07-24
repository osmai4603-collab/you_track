# 📚 دليل مكتبة (Intl) مع الترجمة (Intl & Formatting Guide)

يستخدم المشروع مكتبة `intl` مع `AppLocalizations` لمعالجة التواريخ، الأرقام والعملات بصورة محلية (Localized).

## 1. تنسيق التواريخ (Date Formatting)

استخدم `DateFormat` مع `locale` الخاص بـ `AppLocalizations`:
```dart
import 'package:intl/intl.dart';

// ... داخل الـ build
final localization = AppLocalizations.of(context)!;
final locale = localization.localeName; // سيظهر 'ar' أو 'en'

// تنسيق التاريخ لليوم/الشهر/السنة باللغة الحالية
String formattedDate = DateFormat.yMd(locale).format(DateTime.now());
// النتيجة في العربية: 2024/05/20
// النتيجة في الإنجليزية: 05/20/2024
```

## 2. تنسيق الأرقام والعملات (Number & Currency)

لتنسيق الأرقام بصورة طبيعية (مثل استخدام الفاصلة العربية أو الإنجليزية):
```dart
import 'package:intl/intl.dart';

// ... داخل الـ build
final locale = AppLocalizations.of(context)!.localeName;

// تنسيق الأرقام بصورة محلية
String numbers = NumberFormat.decimalPattern(locale).format(1234567.89);
// العربية: ١٬٢٣٤٬٥٦٧٫٨٩
// الإنجليزية: 1,234,567.89

// تنسيق العملات (مثال: الريال السعودي)
String currency = NumberFormat.simpleCurrency(
  locale: locale,
  name: 'SAR',
).format(1200.59);
// العربية: ١٬٢٠٠٫٥٩ ر.س.‏
// الإنجليزية: 1,200.59 SAR
```

## 3. رسائل الجمع والتأنيث في ARB (Plural & Gender)

يمكنك تعريف رسائل الجمع في ملف الـ ARB بصورة متقدمة:

**ARB File:**
```json
{
  "cartItemCount": "{count, plural, =0{السلة فارغة} =1{قطعة واحدة} =2{قطعتان} other{{count} قطع}}"
}
```

**Dart Code:**
```dart
final count = 5;
String message = localization.cartItemCount(count);
// النتيجة: ٥ قطع
```

---
> [!TIP]
> تذكر دائماً تمرير `localization.localeName` لضمان اتساق الشكل المحلي للأرقام والتواريخ.
