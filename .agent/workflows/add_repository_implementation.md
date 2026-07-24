---
description: كيفية إضافة تنفيذ لمستودع (Repository Implementation) في طبقة الـ Data يتبع معايير المشروع.
---

# 📖 سير العمل: إضافة تنفيذ مستودع (Create Repository Implementation)

تُعد تنفيذات المستودعات (Repository Implementations) هي المسؤولة عن الربط الفعلي بين طبقة الـ Domain ومصادر البيانات (Data Sources). وهي المكان الذي يتم فيه التعامل مع الاستثناءات وتحويل البيانات من Models إلى Entities.

اتبع الخطوات التالية بدقة عند إضافة أي Repository Implementation جديد:

## 📂 أولاً: الموقع والتسمية
1.  **المسار**: `lib/features/[feature_name]/data/repositories/`.
2.  **اسم الملف**: يجب أن يكون `snake_case` وينتهي بـ `_repository_impl.dart`.
    *   *مثال*: `auth_repository_impl.dart`.
3.  **اسم الكلاس**: يجب أن يكون `PascalCase` وينتهي بـ `RepositoryImpl`.
    *   *مثال*: `AuthRepositoryImpl`.

## 🏗️ ثانياً: الهيكلية البرمجية

راجع مهارة [إضافة تنفيذ مستودع (Repository Implementation Development)](../../skills/add_repository_implementation/SKILL.md) للحصول على أحدث نموذج وقواعد صارمة.

## ⚠️ قواعد ذهبية
*   **دائماً**: استخدم `try-catch`.
*   **دائماً**: حول البيانات إلى `Entity` قبل إرسالها للأعلى.

---
> [!TIP]
> بعد تنفيذ المستودع، لا تنسَ تسجيله في نظام حقن التبعيات (Dependency Injection) الخاص بالمشروع ليكون متاحاً للاستخدام في الـ UseCases.
