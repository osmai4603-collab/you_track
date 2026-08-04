import 'package:flutter/material.dart';

class ArticleSkeletonLoader extends StatefulWidget {
  const ArticleSkeletonLoader({super.key});

  @override
  State<ArticleSkeletonLoader> createState() => _ArticleSkeletonLoaderState();
}

class _ArticleSkeletonLoaderState extends State<ArticleSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _buildSkeleton(context, _animation.value);
      },
    );
  }

  Widget _buildSkeleton(BuildContext context, double opacity) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final skeletonColor = baseColor.withValues(alpha: opacity);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 28,
            width: 260,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 14,
            width: 200,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 20,
            width: 180,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: skeletonColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
