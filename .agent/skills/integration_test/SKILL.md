---
name: فحص التكامل (Integration Test)
description: دليل فحص تدفق التطبيق بالكامل (End-to-End) والتأكد من عمل جميع الأجزاء معاً.
---

# مهارة فحص التكامل (Integration Test)

تستخدم هذه المهارة لاختبار تدفقات المستخدم الكاملة (E2E Flows) والتأكد من أن جميع الطبقات (Data, Domain, Presentation) تعمل معاً بشكل صحيح على جهاز حقيقي أو محاكي.

## 💡 متى وكيف تطلب استخدام هذه المهارة؟
*   **متى؟**: قبل إصدار نسخة جديدة (Release)، أو عند تغيير هيكلي كبير في قاعدة البيانات أو النظام، أو لضمان استقرار العمليات الأساسية مثل (الدفع، التسجيل، الطلب).
*   **كيف؟**: اطلب "قم بإجراء اختبار تكامل لعملية الشراء كاملة" أو "تحقق من تدفق تسجيل الدخول حتى الوصول للشاشة الرئيسية".

## 🎯 المعايير والضوابط التقنية
*   **المكتبة الأساسية**: `integration_test` (الموجودة في Flutter SDK).
*   **المكان**: توضع الاختبارات في مجلد `integration_test/` في جذر المشروع.
*   **التشغيل**: يتم تشغيلها باستخدام أمر `flutter test integration_test/app_test.dart`.
*   **الاستقلالية**: يجب أن يكون الاختبار قادراً على تهيئة البيئة الخاصة به (مثلاً استخدام Mock API أو قاعدة بيانات تجريبية).

## 📋 خطوات العمل الإجرائية
1.  **التهيئة**: استدعاء `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`.
2.  **تشغيل التطبيق**: استخدام `tester.pumpWidget(const MyApp())`.
3.  **محاكاة التدفق**: تنفيذ سلسلة من التفاعلات (Tap, Enter Text, Scroll).
4.  **الانتظار والتحقق**: استخدام `pumpAndSettle()` بكثافة لضمان استقرار الواجهة بين الخطوات.

## 📝 أمثلة

### هيكل اختبار تكامل:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stitch_brand_color_selection/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('تدفق تسجيل الدخول الناجح', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 1. إدخال البريد الإلكتروني
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    // 2. إدخال كلمة المرور
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    // 3. الضغط على دخول
    await tester.tap(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    // 4. التحقق من الوصول للصفحة الرئيسية
    expect(find.text('مرحباً بك في الصفحة الرئيسية'), findsOneWidget);
  });
}
```
