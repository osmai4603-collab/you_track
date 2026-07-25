import 'dart:math';
import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/theme/app_fonts.dart';

/// رأس صفحة تسجيل الدخول بتصميم YouTrack.
///
/// يتكون من خلفية داكنة متدرجة مع شعار YT بشكل ماسي (Diamond Shape)
/// وتأثير توهج (Glow) باللون الوردي المائل.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.small),
      ),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1117),
              Color(0xFF161B22),
              Color(0xFF1A1F2B),
              Color(0xFF0D1117),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── تأثير التوهج (Glow Effect) ──────────────────
            Positioned(
              top: 10,
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE91E8C).withValues(alpha: 0.15),
                      const Color(0xFF6366F1).withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    radius: 1.2,
                  ),
                ),
              ),
            ),

            // ── خط متوهج أفقي (Subtle Glow Line) ─────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      const Color(0xFF6366F1).withValues(alpha: 0.3),
                      const Color(0xFFE91E8C).withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── شعار YT (Diamond Logo) ──────────────────────
            const _YouTrackLogo(),
          ],
        ),
      ),
    );
  }
}

/// شعار YouTrack بشكل الماسة (Diamond Shape).
///
/// يستخدم CustomPaint لرسم الشكل الماسي مع حدود متوهجة
/// ونص "YT" في المنتصف مع خط أفقي سفلي.
class _YouTrackLogo extends StatelessWidget {
  const _YouTrackLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: _DiamondLogoPainter(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'YT',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.0,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: 18,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// رسام (Painter) لشكل الماسة في شعار YouTrack.
///
/// يرسم شكل مضلع ماسي (مسدس) مع تدرج لوني من الوردي إلى البنفسجي
/// وتأثير ظل متوهج (Glow Shadow).
class _DiamondLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // رسم الشكل الماسي (مضلع سداسي مائل)
    final path = Path();
    const sides = 6;
    const rotationAngle = -pi / 2;

    for (int i = 0; i < sides; i++) {
      final angle = (2 * pi / sides) * i + rotationAngle;
      // تعديل نصف القطر لتشكيل ماسة مميزة
      final r = (i % 2 == 0) ? radius * 0.95 : radius * 0.8;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // التدرج اللوني (Gradient)
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFE91E8C),
          Color(0xFFD946BF),
          Color(0xFF8B5CF6),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // تأثير الظل المتوهج
    canvas.drawShadow(path, const Color(0xFFE91E8C), 12, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
