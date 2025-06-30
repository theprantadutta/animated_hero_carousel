import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/expandable_detail_screen.dart';

/// A `PageRouteBuilder` that creates a hero transition to a detail screen.
///
/// This page route is used to wrap the detail screen and provide the
/// hero animation, as well as the optional drag-to-expand functionality.
class HeroTransitionPage<T> extends PageRouteBuilder {
  /// The hero tag for the transition.
  final String heroTag;

  /// The widget to display on the detail screen.
  final Widget detailWidget;

  @override
  final Duration transitionDuration;

  /// The curve of the hero transition.
  final Curve animationCurve;

  /// Whether to enable the drag-to-expand functionality.
  final bool enableDragToExpand;

  /// The expanded height of the detail screen.
  final double? expandedHeight;

  /// The collapsed height of the detail screen.
  final double? collapsedHeight;

  /// The builder for the drag handle.
  final Widget Function(BuildContext context)? dragHandleBuilder;

  HeroTransitionPage({
    required this.heroTag,
    required this.detailWidget,
    required this.transitionDuration,
    required this.animationCurve,
    this.enableDragToExpand = false,
    this.expandedHeight,
    this.collapsedHeight,
    this.dragHandleBuilder,
  }) : super(
          transitionDuration: transitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: Hero(
                tag: heroTag,
                child: enableDragToExpand
                    ? ExpandableDetailScreen(
                        detailWidget: detailWidget,
                        expandedHeight: expandedHeight!,
                        collapsedHeight: collapsedHeight!,
                        dragHandleBuilder: dragHandleBuilder,
                      )
                    : detailWidget,
              ),
            );
          },
        );
}