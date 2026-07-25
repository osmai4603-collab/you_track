import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/localization/app_locale.dart';
import 'package:issues_tracking/core/services/navigation_service.dart';
import 'package:issues_tracking/core/theme/app_theme.dart';
import 'package:issues_tracking/features/app/presentation/cubit/app_cubit.dart';
import 'package:issues_tracking/features/app/presentation/cubit/app_state.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state is AppSettingsLoaded) {
          return MaterialApp.router(
            title: 'Issues Tracking',
            debugShowCheckedModeBanner: false,

            // Theme
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: .dark, //  state.themeMode,
            // themeMode: state.themeMode,

            // Localization
            locale: state.locale,
            supportedLocales: AppLocale.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Router
            routerConfig: NavigationService.router,
          );
        }

        // Initial / Loading state
        return const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}
