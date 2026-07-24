---
name: فحص الوحدات (Unit Test)
description: دليل كتابة اختبارات الوحدات (Unit Tests) للمنطق البرمجي باستخدام Mocktail.
---

# مهارة فحص الوحدات (Unit Test)

تستخدم اختبارات هذه المهارة للتأكد من صحة المنطق البرمجي (Business Logic) في الـ UseCases والـ Repositories والـ Models بشكل مستقل عن واجهة المستخدم.

## 💡 متى وكيف تطلب استخدام هذه المهارة؟
*   **متى؟**: عند إنشاء UseCase جديد، أو إضافة منطق معقد في Repository، أو للتأكد من صحة تحويل البيانات في Model.
*   **كيف؟**: اطلب "اكتب Unit Test لـ LoginUseCase" أو "اختبر الـ Model الخاص ببيانات المستخدم".

## 🎯 المعايير والضوابط التقنية
*   **المكتبات الأساسية**: `flutter_test`, `mocktail`.
*   **المحاكاة (Mocking)**: استخدم `mocktail` لمحاكاة التبعات (Dependencies).
*   **التسمية**: يجب أن ينتهي اسم الملف بـ `_test.dart`.
*   **الهيكل**: اتبع هيكل الملفات في مجلد `test/` ليتطابق مع `lib/`.

## 📋 خطوات العمل الإجرائية
1.  **إنشاء المحاكيات (Mocks)**: تعريف كلاسات `Mock` للاعتمادات.
2.  **التهيئة (Setup)**: استخدام دالة `setUp()` لتهيئة الكائنات قبل كل اختبار.
3.  **الاختبار (Test Case)**: استخدام `test()` لوصف الحالة المتوقعة.
4.  **التوقع (Expectation)**: استخدام `expect()` للتحقق من المخرجات، أو `verify()` للتأكد من استدعاء الدوال.

## 📝 أمثلة

### محاكاة تبعية:
```dart
class MockAuthRepository extends Mock implements AuthRepository {}
```

### هيكل اختبار Unit:
```dart
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  test('يجب أن يعيد UserEntity عند نجاح تسجيل الدخول', () async {
    // Arrange
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => const Right(tUserEntity));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Right(tUserEntity));
    verify(() => mockRepository.login(tEmail, tPassword)).called(1);
  });
}
```
