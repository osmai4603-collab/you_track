---
description: كيفية إضافة واجهة لمستودع (Repository Interface) في طبقة الـ Domain تتبع معايير المشروع.
---

# 📖 سير العمل: إضافة واجهة مستودع (Create Repository Interface)

تُعرف واجهات المستودعات (Repository Interfaces) في طبقة الـ Domain لتحديد "ماذا" سيفعل المستودع دون الدخول في تفاصيل "كيف" سيتم تنفيذه. هذا يضمن استقلال طبقة الـ Domain عن أي تفاصيل تتعلق بقواعد البيانات أو الـ APIs.

اتبع الخطوات التالية بدقة عند إضافة أي Repository Interface جديد:

## 📂 أولاً: الموقع والتسمية
1.  **المسار**: `lib/features/[feature_name]/domain/repositories/`.
2.  **اسم الملف**: يجب أن يكون `snake_case` وينتهي بـ `_repository.dart`.
    *   *مثال*: `auth_repository.dart`.
3.  **اسم الكلاس**: يجب أن يكون `PascalCase` وينتهي بـ `Repository`.
    *   *مثال*: `AuthRepository`.

## 🏗️ ثانياً: الهيكلية البرمجية

راجع مهارة [إضافة واجهة مستودع (Repository Interface Development)](../../skills/add_repository_interface/SKILL.md) للحصول على أحدث نموذج وقواعد صارمة.

## ⚠️ قواعد ذهبية
*   **دائماً**: استخدم `abstract interface class`.
*   **دائماً**: الالتزام بالـ Entities والـ Enums في الممررات والنتائج.

---
> [!TIP]
> بعد إنشاء الواجهة في طبقة الـ Domain، انتقل لإنشاء الـ **Repository Implementation** في طبقة الـ Data والذي يقوم بتنفيذ هذه الواجهة والتعامل مع الـ DataSources.
