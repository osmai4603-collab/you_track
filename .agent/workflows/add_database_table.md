---
description: كيفية إضافة جدول جديد لقاعدة البيانات
---

# مسار عمل: إضافة جدول قاعدة بيانات (Add Database Table)

يوضح هذا المسار كيفية تعريف جداول قاعدة البيانات (SQLite) داخل طبقة النواة (Core) لضمان اتساق التسمية وسهولة الوصول للبيانات.

### المعايير والقواعد (Standards & Rules):
*   **موقع الملف**: يجب أن تُنشأ جميع ملفات الجداول داخل المسار `lib/core/tables/`.
*   **تسمية الملف**: يجب أن يكون اسم الملف بالجمع وينتهي اسم الملف بـ `_table.dart` (مثال: `products_table.dart`).
*   **تسمية الكلاس**: يجب أن يكون اسم الكلاس بالجمع وينتهي اسم الكلاس بـ `Table` (مثال: `ProductsTable`).
*   **تسمية الجداول والحقول في قاعدة البيانات**: يجب أن تكون جميع الأسماء بالـ **Small Letters** حصراً، مع الفصل بين الكلمات بـ **Underscore** (`_`).
*   **هيكلية الكلاس**:
    *   يجب أن يكون الكلاس من نوع **Singleton**.
    *   يجب أن يكون الـ Constructor **خاص (Private)** و **const**.
    *   يجب تعريف جميع الحقول كـ `final String`.
    *   يجب توفير حقل `tableName` لاسم الجدول.
    *   يجب توفير دالة `get columns` (Getter) تُرجع قائمة بجميع أسماء الحقول المعرفة.

### مثال تطبيقي (Implementation Example):

```dart
final class ProductsTable {
  static const ProductsTable _instance = ProductsTable._internal();
  factory ProductsTable() => _instance;
  const ProductsTable._internal();

  final String tableName = 'products';
  final String id = 'id';
  final String productName = 'product_name';
  final String createdAt = 'created_at';

  List<String> get columns => [id, productName, createdAt];
}
```

### خطوات العمل (Execution Steps):
1. اطلب اسم الجدول والأعمدة المطلوب إنشاؤها.
2. تأكد من أن الأسماء تتبع معيار الـ **Snake Case** (Small letters with underscores).
3. قم بإنشاء ملف الجدول في المسار المخصص مع تطبيق الهيكلية البرمجية المذكورة أعلاه.
4. إشعار المستخدم بضرورة عمل `Migration` إذا كان الجدول مرتبطاً ببيانات أو خدمة حالية.