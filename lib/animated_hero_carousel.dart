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
  final bool loop; // New property for infinite loop

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
    this.loop = false, // Default to false
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
      initialPage: widget.loop ? (widget.items.length * 1000000) + widget.initialIndex : widget.initialIndex,
      viewportFraction: widget.viewportFraction,
    );
    _currentIndexNotifier = ValueNotifier<int>(widget.initialIndex);

    _pageController.addListener(() {
      int currentPage = _pageController.page?.round() ?? 0;
      _currentIndexNotifier.value = currentPage % widget.items.length;
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
            itemBuilder: (context, item, index) {
              final actualIndex = widget.loop ? index % widget.items.length : index;
              return widget.itemBuilder(context, widget.items[actualIndex], actualIndex);
            },
            detailBuilder: (item, index) {
              final actualIndex = widget.loop ? index % widget.items.length : index;
              return widget.detailBuilder(widget.items[actualIndex], actualIndex);
            },
            heroTagBuilder: (item, index) {
              final actualIndex = widget.loop ? index % widget.items.length : index;
              return widget.heroTagBuilder(widget.items[actualIndex], actualIndex);
            },
            spacing: widget.spacing,
            onItemTap: widget.onItemTap,
            animationDuration: widget.animationDuration,
            animationCurve: widget.animationCurve,
            itemCount: widget.loop ? null : widget.items.length, // Set itemCount to null for infinite loop
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