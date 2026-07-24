---
description: كيفية إضافة واجهة لمصدر بيانات (Data Source Interface) تتبع معايير المشروع و Clean Architecture.
---

# 📖 سير العمل: إضافة واجهة مصدر بيانات (Create Data Source Interface)

تُعرف واجهات مصادر البيانات (Data Source Interfaces) في طبقة الـ Data لتحديد العمليات التي سيتم تنفيذها لجلب أو حفظ البيانات، سواء كانت من مصدر محلي (Local) أو بعيد (Remote).

اتبع الخطوات التالية بدقة عند إضافة أي Data Source Interface جديد:

## 📂 أولاً: الموقع والتسمية
1.  **المسار**: `lib/features/[feature_name]/data/datasources/`.
2.  **التصنيف**:
    *   **محلي**: ينتهي بـ `_local_data_source.dart`.
    *   **بعيد**: ينتهي بـ `_remote_data_source.dart`.
3.  **اسم الكلاس**:
    *   **محلي**: ينتهي بـ `LocalDataSource`. (مثال: `AuthLocalDataSource`).
    *   **بعيد**: ينتهي بـ `RemoteDataSource`. (مثال: `AuthRemoteDataSource`).

## 🏗️ ثانياً: الهيكلية البرمجية

راجع مهارة [إضافة واجهة مصدر بيانات (Data Source Interface Development)](../../skills/add_data_source_interface/SKILL.md) للحصول على أحدث نموذج وقواعد صارمة.

## ⚠️ قواعد ذهبية
*   **دائماً**: افصل بين المحلي والبعيد.
*   **دائماً**: ارجع البيانات كـ Maps أو Models وارمي الاستثناءات.

---
> [!TIP]
> بعد إنشاء الواجهة، انتقل لإنشاء الـ **Data Source Implementation** لتعريف كيفية التعامل الفعلي مع قاعدة البيانات أو الـ API.
