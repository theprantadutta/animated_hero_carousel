library animated_hero_carousel;

import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/indicators.dart';
import 'package:animated_hero_carousel/src/carousel_core.dart';
import 'dart:async';

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
  final bool loop;
  final bool autoplay;
  final Duration autoplayInterval;

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
    this.loop = false,
    this.autoplay = false,
    this.autoplayInterval = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<AnimatedHeroCarousel<T>> createState() => _AnimatedHeroCarouselState<T>();
}

class _AnimatedHeroCarouselState<T> extends State<AnimatedHeroCarousel<T>> {
  late PageController _pageController;
  late ValueNotifier<int> _currentIndexNotifier;
  Timer? _timer;

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

    if (widget.autoplay) {
      _startAutoplay();
    }
  }

  void _startAutoplay() {
    _timer = Timer.periodic(widget.autoplayInterval, (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        _pageController.animateToPage(
          nextPage,
          duration: widget.animationDuration,
          curve: widget.animationCurve,
        );
      }
    });
  }

  void _stopAutoplay() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopAutoplay();
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
            items: widget.items,
            itemBuilder: widget.itemBuilder,
            detailBuilder: widget.detailBuilder,
            heroTagBuilder: (item, index) => widget.heroTagBuilder(item, index), // Pass index to heroTagBuilder
            spacing: widget.spacing,
            onItemTap: widget.onItemTap,
            animationDuration: widget.animationDuration,
            animationCurve: widget.animationCurve,
            itemCount: widget.loop ? null : widget.items.length,
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