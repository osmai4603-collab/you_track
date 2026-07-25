import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/theme/app_fonts.dart';

/// بطاقة نموذج تسجيل الدخول بتصميم YouTrack.
///
/// تحتوي على:
/// - عنوان "Log in to YouTrack"
/// - حقل اسم المستخدم أو البريد الإلكتروني
/// - حقل كلمة المرور مع زر إظهار/إخفاء
/// - صف يحتوي على "Remember me" و "Reset password"
/// - زر تسجيل الدخول
class LoginFormCard extends StatefulWidget {
  const LoginFormCard({super.key});

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      color: colors.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.extraLarge,
          vertical: AppSpacing.large,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── العنوان (Title) ─────────────────────────────
            const SizedBox(height: AppSpacing.small),
            Text(
              localization.loginTitle,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontFamily: AppFonts.primary,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.extraLarge),

            // ── حقل اسم المستخدم أو البريد ─────────────────
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: localization.usernameOrEmailHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.extraSmall),
                  borderSide: BorderSide(color: colors.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.extraSmall),
                  borderSide: BorderSide(color: colors.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.extraSmall),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
                // contentPadding: const EdgeInsets.symmetric(
                //   horizontal: AppSpacing.medium,
                //   vertical: AppSpacing.medium,
                // ),
              ),
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: AppFonts.primary,
                color: colors.onSurface,
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.medium),

            // ── حقل كلمة المرور ─────────────────────────────
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: localization.passwordHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.extraSmall),
                  borderSide: BorderSide(color: colors.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.extraSmall),
                  borderSide: BorderSide(color: colors.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.extraSmall),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
                // contentPadding: const EdgeInsets.symmetric(
                //   horizontal: AppSpacing.medium,
                //   vertical: AppSpacing.medium,
                // ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? AppIcons.visibilityOff
                        : AppIcons.visibility,
                    size: AppSpacing.medium,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: AppFonts.primary,
                color: colors.onSurface,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleLogin(),
            ),
            const SizedBox(height: AppSpacing.medium),

            // ── صف "تذكرني" و "إعادة تعيين كلمة المرور" ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Checkbox + Label
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: AppSpacing.large,
                      height: AppSpacing.large,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        activeColor: colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.extraSmall,
                          ),
                        ),
                        side: BorderSide(color: colors.outline),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      localization.rememberMeLabel,
                      style: textTheme.bodySmall?.copyWith(
                        fontFamily: AppFonts.primary,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),

                // Reset password
                GestureDetector(
                  onTap: () {
                    // TODO: تنقل إلى صفحة إعادة تعيين كلمة المرور
                  },
                  child: Text(
                    localization.resetPasswordButton,
                    style: textTheme.bodySmall?.copyWith(
                      fontFamily: AppFonts.primary,
                      color: colors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),

            // ── زر تسجيل الدخول (Login Button) ──────────────
            SizedBox(
              height: 44,
              child: FilledButton(
                onPressed: _handleLogin,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.extraSmall),
                  ),
                ),
                child: Text(
                  localization.loginButton,
                  style: textTheme.labelLarge?.copyWith(
                    fontFamily: AppFonts.primary,
                    fontWeight: FontWeight.w600,
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.small),
          ],
        ),
      ),
    );
  }

  void _handleLogin() {
    // TODO: تنفيذ منطق تسجيل الدخول
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      return;
    }

    // سيتم ربط هذا مع الـ Bloc/Cubit لاحقاً
  }
}
