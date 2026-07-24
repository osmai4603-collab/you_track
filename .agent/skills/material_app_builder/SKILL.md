---
name: بناء المادة التطبيق (Material App Builder)
description: خطوات بناء وتهيئة الـ Material App الأساسي للتطبيق مع إدارة السمات واللغات باستخدام Clean Architecture و BLoC.
---

# مهارة بناء المادة التطبيق (Material App Builder)

استخدم هذه المهارة لتهيئة الهيكل الأساسي للتطبيق (`MaterialApp`) بعد الانتهاء من مرحلة التهيئة الأولية للمشروع. تضمن هذه المهارة ربط الهوية البصرية، اللغات، والتنقل بشكل مركزي وتفاعلي.

## 💡 متى وكيف تطلب استخدام هذه المهارة؟
*   **متى؟**: بعد تهيئة بنية المشروع الأساسية، وعند الرغبة في تفعيل نظام السمات (Themes) واللغات (Localization).
*   **كيف؟**: اطلب ببساطة "أريد بناء المادة التطبيق (Material App)" وسأقوم بتنفيذ الخطوات اللازمة لإنشاء ميزة `app`.

## 🎯 الحاجة لهذه المهارة
تعتبر هذه المهارة نقطة الانطلاق الحقيقية للواجهة البرمجية، حيث تقوم بـ:
1.  إدارة حالة الثيم (Light/Dark/System) وحفظها.
2.  إدارة لغة التطبيق وحفظها باستخدام `SharedPreferences`.
3.  توفير هيكل مرن لإعادة بناء التطبيق عند تغيير الإعدادات دون فقدان حالة التنقل.

## 📂 الهيكل والمعايير التقنية
يتم تنفيذ هذه المهارة كميزة (Feature) مستقلة تسمى `app` وتخضع لمعايير المعمارية النظيفة.

> [!IMPORTANT]
> يجب استخدام مهارة [إنشاء ميزة جديدة (Create Feature)](../create_feature/SKILL.md) كقاعدة أساسية لبناء كافة طبقات ميزة الـ `app` لضمان الالتزام بالمعايير.

### مكونات الميزة:
*   **Entity**: `AppSettingsEntity` لتخزين إعدادات الثيم واللغة.
*   **Data Source**: `AppSettingsLocalDataSource` يستخدم `SharedPreferences` للتخزين الدائم.
*   **Cubit**: `AppCubit` لإدارة العمليات وتحديث الواجهة.
*   **Widget**: `Application` وهو الـ Shell الذي يحتوي على `MaterialApp.router`.

### خطوات العمل الإجرائية:
1.  **إضافة الاعتماديات**: التأكد من وجود `shared_preferences` و `flutter_bloc` و `go_router`.
2.  **بناء طبقة الـ Domain**: تعريف الـ Entity وواجهة الـ Repository والـ UseCases (`GetAppSettings`, `SaveAppSettings`).
3.  **بناء طبقة الـ Data**: تنفيذ الـ Model وتجهيز الـ Local Data Source والـ Repository Implementation.
4.  **تحديث المدخل الرئيسي (main.dart)**: التأكد من استدعاء العمليات التالية قبل `runApp`:
    *   `WidgetsFlutterBinding.ensureInitialized()`: لضمان تهيئة روابط فلاتر.
    *   `await initDependencies()`: لتهيئة كافة الخدمات والحقن البرمجي.
5.  **بناء طبقة الـ Presentation**:
    *   إنشاء الـ `AppCubit` والـ `AppState`.
    *   بناء ويدجت الـ `Application` التي تستخدم `BlocBuilder` لإعادة بناء `MaterialApp.router` واستدعاء الكونستركتور الخاص به (`MaterialApp.router`).
    *   ربط الـ `routerConfig` مع `NavigationService.router`.
6.  **التسجيل والحقن**: تسجيل كافة المكونات في `init_dependencies.dart`.
7.  **تفعيل الميزة في المدخل الرئيسي**: تعديل `runApp` ليوفر الـ `AppCubit` ويستخدم ويدجت الـ `Application`.

## 📝 أمثلة
*   **الطلب**: "قم ببناء المادة التطبيق مع دعم الوضع الليلي واللغة العربية".
*   **النتيجة**: سيتم إنشاء ميزة `app` كاملة، مبرمجة لتقرأ الإعدادات من الذاكرة المحلية وتطبق `AppTheme` و `AppLocal` المحددين في الـ Core.

---
> [!TIP]
> تأكد دائماً من استدعاء `sl<AppCubit>()..init()` في الـ `main.dart` لضمان تحميل الإعدادات المحفوظة فور تشغيل التطبيق.
