import 'package:flutter/material.dart';
import 'package:issues_tracking/core/constants/app_spacing.dart';
import 'package:issues_tracking/core/widgets/skeleton_shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading._(this.child, {super.key});

  factory ShimmerLoading.table({
    Key? key,
    int rows = 8,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    return ShimmerLoading._(
      _ShimmerTableSkeleton(rowCount: rows, duration: duration),
      key: key,
    );
  }

  factory ShimmerLoading.list({
    Key? key,
    int itemCount = 8,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    return ShimmerLoading._(
      _ShimmerListSkeleton(itemCount: itemCount, duration: duration),
      key: key,
    );
  }

  factory ShimmerLoading.tree({
    Key? key,
    int itemCount = 6,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    return ShimmerLoading._(
      _ShimmerTreeSkeleton(itemCount: itemCount, duration: duration),
      key: key,
    );
  }

  factory ShimmerLoading.center({
    Key? key,
    double width = 64,
    double height = 64,
  }) {
    return ShimmerLoading._(
      Center(
        child: SkeletonShimmer(width: width, height: height, borderRadius: 16),
      ),
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) => child;
}

class _ShimmerTableSkeleton extends StatelessWidget {
  final int rowCount;
  final Duration duration;

  const _ShimmerTableSkeleton({
    this.rowCount = 5,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ShimmerTableHeader(duration: duration),
          const SizedBox(height: AppSpacing.small),
          ...List.generate(
            rowCount,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.small),
              child: _ShimmerTableRow(duration: duration),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerTableHeader extends StatelessWidget {
  final Duration duration;

  const _ShimmerTableHeader({required this.duration});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 40),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: SkeletonShimmer(
            height: 18,
            borderRadius: 6,
            duration: duration,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        SizedBox(
          width: 120,
          child: SkeletonShimmer(
            height: 18,
            borderRadius: 6,
            duration: duration,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        SizedBox(
          width: 100,
          child: SkeletonShimmer(
            height: 18,
            borderRadius: 6,
            duration: duration,
          ),
        ),
      ],
    );
  }
}

class _ShimmerTableRow extends StatelessWidget {
  final Duration duration;

  const _ShimmerTableRow({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SkeletonShimmer(
          width: 24,
          height: 40,
          borderRadius: 6,
          duration: duration,
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: SkeletonShimmer(
            height: 16,
            borderRadius: 6,
            duration: duration,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        SizedBox(
          width: 120,
          child: SkeletonShimmer(
            height: 20,
            borderRadius: 6,
            duration: duration,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        SizedBox(
          width: 100,
          child: SkeletonShimmer(
            height: 20,
            borderRadius: 6,
            duration: duration,
          ),
        ),
      ],
    );
  }
}

class _ShimmerListSkeleton extends StatelessWidget {
  final int itemCount;
  final Duration duration;

  const _ShimmerListSkeleton({
    this.itemCount = 5,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.small),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonShimmer(width: 48, height: 48, borderRadius: 12),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SkeletonShimmer(
                        height: 16,
                        borderRadius: 6,
                        duration: duration,
                      ),
                      const SizedBox(height: AppSpacing.extraSmall),
                      SkeletonShimmer(
                        height: 14,
                        borderRadius: 6,
                        duration: duration,
                      ),
                      const SizedBox(height: AppSpacing.extraSmall),
                      SkeletonShimmer(
                        width: 120,
                        height: 14,
                        borderRadius: 6,
                        duration: duration,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerTreeSkeleton extends StatelessWidget {
  final int itemCount;
  final Duration duration;

  const _ShimmerTreeSkeleton({
    this.itemCount = 4,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.small),
            child: Row(
              children: [
                SizedBox(width: index * 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonShimmer(
                        height: 16,
                        borderRadius: 6,
                        duration: duration,
                      ),
                      const SizedBox(height: AppSpacing.extraSmall),
                      SkeletonShimmer(
                        width: 180,
                        height: 14,
                        borderRadius: 6,
                        duration: duration,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
