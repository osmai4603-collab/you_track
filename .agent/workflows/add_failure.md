---
description: كيفية إضافة فاشل (Failure) جديد يتبع معايير المشروع و Clean Architecture.
---

# 📖 سير العمل: إضافة فاشل (Create Failure)

يُعرف الفاشل (Failure) في طبقة الـ Core أو الـ Domain لتمثيل الأخطاء التي يتم إخطار واجهة المستخدم (UI) بها. لكل فاشل (Failure) يجب أن يوجد استثناء (Exception) مقابل له في طبقة الـ Data.

اتبع الخطوات التالية بدقة عند إضافة أي Failure جديد:

## 📂 أولاً: الموقع والتسمية
1.  **المسار**: `lib/core/errors/`.
2.  **اسم الملف**: يجب أن يكون `snake_case` وينتهي بـ `_failure.dart`.
    *   *مثال*: `server_failure.dart`.
3.  **اسم الكلاس**: يجب أن يكون `PascalCase` وينتهي بـ `Failure`.
    *   *مثال*: `ServerFailure`.

## 🏗️ ثانياً: الهيكلية البرمجية

### 1. الوراثة (Inheritance)
*   يجب أن يرث الفاشل من الكلاس الأساسي **`Failure`** (الموجود في `lib/core/errors/failure.dart`).
*   **ملف مستقل**: يجب أن يكون لكل Failure ملف مستقل تماماً، ولا يُسمح بدمجه في ملف واحد مع Failures أخرى.

### 2. الربط مع الاستثناءات (Link with Exceptions)
*   **قاعدة ذهبية**: كل `Failure` يجب أن يقابله `Exception` واحد على الأقل في طبقة الـ Data.

---

## 📝 ثالثاً: نموذج تطبيقي (Template)

```dart
import 'package:[app_name]/core/errors/failure.dart';

/// فشل ناتج عن [وصف الخطأ].
class ExampleFailure extends Failure {
  const ExampleFailure([super.message]);
}
```

---
> [!IMPORTANT]
> استكمالاً لمعايير المشروع، تأكد من إنشاء الـ **Exception** المقابل لهذا الفاشل باستخدام سير العمل المسمى بـ `add_exception.md`.
