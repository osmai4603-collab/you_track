---
description: كيفية تهيئة كلاس الـ Entity الأساسي في المشروع يتبع معايير Clean Architecture.
---

# 📖 سير العمل: تهيئة كلاس الـ Entity الأساسي (Initialize Base Entity)

يُعتبر كلاس `Entity` هو الأب الروحي لجميع الكائنات في طبقة الـ Domain. يتم استخدامه لتوفير واجهة موحدة للتعامل مع البيانات والثبات (Immutability).

اتبع الخطوات التالية للتهيئة:

## 📂 أولاً: الموقع والتسمية
1.  **المسار**: `lib/core/entities/`.
2.  **اسم الملف**: `entity.dart`.
3.  **اسم الكلاس**: `Entity`.

## 🏗️ ثانياً: الهيكلية البرمجية

### 1. الوراثة (Inheritance)
*   يجب أن يرث من **`Equatable`** لتسهيل مقارنة الكائنات.
*   **ملف مستقل**: يجب أن يكون في مجلد الـ core.

### 2. التوابع الأساسية (Base Methods)
*   `copyWith()`: لإنشاء نسخة جديدة من الكائن مع تعديلات محددة.

---

## 📝 ثالثاً: نموذج التهيئة (Initialization Template)

```dart
import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  const Entity();
  
  // دالة النسخ الأساسية ليتم تجاوزها في الأبناء
  Entity copyWith();

  @override
  bool? get stringify => true;
}
```

## ⚠️ قواعد إجبارية
*   **دائماً**: اجعل الكلاس `abstract`.
*   **دائماً**: استخدم `const` في الباني لضمان الثبات وتحسين الأداء.
*   **دائماً**: يجب أن ترث جميع الكائنات (Entities) في المشروع من هذا الكلاس.

---
> [!IMPORTANT]
> عند إنشاء كائن جديد لميزة محددة، يجب أن يرث من هذا الكلاس `Entity` بدلاً من `FlowEntity` القديم. راجع سير العمل [add_entity.md](add_entity.md).
