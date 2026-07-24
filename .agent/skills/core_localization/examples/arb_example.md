# مثال ملفات الـ ARB (ARB Files Example)

تعتبر ملفات الـ ARB (Application Resource Bundle) هي المصدر الوحيد للنصوص في المشروع.

## 1. ملف اللغة الإنجليزية (`app_en.arb`)
هذا هو الملف القالب (Template) الذي يحدد المفاتيح والمعلمات.

```json
{
  "@@locale": "en",
  "appTitle": "Stitch Brand Color",
  "@appTitle": {
    "description": "The title of the application"
  },
  "save": "Save",
  "@save": {
    "description": "Generic save button text"
  },
  "welcomeMessage": "Welcome back, {name}!",
  "@welcomeMessage": {
    "description": "Greeting message with user name",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Ahmed"
      }
    }
  }
}
```

## 2. ملف اللغة العربية (`app_ar.arb`)
يحتوي على الترجمات المقابلة.

```json
{
  "@@locale": "ar",
  "appTitle": "ستيتش لألوان العلامة التجارية",
  "save": "حفظ",
  "welcomeMessage": "مرحباً بك مجدداً، {name}!"
}
```

## 💡 ملاحظات هامة:
*   `@@locale`: يحدد لغة الملف.
*   `@key`: يضاف للمفاتيح في ملف القالب (غالباً الإنجليزي) لوصف السياق والمساعدة في الترجمة الآلية أو البشرية.
*   `placeholders`: تستخدم للمتغيرات الديناميكية داخل النصوص.
