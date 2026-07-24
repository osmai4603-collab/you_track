---
name: إضافة حالة استخدام (Use Case Development)
description: القواعد الصارمة والمعايير الهندسية لبناء حالات الاستخدام (Use Cases) لربط طبقات التطبيق وتنفيذ منطق الأعمال.
---

# مهارة إضافة حالة استخدام (Use Case Development)

تُلسم حالات الاستخدام (Use Cases) بتنفيذ منطق الأعمال (Business Logic) المستقل. مهمتها هي الربط بين الـ Presentation والـ Domain عبر الـ Repositories.

## 📂 الموقع والتسمية

* **المسار**: `lib/features/[feature_name]/domain/usecases/`.
* **اسم الملف**: `snake_case` (مثال: `get_products_usecase.dart`).
* **اسم الكلاس**: `PascalCase` ينتهي بـ `UseCase` (مثال: `GetProductsUseCase`).

## 🏗️ القواعد البرمجية الصارمة

### 1. الوراثة والتعريف

* يجب أن يرث الكلاس دائماً من **`UseCase<Type, ParamsType>`** (الموجود في `lib/core/usecases/usecase.dart`).
* **الممررات**: إذا كانت الحالة تتطلب ممررات متعددة، يجب إنشاء كلاس `Params` خاص بها داخل نفس الملف.
* **بدون ممررات**: استخدم `NoParams` من النواة.

### 2. الحقن (Injection)

* يجب حقن الـ **Repository** المطلوب (الـ `interface` وليس الـ `impl`) عبر الـ constructor كمتغير `final` و `private`.

### 3. دالة التنفيذ (The call Method)

* يجب عمل `{@override}` لدالة **`call`**.
* يجب أن تُرجع الدالة **`Future<Either<Failure, T>>`** باستخدام مكتبة `fpdart`.
* يجب القيام بعملية "التغليف" (Wrapping) للنتائج القادمة من المستودع لتكون متوافقة مع الـ UI.

## 📝 النموذج التطبيقي (Template)

```dart
import 'package:fpdart/fpdart.dart';
import 'package:furnigo_mgmt/core/errors/failure.dart';
import 'package:furnigo_mgmt/core/usecases/usecase.dart';
import 'package:furnigo_mgmt/features/[feature_name]/domain/entities/example_entity.dart';
import 'package:furnigo_mgmt/features/[feature_name]/domain/repositories/example_repository.dart';

/// ممررات الحالة.
class GetExampleParams extends Params {
  final int id;
  const GetExampleParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// حالة الاستخدام للحصول على البيانات.
class GetExampleUseCase implements UseCase<ExampleEntity, GetExampleParams> {
  final ExampleRepository _repository;

  const GetExampleUseCase(this._repository);

  @override
  Future<Either<Failure, ExampleEntity>> call({required GetExampleParams params}) async {
    return await _repository.getExample(params.id);
  }
}
```

## ⚠️ مبادئ ذهبية

* **مبدأ المسؤولية الواحدة (SRP)**: كل ملف `UseCase` يجب أن يقوم بمهمة واحدة فقط (مثل: جلب، إضافة، حذف).
* **الاستقلالية**: الـ UseCase لا يعتمد على أي تفاصيل تتعلق بالـ UI أو قاعدة البيانات.

---
> [!TIP]
> بعد إنشاء هذا الـ UseCase، تأكد من تسجيله في نظام حقن التبعيات (GetIt) ليتم استخدامه في طبقة الـ Presentation (BLoC/Cubit).
