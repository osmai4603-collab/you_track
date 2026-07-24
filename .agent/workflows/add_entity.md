---
description: كيفية إضافة كائن (Entity) جديد يتبع معايير المشروع و Clean Architecture.
---

# 📖 سير العمل: إضافة كائن جديد (Create New Entity)

تُعد الكائنات (Entities) حجر الزاوية في طبقة الـ Domain. يجب أن تكون بسيطة، غير قابلة للتغيير (Immutable)، ومستقلة عن أي تفاصيل خارجية أو مكتبات (باستثناء Equatable).

> [!IMPORTANT]
> **ملاحظة هامة (شرط مسبق):** يجب التأكد أولاً من أنه قد تم بناء ملف الـ `Entity` الأساسي (الذي سيرث منه الكائن الذى بصدد إنشائه) داخل مجلد الـ `core`. راجع مسار العمل [init_entity.md](init_entity.md).

اتبع الخطوات التالية بدقة عند إضافة أي Entity جديد:

## 📂 أولاً: الموقع والتسمية
1.  **المسار**: `lib/features/[feature_name]/domain/entities/`.
2.  **اسم الملف**: يجب أن يكون `snake_case` وينتهي بـ `_entity.dart`.
    *   *مثال*: `product_entity.dart`.
3.  **اسم الكلاس**: يجب أن يكون `PascalCase` وينتهي بـ `Entity`.
    *   *مثال*: `ProductEntity`.

## 🏗️ ثانياً: الهيكلية البرمجية

### 1. المنطق والتعريف (Definition)
*   يجب أن يرث الكلاس دائماً من **`Entity`** (الموجود في `lib/core/entities/entity.dart`).
*   **ملف مستقل**: يجب أن يكون الـ Entity في ملف مستقل تماماً.

### 2. الحقول والباني (Fields & Constructor)
*   يجب أن تكون جميع الحقول **final**.
*   يجب استخدام باني **const** مع بارامترات مسماة (Named Parameters) و **required** عند الضرورة.

### 3. المقارنة (Equatable)
*   يجب عمل `override` لـ `props` لتحديد الحقول التي تدخل في عملية المقارنة.

### 4. نسخ الكائن (copyWith) و (toMap)
*   يجب تنفيذ دالة `copyWith` و `toMap` كما هو مطلوب في الكلاس الأب `Entity`.

---

## 📝 ثالثاً: نموذج تطبيقي (Template)

راجع مهارة [بناء الكائنات (Entity Development)](../../skills/add_entity/SKILL.md) للحصول على أحدث نموذج وقواعد صارمة.

## ⚠️ قواعد ذهبية
*   **دائماً**: التزم بالثبات (Immutability).
*   **تجنب**: وضع أي منطق أعمال معقد داخل الـ Entity.

---
> [!TIP]
> بعد إنشاء الـ Entity، انتقل فوراً لإنشاء الـ **Model** المقابل له في مسار `lib/features/[feature_name]/data/models/` والذي يرث من هذا الـ Entity، وذلك باستخدام سير العمل [add_model.md](add_model.md). قم بتنفيذ الدوال المجردة (`toMap`, `copyWith`) وإضافة مصانع التحويل (`fromMap`, `fromEntity`).
