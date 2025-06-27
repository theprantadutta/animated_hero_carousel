library animated_hero_carousel;

import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/indicators.dart';
import 'package:animated_hero_carousel/src/carousel_core.dart';

class AnimatedHeroCarousel<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(T item, int index) detailBuilder;
  final String Function(T item, int index) heroTagBuilder;
  final Axis scrollDirection;
  final int initialIndex;
  final double spacing;
  final Function(T item)? onItemTap;
  final bool showIndicators;
  final double viewportFraction;
  final Duration animationDuration;
  final Curve animationCurve;

  const AnimatedHeroCarousel({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.detailBuilder,
    required this.heroTagBuilder,
    this.scrollDirection = Axis.horizontal,
    this.initialIndex = 0,
    this.spacing = 0.0,
    this.onItemTap,
    this.showIndicators = false,
    this.viewportFraction = 0.8,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.ease,
  }) : super(key: key);

  @override
  State<AnimatedHeroCarousel<T>> createState() => _AnimatedHeroCarouselState<T>();
}

class _AnimatedHeroCarouselState<T> extends State<AnimatedHeroCarousel<T>> {
  late PageController _pageController;
  late ValueNotifier<int> _currentIndexNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: widget.viewportFraction,
    );
    _currentIndexNotifier = ValueNotifier<int>(widget.initialIndex);

    _pageController.addListener(() {
      _currentIndexNotifier.value = _pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: CarouselCore<T>(
            pageController: _pageController,
            scrollDirection: widget.scrollDirection,
            items: widget.items, // Pass items to CarouselCore
            itemBuilder: widget.itemBuilder,
            detailBuilder: widget.detailBuilder,
            heroTagBuilder: widget.heroTagBuilder,
            spacing: widget.spacing,
            onItemTap: widget.onItemTap,
            animationDuration: widget.animationDuration,
            animationCurve: widget.animationCurve,
          ),
        ),
        if (widget.showIndicators)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, child) {
                return CarouselIndicators(
                  itemCount: widget.items.length,
                  currentIndex: currentIndex,
                );
              },
            ),
          ),
      ],
    );
  }
}
