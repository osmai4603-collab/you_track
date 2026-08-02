import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/theme/app_fonts.dart';
import 'package:issues_tracking/features/users/presentation/bloc/cubits/login_cubit.dart';
import 'package:issues_tracking/features/users/presentation/widgets/widgets/login_header.dart';
import 'package:issues_tracking/features/users/presentation/widgets/widgets/login_form_card.dart';

/// صفحة تسجيل الدخول الرئيسية بتصميم YouTrack.
///
/// تتكون من:
/// - بطاقة واحدة (Card) تجمع الرأس والنموذج مع ظل موحد.
/// - تذييل (Footer) يحتوي على رابط سياسة الخصوصية.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => get_it<LoginCubit>(),
      child: Scaffold(
        backgroundColor: colors.surface,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              margin: AppSpacing.paddingAllLarge,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── البطاقة الرئيسية (Main Card) ──────────────
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLowest,
                      borderRadius: AppRadius.mediumBorderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: 0.1),
                          blurRadius: AppSpacing.extraLarge,
                          spreadRadius: 2,
                          offset: const Offset(0, AppSpacing.extraSmall),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── الرأس (Header) ────────────────────
                        LoginHeader(),

                        // ── النموذج (Form) ────────────────────
                        LoginFormCard(),
                      ],
                    ),
                  ),

                  // ── التذييل (Footer) ──────────────────────────
                  const SizedBox(height: AppSpacing.extraLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localization.privacyPolicyLabel,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontFamily: AppFonts.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.extraSmall),
                      GestureDetector(
                        onTap: () {
                          // TODO: فتح صفحة سياسة الخصوصية
                        },
                        child: Text(
                          localization.privacyPolicyButton,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.primary,
                            fontFamily: AppFonts.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
