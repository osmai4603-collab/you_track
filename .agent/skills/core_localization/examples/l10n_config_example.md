# إعداد ملف `l10n.yaml` (L10n Configuration Example)

يتحكم هذا الملف في كيفية توليد كلاسات الترجمة في المشروع.

```yaml
# l10n.yaml
arb-dir: lib/core/localization
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/core/localization
```

## 🛡️ شرح الإعدادات:
*   `arb-dir`: المجلد الذي يحتوي على ملفات الـ ARB.
*   `template-arb-file`: الملف المرجعي الذي تُبنى عليه الكلاسات (يجب أن يحتوي على الأوصاف `@`).
*   `output-localization-file`: اسم الملف الأساسي المولد.
*   `output-dir`: مكان وضع الملفات المولدة (يُفضل وضعه داخل `lib` وليس في `.dart_tool` لسهولة الوصول).
