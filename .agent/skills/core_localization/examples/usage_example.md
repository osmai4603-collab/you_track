# مثال الاستخدام العملي (Practical Usage Example)

يوضح هذا المثال كيفية استهلاك الترجمة داخل الـ UI بطريقة احترافية تتبع معايير المشروع.

## 1. التعريف داخل الـ Widget
يجب دائماً الحصول على نسخة من `AppLocalizations` داخل دالة الـ `build` وتجنب الاستدعاء المباشر المتكرر.

```dart
import 'package:flutter/material.dart';
// استيراد الكلاس المولد
import '../core/localization/app_localizations.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على متغير الترجمة (Localization)
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // استخدام نص بسيط
        title: Text(localization.appTitle),
      ),
      body: Center(
        child: Column(
          children: [
            // استخدام نص مع معلمات (Parameters)
            Text(localization.welcomeMessage('Ahmed')),
            
            const SizedBox(height: 20),
            
            // ⚠️ تنبيه: لا تستخدم const مع ElevatedButton هنا لأن بداخله نص مترجم
            ElevatedButton(
              onPressed: () {},
              child: Text(localization.save),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 2. استخدام التنسيقات (Formatting) عبر `intl`
لمعالجة الأرقام والتواريخ:

```dart
import 'package:intl/intl.dart';

// تنسيق العملة حسب لغة التطبيق الحالية
String formatCurrency(double amount, String locale) {
  return NumberFormat.simpleCurrency(locale: locale).format(amount);
}
```

## ⚠️ قاعدة ذهبية (Golden Rule):
لا تستخدم أبداً `Text('Some String')`. إذا وجدت نصاً ثابتاً، فهو خطأ يجب تصحيحه فوراً بإضافته إلى ملفات الـ ARB.
