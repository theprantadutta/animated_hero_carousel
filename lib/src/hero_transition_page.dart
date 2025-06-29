import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/expandable_detail_screen.dart';

class HeroTransitionPage<T> extends PageRouteBuilder {
  final String heroTag;
  final Widget detailWidget;
  final Duration transitionDuration;
  final Curve animationCurve;
  final bool enableDragToExpand;
  final double? expandedHeight;
  final double? collapsedHeight;
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
