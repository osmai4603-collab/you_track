# إدارة الاستثناءات (Exceptions Implementation)

يحدد هذا الدليل كيفية بناء وإدارة الاستثناءات في طبقة النواة (Core) لضمان التعامل الصحيح مع الأخطاء غير المتوقعة وتحويلها إلى أخطاء واجهة مستخدم (Failures).

## 🛠️ تفاصيل التنفيذ

### 1. الكلاس الأساسي (AppException)
*   **المسار**: `lib/core/errors/exceptions.dart`.
*   **الهدف**: توحيد جميع الاستثناءات التي قد تحدث في طبقة البيانات (Data Layer).
*   **الهيكلية**: يجب تعريف الكلاس كـ `abstract class`.

```dart
abstract class AppException implements Exception {
  final String message;
  const AppException([this.message = 'An unexpected error occurred']);

  @override
  String toString() => message;
}
```

### 2. القاعدة الذهبية (The Golden Rule)

> [!IMPORTANT]
> **يجب** لكل كلاس خطأ (`Failure`) في طبقة الـ Domain، أن يقابله كلاس استثناء (`Exception`) في طبقة الـ Data. هذا يضمن تدفقاً منطقياً لتحويل الأخطاء الفنية إلى رسائل مفهومة للمستخدم.

#### **مثال على الربط (Mapping Example):**

| طبقة البيانات (Exceptions) | طبقة الأعمال (Failures) |
| :--- | :--- |
| `ServerException` | `ServerFailure` |
| `DatabaseException` | `LocalDatabaseFailure` |
| `CacheException` | `CacheFailure` |

### 3. تطبيق الاستثناءات الشائعة

يجب توفير هذه الاستثناءات الأساسية عند تهيئة المشروع:

```dart
class ServerException extends AppException {
  const ServerException([super.message]);
}

class DatabaseException extends AppException {
  const DatabaseException([super.message]);
}

class CacheException extends AppException {
  const CacheException([super.message]);
}
```

---
> [!TIP]
> استخدام الاستثناءات المخصصة يسهل عملية تتبع الأخطاء (Logging) وتحديد مصدر المشكلة بدقة أثناء التطوير.
