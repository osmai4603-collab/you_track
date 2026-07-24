---
description: كيفية إضافة حالة استخدام (Use Case) جديدة تتبع معايير المشروع و Clean Architecture.
---

# 📖 سير العمل: إضافة حالة استخدام جديدة (Create New UseCase)

تُعد حالات الاستخدام (UseCases) هي المسؤولة عن تنفيذ منطق الأعمال (Business Logic) الخاص بالميزة. فهي التي تربط بين الـ Presentation Layer والـ Domain Layer عبر الـ Repositories.

اتبع الخطوات التالية بدقة عند إضافة أي UseCase جديد:

## 📂 أولاً: الموقع والتسمية
1.  **المسار**: `lib/features/[feature_name]/domain/usecases/`.
2.  **اسم الملف**: يجب أن يكون `snake_case` ويعبر عن الوظيفة.
    *   *مثال*: `get_products.dart`.
3.  **اسم الكلاس**: يجب أن يكون `PascalCase` ويعبر عن الفعل.
    *   *مثال*: `GetProducts`.

## 🏗️ ثانياً: الهيكلية البرمجية

راجع مهارة [إضافة حالة استخدام (Use Case Development)](../../skills/add_use_case/SKILL.md) للحصول على أحدث نموذج وقواعد صارمة.

## ⚠️ قواعد ذهبية
*   **دائماً**: اجعل الـ UseCase مسؤولاً عن مهمة واحدة فقط (Single Responsibility).
*   **دائماً**: استخدم الـ **Interface** الخاص بالـ Repository وليس التنفيذ (Impl).

---
> [!TIP]
> بعد إنشاء الـ UseCase، يمكنك الآن حقنه في الـ **Cubit** أو الـ **Bloc** الخاص بالميزة لاستخدامه في طبقة العرض.
