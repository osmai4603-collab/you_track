# المعمارية وأنماط التصميم (Architecture & Design Patterns)

يتبنى مشروع `issues_tracking` **المعمارية النظيفة (Clean Architecture)** لضمان استقلالية الكود، سهولة اختباره، وقابليته للتوسع المستقبلي.

## 🏗️ المعمارية النظيفة (Clean Architecture)

يتم تقسيم المشروع إلى ثلاث طبقات رئيسية لكل ميزة (Feature):

1. **الطبقة التقديمية (Presentation Layer):**
   *   تحتوي على واجهات المستخدم (UI/Widgets) باستخدام Flutter.
   *   تستخدم **BLoC Pattern** لإدارة الحالة (State Management) والربط بين الـ UI وطبقة الـ Domain.
2. **طبقة النطاق (Domain Layer):**
   *   قلب التطبيق، لا تعتمد على أي مكتبة خارجية أو إطار عمل (مستقلة عن Flutter قدر الإمكان).
   *   تحتوي على الكيانات (Entities) الأساسية، وحالات الاستخدام (Use Cases)، وواجهات المستودعات (Repository Interfaces).
3. **طبقة البيانات (Data Layer):**
   *   مسؤولة عن جلب وإرسال البيانات.
   *   تحتوي على النماذج (Models) التي ترث من Entities.
   *   تنفيذ المستودعات (Repository Implementations).
   *   مصادر البيانات (Data Sources) للتواصل المباشر مع Supabase.

---

## 🧩 أنماط التصميم (Design Patterns)

لتجنب التعقيد غير المبرر (Over-engineering)، تم حصر أنماط التصميم على الأنواع التالية التي يحتاجها النظام فعلياً:

### 1. Repository Pattern (نمط المستودع)
*   **الهدف:** توفير واجهة موحدة للبيانات، مما يعزل طبقة Domain عن تفاصيل قواعد البيانات أو الشبكة (Supabase).
*   **التطبيق:** كل كيان (مثل Issue) له `IssueRepository` interface في طبقة Domain، وتنفيذ `IssueRepositoryImpl` في طبقة Data.

### 2. BLoC (Business Logic Component) / Observer Pattern
*   **الهدف:** فصل منطق الواجهة عن منطق الأعمال، والاستماع للتغيرات بشكل تفاعلي (Reactive).
*   **التطبيق:** استخدام مكتبة `flutter_bloc` لإدارة حالات شاشات المهام، المشاريع، والإشعارات، وتحديث الواجهة عند وصول بيانات جديدة من Supabase (Realtime).

### 3. Singleton Pattern
*   **الهدف:** ضمان وجود نسخة واحدة فقط من كائن معين طوال دورة حياة التطبيق.
*   **التطبيق:** يستخدم بحذر في خدمات النواة مثل `SupabaseClient`، `AppRouter`، وإدارة الترجمة عبر `Dependency Injection (GetIt)`.

### 4. Factory Method Pattern
*   **الهدف:** تحويل البيانات الخام القادمة من قاعدة البيانات (JSON) إلى كائنات (Models).
*   **التطبيق:** استخدام دوال `fromJson` في الـ Models لإنشاء الكائنات المناسبة بناءً على البيانات.

### 5. Strategy Pattern (نمط الاستراتيجية)
*   **الهدف:** السماح بتغيير الخوارزمية في وقت التشغيل.
*   **التطبيق:** استخدامه في عمليات البحث والتصفية المتقدمة (Sorting and Filtering) للمشاكل (Issues). بدلاً من كتابة جمل `if/else` معقدة، يتم تحديد `FilterStrategy` (مثل تصفية حسب الأولوية، أو حسب الحالة) وتطبيقه.

---

## 📐 مبادئ SOLID المُطبقة

*   **S - Single Responsibility Principle:** كل كلاس أو دالة لها مسؤولية واحدة (مثال: `IssueRemoteDataSource` مسؤول فقط عن اتصالات Supabase الخاصة بالـ Issues).
*   **O - Open/Closed Principle:** الكود مفتوح للإضافة مغلق للتعديل. يتم استخدام الـ Interfaces في طبقة Domain لإضافة مصادر بيانات جديدة (مثل Caching) دون تغيير كود الـ Use Cases.
*   **L - Liskov Substitution Principle:** الـ Models في طبقة Data هي امتداد صحيح للـ Entities في طبقة Domain، ويمكن استخدامها كبديل لها.
*   **I - Interface Segregation Principle:** واجهات صغيرة ومحددة. (مثلاً واجهة `ProjectReader` منفصلة عن `ProjectWriter` إذا لزم الأمر).
*   **D - Dependency Inversion Principle:** الاعتماد على التجريد وليس التنفيذ. طبقة Presentation و Domain تعتمدان على `Repository Interface` وليس على التنفيذ الفعلي في طبقة Data.
