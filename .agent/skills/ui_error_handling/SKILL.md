---
name: "إدارة أخطاء الواجهة (UI Error Handling)"
description: "دليل التعامل مع أخطاء النظام وعرضها للمستخدم بشكل جمالي (Animated)، قابل للتحديد (Selectable)، مع أزرار مساعدة (Copy, Retry, Back)."
---

# 🛑 مهارة عرض الأخطاء للمستخدم (UI Error Handling)

تهدف هذه المهارة إلى توحيد طريقة عرض حالات الخطأ (Error States) للمستخدم، وذلك لتوفير تجربة مستخدم (UX) ممتازة حتى عند فشل النظام.

## 🎯 الميزات (Features)

1.  **حركات بصرية (Animations)**: تأثيرات دخول ناعمة لتخفيف حدة ظهور الخطأ.
2.  **أيقونات ودلالات لونية**: لون أحمر (Error Color) لتمييز حالة النظام.
3.  **النص قابل للتحديد (SelectableText)**: لتسهيل قيام المستخدم أو المطور بتصوير أو نسخ التفاصيل التقنية.
4.  **أزرار التفاعل (Action Buttons)**: 
    *   **زر النسخ (Copy)**: لنسخ محتوى الخطأ للحافظة (Clipboard).
    *   **زر إعادة المحاولة (Retry)**: مخصص لإعادة تحميل البيانات (Refresh Event).
    *   **زر الرجوع (Back)**: للعودة للصفحة السابقة إذا انعدمت البدائل.

## 📍 مسار الـ Widget المعتمد

**يجب دائماً استدعاء المكون المركزي للخطأ**:
`lib/core/widgets/app_error_widget.dart`

**ممنوع**: بناء واجهات عرض أخطاء يدوية أو استخدام `Text` بدائي مع لون أحمر لعرض الأعطال داخل الشاشات (`Pages`). يجب دائماً استخدام `AppErrorWidget`.

## 💻 مثال تطبيقي (Template)

استخدم الكود التالي داخل دوال الـ `BlocBuilder` أو الـ `FutureBuilder`:

```dart
import 'package:[app_name]/core/widgets/app_error_widget.dart';

// ... داخل بلوك الحالة (State Management)
if (state is DataError) {
  return AppErrorWidget(
    title: localization.errorTitle, // اختياري
    message: state.errorMessage,    // إجباري: تفاصيل الخطأ
    showCopyButton: true,           // إظهار زر النسخ (مفعل افتراضياً)
    onRetry: () {
      // تنفيذ إعادة الطلب البرمجي
      context.read<DataBloc>().add(FetchDataEvent());
    },
    onBack: () {
      // مخصص لزر الرجوع إن لم يكن يعتمد على Navigation الافتراضي
      context.pop();
    },
  );
}
```

## 📐 المعايير التقنية (Standards)

1.  **حماية المحتوى**: أي خطأ يعرض تفاصيل تقنية معقدة (כمثل سطور Exception طويلة) سيظل داخل صندوق يمكن التمرير (Scroll) داخله، مما يمنع تجاوز أبعاد الشاشة (Overflow).
2.  **أولوية النسخ**: يسهل وجود زر (نسخ الخطأ) عمليات استكشاف الأخطاء للمطورين وموظفي الدعم التقني، مما يعجل من الحل.
3.  **الاستقلالية**: لا يتم الاعتماد على مكتبات خارجية عدا `go_router` الافتراضي وتصميمات الهوية (AppSpacing, Icons, Colors).
