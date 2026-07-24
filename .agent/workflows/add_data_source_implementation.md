---
description: كيفية إضافة تنفيذ لمصدر بيانات (Data Source Implementation) تتبع معايير المشروع و Clean Architecture.
---

# 📖 سير العمل: إضافة تنفيذ مصدر بيانات (Create Data Source Implementation)

يتم تنفيذ واجهات مصادر البيانات (Data Source Implementations) في طبقة الـ Data للتعامل الفعلي مع الخدمات الخارجية مثل نظام قواعد البيانات المحلي (SQLite) أو الـ APIs الخارجية.

اتبع الخطوات التالية بدقة عند إضافة أي Data Source Implementation جديد:

## 📂 أولاً: الموقع والتسمية
1.  **المسار**: `lib/features/[feature_name]/data/datasources/`.
2.  **التصنيف**:
    *   **محلي**: ينتهي بـ `_local_data_source_impl.dart`.
    *   **بعيد**: ينتهي بـ `_remote_data_source_impl.dart`.
3.  **اسم الكلاس**:
    *   **محلي**: ينتهي بـ `LocalDataSourceImpl`. (مثال: `AuthLocalDataSourceImpl`).
    *   **بعيد**: ينتهي بـ `RemoteDataSourceImpl`. (مثال: `AuthRemoteDataSourceImpl`).

## 🏗️ ثانياً: الهيكلية البرمجية

راجع مهارة [إضافة تنفيذ مصدر بيانات (Data Source Implementation Development)](../../skills/add_data_source_implementation/SKILL.md) للحصول على أحدث نموذج وقواعد صارمة.

## ⚠️ قواعد ذهبية
*   **دائماً**: ارمي استثناءات (`Exceptions`) عند الفشل.
*   **دائماً**: استخدم الجداول المركزية للـ SQLite.

---
> [!IMPORTANT]
> الالتزام بهذه الهيكلية يسهل عملية تبديل مصدر البيانات (مثل الانتقال من SQLite إلى Hive) دون المساس ببقية أجزاء التطبيق.
