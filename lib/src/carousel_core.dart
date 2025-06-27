import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/hero_transition_page.dart';

class CarouselCore<T> extends StatelessWidget {
  final PageController pageController;
  final Axis scrollDirection;
  final List<T> items; // Corrected: items should be passed directly
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(T item, int index) detailBuilder;
  final String Function(T item, int index) heroTagBuilder;
  final double spacing;
  final Function(T item)? onItemTap;
  final Duration animationDuration;
  final Curve animationCurve;

  const CarouselCore({
    Key? key,
    required this.pageController,
    required this.scrollDirection,
    required this.items, // Corrected: items should be passed directly
    required this.itemBuilder,
    required this.detailBuilder,
    required this.heroTagBuilder,
    this.spacing = 0.0,
    this.onItemTap,
    required this.animationDuration,
    required this.animationCurve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: scrollDirection,
      itemCount: items.length, // Use the passed items list
      itemBuilder: (context, index) {
        final item = items[index]; // Use the passed items list
        final heroTag = heroTagBuilder(item, index);

        return GestureDetector(
          onTap: () {
            if (onItemTap != null) {
              onItemTap!(item);
            }
            Navigator.push(
              context,
              HeroTransitionPage(
                heroTag: heroTag,
                detailWidget: detailBuilder(item, index),
                transitionDuration: animationDuration,
                animationCurve: animationCurve,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(spacing / 2),
            child: Hero(
              tag: heroTag,
              child: itemBuilder(context, item, index),
            ),
          ),
        );
      },
    );
  }
}