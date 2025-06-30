import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/hero_transition_page.dart';

/// The core widget that handles the `PageView` and hero transitions.
///
/// This widget is used internally by `AnimatedHeroCarousel` and is not
/// intended for direct use.
class CarouselCore<T> extends StatelessWidget {
  /// The controller for the `PageView`.
  final PageController pageController;

  /// The scroll direction of the carousel.
  final Axis scrollDirection;

  /// The list of items to display.
  final List<T> items;

  /// The builder for each carousel item.
  final Widget Function(
    BuildContext context,
    T item,
    int actualIndex,
    PageController pageController,
  ) itemBuilder;

  /// The builder for the detail screen.
  final Widget Function(T item, int actualIndex) detailBuilder;

  /// The builder for the hero tag.
  final String Function(T item, int actualIndex, int pageViewIndex)
      heroTagBuilder;

  /// The spacing between items.
  final double spacing;

  /// A callback for when an item is tapped.
  final Function(T item)? onItemTap;

  /// The duration of the hero transition.
  final Duration? animationDuration;

  /// The curve of the hero transition.
  final Curve? animationCurve;

  /// The total number of items in the `PageView`.
  final int? itemCount;

  /// Whether to enable the drag-to-expand functionality.
  final bool enableDragToExpand;

  /// The expanded height of the detail screen.
  final double? expandedHeight;

  /// The collapsed height of the detail screen.
  final double? collapsedHeight;

  /// The builder for the drag handle.
  final Widget Function(BuildContext context)? dragHandleBuilder;

  /// The parallax factor for the items.
  final double? parallaxFactor;

  const CarouselCore({
    super.key,
    required this.pageController,
    required this.scrollDirection,
    required this.items,
    required this.itemBuilder,
    required this.detailBuilder,
    required this.heroTagBuilder,
    this.spacing = 0.0,
    this.onItemTap,
    this.animationDuration,
    this.animationCurve,
    this.itemCount,
    this.enableDragToExpand = false,
    this.expandedHeight,
    this.collapsedHeight,
    this.dragHandleBuilder,
    this.parallaxFactor,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final actualIndex = index % items.length;
        final item = items[actualIndex];
        final heroTag = heroTagBuilder(
          item,
          actualIndex,
          index,
        ); // Pass all three parameters

        return GestureDetector(
          onTap: () {
            if (onItemTap != null) {
              onItemTap!(item);
            }
            Navigator.push(
              context,
              HeroTransitionPage(
                heroTag: heroTag,
                detailWidget: detailBuilder(item, actualIndex),
                transitionDuration:
                    animationDuration ?? const Duration(milliseconds: 300),
                animationCurve: animationCurve ?? Curves.ease,
                enableDragToExpand: enableDragToExpand,
                expandedHeight: expandedHeight,
                collapsedHeight: collapsedHeight,
                dragHandleBuilder: dragHandleBuilder,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(spacing / 2),
            child: Hero(
              tag: heroTag,
              child: itemBuilder(context, item, actualIndex, pageController),
            ),
          ),
        );
      },
    );
  }
}
