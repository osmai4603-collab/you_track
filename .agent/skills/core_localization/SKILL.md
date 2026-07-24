---
name: إدارة الترجمة (Core Localization)
description: القواعد والخطوات لإضافة مفاتيح ترجمة جديدة ودعم اللغات (العربية والإنجليزية).
---

# مهارة إدارة الترجمة (Core Localization)

استخدم هذه المهارة لإدارة جميع نصوص الواجهة والرسائل في المشروع، لضمان دعم تعدد اللغات (Localization) ومنع استخدام النصوص الثابتة (Hardcoded Strings).

## 💡 أولاً: متى وكيف تطلب استخدام هذه المهارة؟
*   **متى؟**: تُستخدم هذه المهارة عند إضافة نصوص جديدة للمشروع، أو تهيئة نظام الترجمة لأول مرة، أو تعريب واجهات كاملة.
*   **كيف؟**: اطلب "أضف ترجمة لرسالة الحفظ" أو "قم بتعريب صفحة الإعدادات"، وسأقوم بتحديث ملفات الـ ARB المناسبة.

## 📂 ثانياً: الهيكل والموقع (Structure & Location)
تتواجد جميع ملفات الترجمة في `lib/core/localization/` لضمان الفصل التام عن منطق الأعمال والواجهات:

```text
lib/core/localization/
├── app_ar.arb             # ملف ترجمة اللغة العربية
├── app_en.arb             # ملف ترجمة اللغة الإنجليزية
├── app_locale.dart         # تعريف اللغات والـ Locale المدعومة
├── l10n.yaml              # إعدادات التوليد
├── app_localizations.dart # الكلاس الأساسي المولد للترجمة
├── app_localizations_ar.dart # الكلاس الخاص باللغة العربية (AppLocalizationsAr)
└── app_localizations_en.dart # الكلاس الخاص باللغة الإنجليزية (AppLocalizationsEn)
```

## 📦 ثالثاً: المكتبات المطلوبة (Required Libraries)
*   **المكتبات التي تحتاجها هذه المهارة**:
    *   `flutter_localizations`: لدعم اللغات الأساسية في Flutter.
    *   `intl`: لمعالجة التواريخ والأرقام والعملات حسب الثقافة.

*   **خطوات التنفيذ**:
    *   يجب تشغيل الأوامر التالية لإضافة المكتبات البرمجية:
        ```bash
        flutter pub add flutter_localizations --sdk=flutter
        flutter pub add intl
        ```
    *   > [!NOTE]
    *   > بعد إضافة المكتبات، يجب استدعاء الأمر `flutter pub get` للتأكد من تحديث كافة الاعتمادات.
    *   > [!IMPORTANT]
    *   > يجب التأكد من تضمين مكتبات `flutter_localizations` و `intl` بإصدارات تتوافق تماماً مع إصدار Flutter المستخدم في المشروع الحالي لضمان استقرار نظام الترجمة.

## 🔄 رابعاً: خطوات العمل الإجرائية عند اضافة نصوص جديدة (Procedural Workflow)
عند إضافة نصوص جديدة، اتبع المسار التالي:

1.  **التهيئة**: تأكد من تهيئة ملف اللغات الأساسي باستخدام [سير عمل تهيئة ملف اللغات](../../workflows/init_app_locale.md).
2.  **تحديث المصادر**: إضافة المفاتيح والترجمات في `app_en.arb` و `app_ar.arb` طبقاً لـ [localization_rules.md](../../rules/localization_rules.md).
3.  **توليد الأكواد**: تشغيل أمر التوليد `flutter gen-l10n`. سينتج عن ذلك تحديث/إنشاء `app_localizations.dart` والكلاسات التابعة له (`AppLocalizationsAr` و `AppLocalizationsEn`).
4.  **الاستخدام**: استدعاء النص المترجم في الواجهة عبر `AppLocalizations.of(context)!` باستخدام البدء بالمتغير المحلي `localization`.

---

## 🔗 روابط ومصادر إضافية (Examples & Resources)
*   **معايير الترجمة الاحترافية**: [localization_standards.md](resources/localization_standards.md)
*   **دليل معالجة التواريخ (Intl)**: [intl_guide.md](resources/intl_guide.md)
*   **مثال ملفات ARB**: [arb_example.md](examples/arb_example.md)
*   **مثال إعداد `l10n.yaml`**: [l10_config_example.md](examples/l10n_config_example.md)
*   **مثال الاستخدام العملي**: [usage_example.md](examples/usage_example.md)
