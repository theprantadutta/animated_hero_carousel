import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/hero_transition_page.dart';
import 'package:animated_hero_carousel/src/expandable_detail_screen.dart';

class CarouselCore<T> extends StatelessWidget {
  final PageController pageController;
  final Axis scrollDirection;
  final List<T> items;
  final Widget Function(
      BuildContext context, T item, int actualIndex, PageController pageController) itemBuilder;
  final Widget Function(T item, int actualIndex) detailBuilder;
  final String Function(T item, int actualIndex, int pageViewIndex) heroTagBuilder; // Updated signature
  final double spacing;
  final Function(T item)? onItemTap;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final int? itemCount;
  final bool enableDragToExpand;
  final double? expandedHeight;
  final double? collapsedHeight;
  final Widget Function(BuildContext context)? dragHandleBuilder;
  final double? parallaxFactor;

  const CarouselCore({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final actualIndex = index % items.length;
        final item = items[actualIndex];
        final heroTag = heroTagBuilder(item, actualIndex, index); // Pass all three parameters

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
