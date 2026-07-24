# بناء ملفات النواة (Core Files Implementation)

توضح هذه الصفحة التفاصيل الفنية لبناء الكلاسات الأساسية والأدوات المساعدة في طبقة النواة (Core Layer).

## 🛠️ تفاصيل التنفيذ

### 1. المكتبات المطلوبة (Required Libraries)
*   **المكتبات التي تحتاجها هذه الملفات**:
    *   `equatable`: لتبسيط عملية مقارنة الكائنات.
    *   `fpdart`: لتطبيق أنماط البرمجة الوظيفية (مثل `Either`).
    *   `get_it`: لإدارة وحقن التبعات (Dependency Injection) في التطبيق.

*   **خطوات التنفيذ**:
    *   يجب تشغيل الأوامر التالية لإضافة المكتبات البرمجية:
        ```bash
        flutter pub add equatable fpdart get_it
        ```
    *   > [!NOTE]
    *   > بعد إضافة المكتبات، يجب استدعاء الأمر `flutter pub get` للتأكد من تحديث كافة الاعتمادات.

### 2. الكلاسات والثوابت الأساسية (Core Classes & Constants)

> [!TIP]
> تم نقل تفاصيل تنفيذ هذه الكلاسات والثوابت إلى مسارات عمل (Workflows) منفصلة لضمان التخصص وسهولة الوصول. يرجى مراجعة المسارات التالية:
> *   **الأخطاء وحالات الاستخدام**: [سير عمل تهيئة الأخطاء (init_failure)](../../../workflows/init_failure.md).
> *   **الأيقونات**: [سير عمل تهيئة الأيقونات (init_app_icons)](../../../workflows/init_app_icons.md).
> *   **الصور**: [سير عمل تهيئة الصور (init_app_assets)](../../../workflows/init_app_assets.md).
> *   **الحواف**: [سير عمل تهيئة الحواف (init_app_radius)](../../../workflows/init_app_radius.md).
> *   **المسافات**: [سير عمل تهيئة المسافات (init_app_spacing)](../../../workflows/init_app_spacing.md).
> *   **التفضيلات**: [سير عمل تهيئة التفضيلات (init_app_prefs)](../../../workflows/init_app_prefs.md).



### 4. حقن التبعات (Dependency Injection)

*   المسار: `lib/core/init_dependencies.dart`.
*   الوظيفة: دالة `initDependencies()` لتسجيل كافة الكلاسات المشتركة باستخدام `GetIt`.

### 5. الخدمات والشبكة (Services & Network)

*   **الخدمات**: في `lib/core/services/` (Storage, DB).
    *   **قاعدة البيانات**: يجب استخدام المسار الخاص بالتطبيق الحالي لتخزين ملف الـ SQLite.
*   **الشبكة**: في `lib/core/services/network/` لإدارة طلبات الـ API.

### 6. خدمة التنسيق (FormatService)

*   **المسار**: `lib/core/services/format_service.dart`.
*   **الوظيفة**: تحويل البيانات الخام (Date, double, int) إلى نصوص مقروءة ومحلية.
*   **القاعدة**: يجب أن يكون الكلاس `sealed class` مع `private constructor`.
*   **يجب أن يبنى هذا الكلاس بهذه الهيكلية:**

```dart
import 'package:intl/intl.dart';

sealed class FormatService {
  const FormatService._();

  static String formatDate(DateTime date, {String pattern = 'yyyy/MM/dd'}) {
    return DateFormat(pattern, 'ar').format(date);
  }

  static String formatNumber(num number) {
    return NumberFormat('#,###.##', 'ar').format(number);
  }

  static String formatCurrency(num amount, {String symbol = 'ر.س'}) {
    return '${formatNumber(amount)} $symbol';
  }
}
```

> [!IMPORTANT]
> جميع ملفات النواة يجب أن تكون مستقلة عن أي منطق خاص بالميزات (Feature-Independent).
