---
name: بناء الكائنات (Entity Development)
description: القواعد الصارمة والمعايير الهندسية لبناء الكائنات (Entities) في طبقة الـ Domain بـ Clean Architecture.
---

# مهارة بناء الكائنات (Entity Development)

تُعد الكائنات (Entities) حجر الزاوية في طبقة الـ Domain. يجب أن تكون بسيطة، ثباتية (Immutable)، ومستقلة تماماً عن أي تفاصيل خارجية أو مكتبات (باستثناء Equatable).

## 📂 الموقع والتسمية

* **المسار**: `lib/features/[feature_name]/domain/entities/`.
* **اسم الملف**: `snake_case` ينتهي بـ `_entity.dart` (مثال: `product_entity.dart`).
* **اسم الكلاس**: `PascalCase` ينتهي بـ `Entity` (مثال: `ProductEntity`).

## 🏗️ القواعد البرمجية الصارمة

### 1. الوراثة والتعريف

* يجب أن يكون الكلاس **`abstract class`** دائمًا.
* يجب أن يرث الكلاس دائماً من **`Entity`** (الموجود في `lib/core/entities/entity.dart`).
* يجب أن يكون الكلاس **نظيفاً** من أي استيراد لطبقة الـ Data أو الـ Presentation.

### 2. الحقول والثبات (Immutability)

* يجب أن تكون **كافة الحقول** معرفة بـ `final`.
* يجب استخدام باني **`const`** مع بارامترات مسماة (`Named Parameters`).
* استخدم `required` للحقول الأساسية لضمان سلامة الكائن.

### 3. الدوال الإلزامية (Mandatory Methods)

* **`props`**: يجب عمل `override` لـ `props` من `Equatable` لجميع الحقول.
* **`copyWith`**: يجب تعريف دالة `copyWith` كدالة **مجردة (Abstract)** تحتوي على جميع حقول الكائن كبارامترات اختيارية (Optional Parameters).

## 📝 النموذج التطبيقي (Template)

```dart
import 'package:furnigo_mgmt/core/entities/entity.dart';

/// وصف الكائن ووظيفته في النظام.
abstract class ExampleEntity extends Entity {
  final int id;
  final String title;
  final bool isActive;

  const ExampleEntity({
    required this.id,
    required this.title,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, title, isActive];

  @override
  ExampleEntity copyWith({
    int? id,
    String? title,
    bool? isActive,
  });
}
```

## ⚠️ محظورات (Strict Prohibitions)

* **يمنع**: استخدام `fromMap`,`create` داخل الـ Entity (هذه مسؤولية الـ Model).
* **يمنع**: استيراد أي Model أو Repository داخل ملف الـ Entity.
* **يمنع**: إضافة أي Business Logic معقد (مثل التحقق من صحة البيانات المعقد أو الاتصال بخدمات). الـ Entity هو مجرد "وعاء بيانات" مع ذكاء بسيط.

---
> [!TIP]
> تذكر أن الـ Entity يعبر عن "عقد" البيانات في طبقة الـ Domain، بينما الـ Model هو "التنفيذ التقني" لهذا العقد في طبقة الـ Data.
