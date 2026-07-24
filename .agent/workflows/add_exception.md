---
description: كيفية إضافة استثناء (Exception) جديد يتبع معايير المشروع و Clean Architecture.
---

# 📖 سير العمل: إضافة استثناء (Create Exception)

يُعرف الاستثناء (Exception) في طبقة الـ Core أو الـ Data لتمثيل الأخطاء التقنية التي تحدث في مصادر البيانات.

اتبع الخطوات التالية بدقة عند إضافة أي Exception جديد:

## 📂 أولاً: الموقع والتسمية
1.  **المسار**: `lib/core/errors/`.
2.  **اسم الملف**: يجب أن يكون `snake_case` وينتهي بـ `_exception.dart`.
    *   *مثال*: `server_exception.dart`.
3.  **اسم الكلاس**: يجب أن يكون `PascalCase` وينتهي بـ `Exception`.
    *   *مثال*: `ServerException`.

## 🏗️ ثانياً: الهيكلية البرمجية

### 1. التعريف (Definition)
*   يجب أن يقوم الكلاس بعمل **`implements Exception`**.
*   يُفضل إضافة حقل `message` لتخزين تفاصيل الخطأ.
*   **ملف مستقل**: يجب أن يكون لكل Exception ملف مستقل تماماً، ولا يُسمح بدمجه في ملف واحد مع استثناءات أخرى.

### 2. الربط مع الفشل (Link with Failures)
*   **قاعدة ذهبية**: كل `Exception` يجب أن يتحول إلى `Failure` في طبقة المستودع (Repository).

---

## 📝 ثالثاً: نموذج تطبيقي (Template)

```dart
/// استثناء ناتج عن [وصف الخطأ التقني].
class ExampleException implements Exception {
  final String message;
  const ExampleException([this.message = 'An error occurred']);

  @override
  String toString() => 'ExampleException: $message';
}
```

---
