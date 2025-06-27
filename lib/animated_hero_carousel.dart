library animated_hero_carousel;

import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/indicators.dart';

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
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: widget.scrollDirection,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final heroTag = widget.heroTagBuilder(item, index);

              return GestureDetector(
                onTap: () {
                  if (widget.onItemTap != null) {
                    widget.onItemTap!(item);
                  }
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: widget.animationDuration,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return FadeTransition(
                          opacity: animation,
                          child: Hero(
                            tag: heroTag,
                            child: widget.detailBuilder(item, index),
                          ),
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(widget.spacing / 2),
                  child: Hero(
                    tag: heroTag,
                    child: widget.itemBuilder(context, item, index),
                  ),
                ),
              );
            },
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