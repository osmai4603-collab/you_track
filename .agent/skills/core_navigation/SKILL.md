---
name: إدارة التنقل (Core Navigation)
description: دليل إدارة التنقل والمسارات باستخدام مكتبة go_router.
---

# مهارة إدارة التنقل (Core Navigation)

تعتمد هذه المهارة على مكتبة `go_router` لتوفير نظام تنقل قوي، يدعم الـ Declarative Routing والـ Deep Linking.

## 💡 متى وكيف تطلب استخدام هذه المهارة؟
*   **متى؟**: عند إضافة شاشة جديدة، أو تعديل مسار حالي، أو إضافة نظام حماية للمسارات (Route Guards).
*   **كيف؟**: اطلب "أضف مساراً لصفحة تفاصيل المنتج" أو "اربط صفحة تسجيل الدخول بصفحة الملف الشخصي" أو "قم بتهيئة MaterialApp مع الـ router".

## 🎯 المعايير والضوابط التقنية
*   **المكتبة المستخدمة**: `go_router`.
*   **مكان التعريف**: يتم تعريف الكلاس المسئول عن التنقل في المسار `lib/core/services/navigation_service.dart` ويسمى `NavigationService`.
*   **تنبيه هيدر الفايل**: يجب التأكد من استدعاء مكتبة `package:go_router/go_router.dart` في ملف `navigation_service.dart` لضمان عمل الـ `GoRouter` والـ `GoRoute`.
*   **مسارات التطبيق**: يتم تعريف جميع مفاتيح المسارات (Route Keys) كثوابت في ملف `lib/core/constants/app_route_keys.dart`.
*   **تسمية المسارات**: يتم تسمية الكلاس `AppRouteKeys` ويجب أن يكون `sealed class` مع `private const constructor` وبها ثوابت من نوع `static const String`.

## 📦 المكتبات المطلوبة (Required Libraries)
*   **التنقل**: `go_router`.

## 📋 خطوات العمل الإجرائية
1.  **تعريف المفاتيح**: إضافة مسارات الصفحات في كلاس `AppRouteKeys`.
2.  **تعريف المسار (Route Definition)**: إضافة `GoRoute` في مصفوفة المسارات داخل `NavigationService`.
3.  **تهيئة التطبيق (App Initialization)**: استخدام `MaterialApp.router` في `main.dart` وربطه مع `NavigationService.router`.
4.  **التنقل (Navigation)**: **يمنع** استخدام `context.pushNamed` أو `context.goNamed` أو `Navigator` الكلاسيكي؛ بدلاً من ذلك، استخدم دوال التنقل من `context` مباشرة مثل `context.go()`, `context.push()`, `context.pop()` مع مسارات من `AppRouteKeys`.
5.  **تمرير البيانات**: استخدام الـ `extra` للبيانات المعقدة، والـ `queryParameters` للمتغيرات.

## 📝 أمثلة

### تعريف مسار بسيط:
```dart
GoRoute(
  name: AppRoutes.home.name,
  path: '/',
  builder: (context, state) => const HomePage(),
),
```

### التنقل مع بارامترات:
```dart
context.push(
  AppRouteKeys.details,
  extra: product,
);
```

### تهيئة MaterialApp.router:
```dart
return MaterialApp.router(
  routerConfig: NavigationService.router,
  // ... بقية الإعدادات (الثيم، اللغة، إلخ)
);
```

### التوجيه الشرطي (Redirect):
يستخدم للـ Auth Guard:
```dart
redirect: (context, state) {
  final isLoggedIn = context.read<AuthBloc>().state is Authenticated;
  if (!isLoggedIn) return AppRouteKeys.login;
  return null;
},
```
