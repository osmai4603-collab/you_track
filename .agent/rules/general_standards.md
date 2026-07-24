---
trigger: manual
---

# 📢 General Standards (المعايير العامة للمشروع)

هذا المستند يجمع القواعد العامة التي يجب اتباعها في المشروع لضمان اتساق العمل واتباع الـ Workflows المعتمدة.

---

## 🔢 1. معايير إضافة الترقيمات (Enum Standards)

*   **يجب** عند إضافة `enum` جديد في أي مكان في المشروع، استدعاء ملف الـ workflow المسمى `/add_enum` والموجود في مسار [add_enum.md](../workflows/add_enum.md).
*   يضمن هذا الـ workflow أن الـ enum يتبع المعايير المعتمدة في المشروع (Class-based Enums) ويتم تسجيله بشكل صحيح.

---

## 🗄️ 2. معايير إضافة جداول قاعدة البيانات (Database Table Standards)

*   **يجب** عند إضافة جدول جديد لقاعدة البيانات داخل مجلد `lib/core/constants/tables/` في النواة (Core)، استدعاء ملف الـ workflow المسمى `/add_database_table` والموجود في مسار [add_database_table.md](../workflows/add_database_table.md).
*   يضمن هذا الـ workflow أن تعريف الجدول يتبع المعايير المعتمدة ويتم تسجيله بشكل صحيح في قاعدة بيانات التطبيق.

---

## 🏗️ 3. معايير تهيئة المشروع (Project Initialization Standards)

*   **يجب** عند تهيئة المشروع لأول مرة، استدعاء مهارة `تهيئة بنية المشروع (Project Structure Initialization)` والموجودة في مسار [.agent/skills/project_initialization/SKILL.md](../skills/project_initialization/SKILL.md).
*   تضمن هذه المهارة أن الهيكل الأساسي للمشروع وملفات الـ Core الثابتة يتم إنشاؤها وفق المعايير المعتمدة.

---

## 🚀 4. معايير إضافة ميزة جديدة (Feature Creation Standards)

*   **يجب** عند إضافة ميزة (Feature) جديدة في المشروع، استدعاء مهارة `إنشاء ميزة جديدة (Create Feature)` والموجودة في مسار [.agent/skills/create_feature/SKILL.md](../skills/create_feature/SKILL.md).
*   تضمن هذه المهارة أن الميزة تتبع معمارية Clean Architecture (Data, Domain, Presentation) وتلتزم بكافة معايير المشروع.

---

## 🗄️ 5. معايير إدارة قاعدة البيانات (SQLite Management Standards)

*   **يجب** عند إجراء أي تعديل في هيكلية أو بيانات قاعدة البيانات (SQLite3)، استدعاء مهارة `إدارة قاعدة البيانات (SQLite3 Management)` والموجودة في مسار [.agent/skills/sqlite3_management/SKILL.md](../skills/sqlite3_management/SKILL.md).
*   تضمن هذه المهارة التعامل الصحيح مع تعريفات الجداول وإدارة إصدارات الهيكل (Versioning).

---

## 🧪 6. معايير فحص الوحدات (Unit Test Standards)

*   **يجب** عند إجراء أي عملية فحص للوحدات (Unit Test) للمنطق البرمجي، استدعاء مهارة `فحص الوحدات (Unit Test)` والموجودة في مسار [.agent/skills/unit_test/SKILL.md](../skills/unit_test/SKILL.md).
*   تضمن هذه المهارة كتابة اختبارات صحيحة باستخدام Mocktail واتباع معايير التسمية والهيكلية المعتمدة.

---

## 🖼️ 7. معايير فحص الواجهات (Widget Test Standards)

*   **يجب** عند إجراء أي عملية فحص للمكونات المرئية (Widget Test)، استدعاء مهارة `فحص الواجهات (Widget Test)` والموجودة في مسار [.agent/skills/widget_test/SKILL.md](../skills/widget_test/SKILL.md).
*   تضمن هذه المهارة فحص التفاعل مع الـ Widgets والتأكد من ظهور العناصر بشكل صحيح.

---

## 🔗 8. معايير فحص التكامل (Integration Test Standards)

*   **يجب** عند إجراء أي عملية فحص للتكامل (Integration Test/E2E)، استدعاء مهارة `فحص التكامل (Integration Test)` والموجودة في مسار [.agent/skills/integration_test/SKILL.md](../skills/integration_test/SKILL.md).
*   تضمن هذه المهارة فحص تدفق التطبيق بالكامل والتأكد من عمل جميع الأجزاء معاً بانسجام.

---

---
## 🌍 9. معايير استدعاء اللغات (Locale Standards)

*   **يمنع** استدعاء كلاس `Locale` بشكل مباشر في أي مكان في المشروع (مثال: `const Locale('ar')`).
*   **يجب** دائماً استدعاء اللغات من خلال الكلاس الأب `AppLocale` الموجود في مجلد `lib/core/localization/constants/`.
*   يضمن هذا اتساق استدعاء اللغات وسهولة تعديلها أو إضافة لغات جديدة في مكان واحد.

---

## 📝 10. معايير توثيق الدوال (Function Documentation Standards)

