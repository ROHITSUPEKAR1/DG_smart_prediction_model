import 'package:flutter/material.dart';
import 'skeleton_card.dart';

/// A vertical list of skeleton cards simulating a content list loading state.
///
/// Usage:
/// ```dart
/// const SkeletonList(itemCount: 4, itemHeight: 80)
/// ```
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const SkeletonList({
    super.key,
    this.itemCount = 4,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (_) => SkeletonCard(height: itemHeight),
      ),
    );
  }
}
