---
description: تهيئة كلاسات الأخطاء (Failure) وحالات الاستخدام (UseCase) الأساسية
---

# 🏗️ سير العمل: تهيئة الكلاسات الأساسية (Failure & UseCase)

تعتبر هذه الكلاسات هي حجر الزاوية في التواصل بين طبقات التطبيق (Data, Domain, Presentation).

## 🏗️ خطوات التنفيذ

### 1. تهيئة كلاس الأخطاء (Failure)
*   **المسار**: `lib/core/errors/failure.dart`
*   **الهدف**: توحيد طريقة تمثيل الأخطاء.

```dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure([this.message = 'An unexpected error occurred']);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure([super.message]);
}
```

### 2. تهيئة كلاس منطق الأعمال (UseCase)
*   **المسار**: `lib/core/usecase/usecase.dart`
*   **الهدف**: العقد الأساسي لجميع العمليات في التطبيق.

```dart
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:[app_name]/core/errors/failure.dart';

abstract class Params extends Equatable {
  const Params();
  
  @override
  List<Object?> get props => [];
}

abstract class UseCase<Type, ParamsType extends Params> {
  const UseCase();
  Future<Either<Failure, Type>> call({required ParamsType params});
}

class NoParams extends Params {
  const NoParams();
}
```

## ⚠️ قواعد ذهبية
*   دائماً استخدم `Either` من مكتبة `fpdart` للتعامل مع المتوقع وغير المتوقع.
*   تأكد من توريث جميع الـ Failures المخصصة من كلاس `Failure` الأساسي.
