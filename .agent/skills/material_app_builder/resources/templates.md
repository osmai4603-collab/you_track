# نماذج الكود (Code Templates)

يوفر هذا المستند نماذج برمجية جاهزة للاستخدام عند تنفيذ مهارة **بناء المادة التطبيق**.

## 1. ويدجت الـ Application
هذه الويدجت هي المسؤولة عن بناء الـ `MaterialApp.router` والتفاعل مع تغييرات الحالة.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_local.dart';
import '../../../../core/theme/app_navigation.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/app_cubit.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state is AppLoaded) {
          final settings = state.settings;
          return MaterialApp.router(
            // جلب عنوان التطبيق من ملفات الترجمة
            title: context.l10n.appTitle,
            debugShowCheckedModeBanner: false,
            // ثيمات التطبيق
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            // التحكم في وضع الثيم المختار
            themeMode: ThemeMode.values.firstWhere(
              (e) => e.name == settings.themeMode,
              orElse: () => ThemeMode.system,
            ),
            // التحكم في اللغة
            locale: Locale(settings.locale),
            // إعدادات المسارات (GoRouter)
            routerConfig: AppRouter.router,
            // إعدادات الترجمة المعتمدة في الـ Core
            supportedLocales: AppLocal.supportedLocales,
            localizationsDelegates: AppLocal.localizationsDelegates,
            // سلوك التمرير (مثلاً للسماح بالـ Drag في الويب)
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.trackpad,
              },
            ),
          );
        }

        // شاشة تحميل أولية (Scaffold) حتى يتم قراءة الإعدادات
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
```

## 2. إدارة الحالة (AppCubit)
المسؤول عن تحميل وحفظ إعدادات الثيم واللغة.

```dart
class AppCubit extends Cubit<AppState> {
  final GetAppSettings _getAppSettings;
  final SaveAppSettings _saveAppSettings;

  AppCubit({
    required GetAppSettings getAppSettings,
    required SaveAppSettings saveAppSettings,
  })  : _getAppSettings = getAppSettings,
        _saveAppSettings = saveAppSettings,
        super(const AppInitial());

  // استدعاء هذا التابع في main.dart
  Future<void> init() async {
    emit(const AppLoading());
    final result = await _getAppSettings(params: const NoParams());
    result.fold(
      (failure) => emit(AppError(failure.message)),
      (settings) => emit(AppLoaded(settings)),
    );
  }

  // تغيير الثيم
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    if (state is AppLoaded) {
      final currentSettings = (state as AppLoaded).settings;
      final newSettings = AppSettingsModel(
        id: currentSettings.id,
        themeMode: themeMode.name,
        locale: currentSettings.locale,
      );
      
      final result = await _saveAppSettings(params: SaveAppSettingsParams(settings: newSettings));
      result.fold(
        (failure) => emit(AppError(failure.message)),
        (_) => emit(AppLoaded(newSettings)),
      );
    }
  }

  // تغيير اللغة
  Future<void> updateLocale(Locale locale) async {
    // ... منطق مشابه لتغيير الثيم ...
  }
}
```