*   **يجب** عند إضافة أي دالة (Function) أو حقل (Field) جديد، سواء في الواجهات (UI) أو في منطق الأعمال وإدارة الحالة (Business Logic / State Management)، كتابة تعليق (Comment/Docstring) توضيحي كافٍ.
*   يلتزم المطور بشرح الآتي في التعليق: ما هو دور الدالة أو الحقل، ما هي وظيفته، وماذا يفعل بالضبط لضمان مقروئية الكود.

## 🎨 12. معايير استدعاء خصائص الألوان للكلاس Color (Color Modification & Properties Standards)

*   **يمنع منعاً باتاً** استخدام الدوال المهجورة (Deprecated) مثل `withOpacity`, `withRed`, `withGreen`, `withBlue`.
*   يجب استخدام الدالة الحديثة `withValues` بدلاً منها لتعديل قيم اللون (Alpha, Red, Green, Blue).
*   **يمنع منعاً باتاً** استخدام الحقول المهجورة (Deprecated) مثل `red`, `green`, `blue`, `alpha`.
*   يجب استخدام الحقول الحديثة `r`, `g`, `b`, `a` بدلاً منها للوصول إلى قيم مكونات اللون (قيمتها double تتراوح بين 0.0 و 1.0).
*   **يمنع منعاً باتاً** استخدام الحقل المهجور `value` للحصول على القيمة الرقمية للون.
*   يجب استخدام الدالة الحديثة `toARGB32()` بدلاً منها.

### ✅ الطريقة الصحيحة (Correct)
```dart
// لتعديل الشفافية (Opacity)
color.withValues(alpha: 0.5)

// للوصول إلى قيمة اللون الأحمر (Red) - تعيد قيمة بين 0.0 و 1.0
final redComponent = color.r;

// للحصول على القيمة الرقمية الكاملة للون
final argbValue = color.toARGB32();
```

### ❌ الطريقة الخاطئة (Incorrect)
```dart
color.withOpacity(0.5)
final redComponent = color.red; // تعيد قيمة بين 0 و 255
final argbValue = color.value;
```

---

## 🔍 13. معايير البحث والوصول للمعلومات (Search & Information Access Standards)

*   **يجب** عند قيام الـ Agent بأي عملية بحث عن معلومات تقنية أو متعلقة بالمشروع، استدعاء مهارة `إدارة NotebookLM (NotebookLM Management)` أو استخدام خادم `NotebookLM MCP` لضمان الحصول على أدق المعلومات من المصادر الموثقة.

---

---
## 🎛️ 14. معايير حقن التبعيات في إدارة الحالة (State Management Dependency Standards)

*   **يمنع منعاً باتاً** حقن (Inject) أي `Repository` مباشرة داخل كلاسات إدارة الحالة (مثل `Bloc` أو `Cubit`).
*   **يجب** أن تعتمد كلاسات إدارة الحالة حصراً على حالات الاستخدام (`UseCase`) لتنفيذ العمليات.
*   تضمن هذه القاعدة الفصل التام بين طبقة العرض (Presentation) وتفاصيل البيانات، مما يسهل عملية الفحص (Testing) وإعادة استخدام المنطق البرمجي.

---
## 🏷️ 15. معايير استخدام الترقيمات (AppEnum Usage Standards)

*   **يمنع منعاً باتاً** كتابة أي نصوص ثابتة (Hardcoded Strings) بشكل مباشر داخل ملفات الكود إذا كان لها ترقيم (`AppEnum`) مقابل في المشروع.
*   **يجب** دائماً استدعاء القيمة من خلال الكلاس المقابل للـ `Enum` باستخدام الخاصية `.name`.
*   يضمن هذا اتساق البيانات في قاعدة البيانات ومنع الأخطاء المطبعية عند التعامل مع القيم الثابتة (مثل الأدوار، أنواع الحركات، أو الحالات).

### ✅ الطريقة الصحيحة (Correct)
```dart
// استدعاء اسم الدور من الـ Enum
final role = UserRoleEnum.admin.name;

// استدعاء نوع الحركة
final type = MovementTypeEnum.inbound.name;
```

### ❌ الطريقة الخاطئة (Incorrect)
```dart
// كتابة النص بشكل مباشر (عرضة للأخطاء)
final role = 'admin';

// كتابة نوع الحركة كنص ثابت
final type = 'inbound';
```

---

## 🖼️ 16. معايير بناء صفحة واجهة مستخدم (UI Page Standards)

*   **يجب** عند إضافة أي صفحة واجهة مستخدم (Page) جديدة في التطبيق، استدعاء مهارة `بناء صفحة واجهة مستخدم (UI Page)` والموجودة في مسار [.agent/skills/ui_page/SKILL.md](../skills/ui_page/SKILL.md).
*   تضمن هذه المهارة أن كافة التحضيرات من ترجمة (Localization)، أيقونات (Icons)، وتنقل (Navigation) قد تمت بشكل صحيح قبل البدء في البناء.

---

> [!IMPORTANT]
> الالتزام بهذه القواعد يضمن اتساق هيكلية المشروع وتسهيل عملية التطوير والصيانة.