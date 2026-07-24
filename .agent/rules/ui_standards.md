---
trigger: always_on
description: قواعد يجب الالتزام بها في بناء واجهات المستخدم UI
---

# 🎨 UI Standards (معايير الواجهات)

هذا المستند يجمع القواعد العامة التي يجب اتباعها في تطوير الواجهات (UI) لضمان اتساق الكود وسهولة صيانته.

---

## 🌍 1. معايير النصوص والترجمة (Localization Standards)

* **يمنع منعاً باتاً** كتابة النصوص (Hardcoded Strings) بشكل مباشر داخل مجلد الـ `presentation`.
* يجب استدعاء جميع النصوص من خلال كلاس `AppLocalizations`.
* **يجب** تعريف متغير محلي باسم `localization` في أعلى دالة الـ `build`:
    `final localization = AppLocalizations.of(context)!;`
* يتم استدعاء قيمة النص من داخل المتغير `localization`.

### ✅ استخدام النصوص (Correct)

```dart
@override
Widget build(BuildContext context) {
  final localization = AppLocalizations.of(context)!;
  return Text(localization.welcomeMessage);
}
```

---

## 🏗️ 2. معايير الأيقونات (Icon Standards)

* **يمنع منعاً باتاً** استدعاء الأيقونات مباشرة من مكتبة `Icons` أو استدعاء مسارات `Assets` للأيقونات داخل الـ UI.
* يجب استدعاء جميع الأيقونات المعتمدة في التطبيق من كلاس `AppIcons`.

### ✅ استخدام الأيقونات (Correct)

```dart
Icon(AppIcons.addCircle)
```

---

## 🎨 3. معايير الألوان (Colors Standards)

* **يمنع منعاً باتاً** استدعاء الألوان مباشرة من مكتبة `Colors` أو تعريف `Color(0xFF...)` داخل الـ UI.
* يجب استدعاء الألوان من داخل الثيم (Theme) من خلال كائن `colorScheme`.
* **يجب** تعريف متغير محلي باسم `colors` في أعلى دالة الـ `build`:
    `final colors = Theme.of(context).colorScheme;`
* يتم استدعاء القيمة اللونية من داخل المتغير `colors`.

### ✅ استخدام الألوان (Correct)

```dart
@override
Widget build(BuildContext context) {
  final colors = Theme.of(context).colorScheme;
  return Container(color: colors.primary);
}
```

---

## 📏 4. معايير المسافات (Spacing Standards)

* **يمنع منعاً باتاً** استدعاء أي قيم مسافات (SizedBox) أو حواف (Padding) بشكل مباشر بقيم عددية.
* يجب استدعاء قيم المسافات والحواف من كلاس `AppSpacing`.

### ✅ استخدام المسافات (Correct)

```dart
Padding(
  padding: AppSpacing.paddingAllMedium,
  child: const SizedBox(height: AppSpacing.medium),
)
```

---

## 🟢 5. معايير انحناء الحواف (Border Radius Standards)

* **يمنع منعاً باتاً** تعريف انحناء الحواف (Border Radius) بشكل مباشر بقيم عددية (مثل `16.0`).
* يجب استدعاء قيم انحناء الحواف من كلاس `AppRadius`.

### ✅ استخدام الانحناء (Correct)

```dart
Container(
  decoration: BoxDecoration(
    borderRadius: AppRadius.mediumBorderRadius,
  ),
)
```

---

## 🔢 6. معايير أحجام العناصر (App Sizes Standards)

* **يمنع منعاً باتاً** استدعاء قيم مقاسات العناصر (مثل `Container, Card, SizedBox, ListTile, Images`) بشكل مباشر بقيم عددية.
* يجب استدعاء هذه القيم من داخل كلاس `AppSizes`.

### ✅ استخدام الأحجام (Correct)

```dart
SizedBox(
  width: AppSizes.buttonWidth,
  height: AppSizes.buttonHeight,
)
```

---

## 📝 7. معايير أنماط النصوص (Text Theme Standards)

* **يمنع منعاً باتاً** تعريف `TextStyle` بشكل مباشر داخل واجهات المستخدم.
* يجب استدعاء أنماط الخطوط الموحدة من كلاس `AppTextTheme`.

### ✅ استخدام الأنماط (Correct)

```dart
Text(
  localization.homeTitle,
  style: AppTextTheme.headlineMedium,
)
```

---

## 🖋️ 8. معايير أنواع الخطوط (Fonts Standards)

* **يمنع منعاً باتاً** كتابة أي نوع خط (Font Family) داخل واجهة المستخدم بشكل مباشر.
* يجب استدعاء نوع الخط من كلاس `AppFonts`.

### ✅ استخدام الخطوط (Correct)

```dart
TextStyle(fontFamily: AppFonts.primary)
```

---

## 🗣️ 9. معايير لغة التطبيق (App Locale Standards)

* **يمنع منعاً باتاً** كتابة كود لغة نصية (Language Code) بشكل مباشر (مثل `'ar', 'en'`).
* يجب استدعاء كود اللغة من كلاس `AppLocale`.

### ✅ استخدام أكواد اللغة (Correct)

```dart
if (currentLocale == AppLocale.arabic) { ... }
```

---

## 🗺️ 10. معايير مفاتيح المسارات (App Route Keys Standards)

* **يمنع منعاً باتاً** كتابة نصوص مسارات التنقل (Route Paths) بشكل مباشر.
* يجب استدعاء هذه النصوص والمفاتيح من كلاس `AppRouteKeys`.

### ✅ استخدام المسارات (Correct)

```dart
AppRoute.go(AppRouteKeys.login);
```

---

> [!IMPORTANT]
> الالتزام بهذه الأنماط يضمن أن الكود نظيف (Clean) وسهل القراءة ويتبع معايير هندسة البرمجيات المعتمدة في المشروع، ويسهل جداً أي تغيير مستقبلي في الهوية البصرية للتطبيق.
