import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issues_tracking/core/constants/app_icons.dart';
import 'package:issues_tracking/core/constants/app_radius.dart';
import 'package:issues_tracking/core/constants/app_route_keys.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/init_dependencies.dart';
import 'package:issues_tracking/core/localization/app_localizations.dart';
import 'package:issues_tracking/core/theme/app_fonts.dart';
import 'package:issues_tracking/features/users/domain/usecases/user_session.dart';
import 'package:issues_tracking/features/users/presentation/bloc/cubits/login_cubit.dart';

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
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _usernameController.text = savedEmail;
      setState(() => _rememberMe = true);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('saved_email', email);
    } else {
      await prefs.remove('saved_email');
    }

    if (!mounted) return;
    context.read<LoginCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success && state.user != null) {
          get_it<UserSession>().setUser(state.user!);
          if (!context.mounted) return;
          context.go(AppRouteKeys.dashboard);
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: SelectableText(state.errorMessage ?? '')),
          );
          context.read<LoginCubit>().resetStatus();
        }
      },
      builder: (context, state) {
        final isLoading = state.status == LoginStatus.loading;

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
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    fontFamily: AppFonts.primary,
                    color: colors.onSurface,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.medium),

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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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

                SizedBox(
                  height: 44,
                  child: FilledButton(
                    onPressed: isLoading ? null : _handleLogin,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.extraSmall),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.onPrimary,
                            ),
                          )
                        : Text(
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
      },
    );
  }
}
