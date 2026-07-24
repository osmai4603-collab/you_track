---
name: فحص الواجهات (Widget Test)
description: دليل فحص المكونات المرئية (Widgets) والتفاعل معها.
---

# مهارة فحص الواجهات (Widget Test)

تستخدم هذه المهارة للتأكد من أن الـ Widgets تظهر بشكل صحيح وتتفاعل مع أحداث المستخدم (User Events) كما هو متوقع.

## 💡 متى وكيف تطلب استخدام هذه المهارة؟
*   **متى؟**: عند بناء مكون UI جديد (Custom Widget)، أو للتأكد من أن الشاشة تعرض البيانات الصحيحة، أو للتحقق من عمل الأزرار والقوائم.
*   **كيف؟**: اطلب "اختبر ظهور زر التحقق في صفحة التسجيل" أو "تأكد من أن قائمة المنتجات تعرض 3 عناصر".

## 🎯 المعايير والضوابط التقنية
*   **المكتبة الأساسية**: `flutter_test`.
*   **البحث عن العناصر**: استخدم `find` للوصول إلى العناصر (بواسطة النص، الأيقونة، أو النوع).
*   **التفاعل**: استخدم `tester.tap()`, `tester.enterText()`, `tester.drag()`.
*   **الانتظار**: استخدم `tester.pump()` أو `tester.pumpAndSettle()` لتحديث الواجهة بعد التفاعل.

## 📋 خطوات العمل الإجرائية
1.  **بناء الـ Widget**: استخدم `tester.pumpWidget()` لتحميل المكون في بيئة الاختبار.
2.  **البحث (Finding)**: استخدام `find.text()`, `find.byIcon()`, `find.byType()`.
3.  **التحقق (Verification)**: استخدام `expect(find..., findsOneWidget)` أو `findsNothing`.
4.  **التفاعل (Interaction)**: تنفيذ حركات المستخدم ثم استدعاء `pump()`.

## 📝 أمثلة

### هيكل اختبار Widget بسيط:
```dart
void main() {
  testWidgets('يجب أن يظهر عنوان الصفحة بشكل صحيح', (WidgetTester tester) async {
    // Arrange: تحميل الـ Widget
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Act: البحث عن نص معين
    final titleFinder = find.text('تسجيل الدخول');

    // Assert: التحقق من الوجود
    expect(titleFinder, findsOneWidget);
  });
}
```

### التفاعل مع الأزرار:
```dart
testWidgets('يجب الضغط على الزر وتغيير الحالة', (tester) async {
  await tester.pumpWidget(const MyCustomButton());

  // الضغط على الزر
  await tester.tap(find.byType(ElevatedButton));
  
  // الانتظار حتى تنتهي الرسوم المتحركة
  await tester.pumpAndSettle();

  // التحقق من النتيجة
  expect(find.text('تم الضغط!'), findsOneWidget);
});
```
