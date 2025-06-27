import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/hero_transition_page.dart';

class CarouselCore<T> extends StatelessWidget {
  final PageController pageController;
  final Axis scrollDirection;
  final List<T> items;
  final Widget Function(BuildContext context, T item, int actualIndex) itemBuilder;
  final Widget Function(T item, int actualIndex) detailBuilder;
  final String Function(T item, int index) heroTagBuilder; // Changed to accept index
  final double spacing;
  final Function(T item)? onItemTap;
  final Duration animationDuration;
  final Curve animationCurve;
  final int? itemCount;

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
    required this.animationDuration,
    required this.animationCurve,
    this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final item = items[index % items.length];
        final heroTag = heroTagBuilder(item, index); // Pass the PageView index directly

        return GestureDetector(
          onTap: () {
            if (onItemTap != null) {
              onItemTap!(item);
            }
            Navigator.push(
              context,
              HeroTransitionPage(
                heroTag: heroTag,
                detailWidget: detailBuilder(item, index % items.length),
                transitionDuration: animationDuration,
                animationCurve: animationCurve,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(spacing / 2),
            child: Hero(
              tag: heroTag,
              child: itemBuilder(context, item, index % items.length),
            ),
          ),
        );
      },
    );
  }
}
