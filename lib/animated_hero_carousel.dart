library animated_hero_carousel;

export 'src/carousel_style.dart';
export 'src/indicators.dart';

import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/indicators.dart';
import 'package:animated_hero_carousel/src/carousel_core.dart';
import 'package:animated_hero_carousel/src/hero_carousel_controller.dart';
import 'dart:async';
import 'package:animated_hero_carousel/src/carousel_style.dart';

class AnimatedHeroCarousel<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index, PageController pageController)
      itemBuilder;
  final Widget Function(T item, int index) detailBuilder;
  final String Function(T item, int actualIndex, int pageViewIndex) heroTagBuilder;
  final Axis scrollDirection;
  final int initialIndex;
  final double? spacing;
  final Function(T item)? onItemTap;
  final bool? showIndicators;
  final double? viewportFraction;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final bool loop;
  final bool autoplay;
  final Duration autoplayInterval;
  final HeroCarouselController? controller;
  final bool enableDragToExpand;
  final double? expandedHeight;
  final double? collapsedHeight;
  final Widget Function(BuildContext context)? dragHandleBuilder;
  final CarouselStyle? style;
  final IndicatorType indicatorType;
  final double? parallaxFactor;

  const AnimatedHeroCarousel({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.detailBuilder,
    required this.heroTagBuilder,
    this.scrollDirection = Axis.horizontal,
    this.initialIndex = 0,
    this.spacing,
    this.onItemTap,
    this.showIndicators,
    this.viewportFraction,
    this.animationDuration,
    this.animationCurve,
    this.loop = false,
    this.autoplay = false,
    this.autoplayInterval = const Duration(seconds: 3),
    this.controller,
    this.enableDragToExpand = false,
    this.expandedHeight,
    this.collapsedHeight,
    this.dragHandleBuilder,
    this.style,
    this.indicatorType = IndicatorType.dot,
    this.parallaxFactor,
  }) : super(key: key);

  @override
  State<AnimatedHeroCarousel<T>> createState() =>
      _AnimatedHeroCarouselState<T>();
}

class _AnimatedHeroCarouselState<T> extends State<AnimatedHeroCarousel<T>> {
  late PageController _pageController;
  late ValueNotifier<int> _currentIndexNotifier;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.loop
          ? (widget.items.length * 1000) + widget.initialIndex
          : widget.initialIndex,
      viewportFraction:
          widget.viewportFraction ?? widget.style?.viewportFraction ?? 0.8,
    );
    _currentIndexNotifier = ValueNotifier<int>(widget.initialIndex);

    _pageController.addListener(() {
      int currentPage = _pageController.page?.round() ?? 0;
      _currentIndexNotifier.value = currentPage % widget.items.length;
    });

    if (widget.autoplay) {
      _startAutoplay();
    }

    widget.controller?.attach(_pageController);
  }

  void _startAutoplay() {
    _timer = Timer.periodic(widget.autoplayInterval, (timer) {
      if (_pageController.hasClients) {
        int nextPage = _pageController.page!.round() + 1;
        _pageController.animateToPage(
          nextPage,
          duration: widget.animationDuration ??
              widget.style?.animationDuration ??
              const Duration(milliseconds: 300),
          curve: widget.animationCurve ??
              widget.style?.animationCurve ??
              Curves.ease,
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
    widget.controller?.detach();
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
            key: const Key('carousel_core'),
            pageController: _pageController,
            scrollDirection: widget.scrollDirection,
            items: widget.items,
            itemBuilder: (context, item, index, pageController) =>
                widget.itemBuilder(context, item, index, pageController),
            detailBuilder: widget.detailBuilder,
            heroTagBuilder: (item, index, pageViewIndex) =>
                widget.heroTagBuilder(item, index, pageViewIndex),
            spacing: widget.spacing ?? widget.style?.spacing ?? 0.0,
            onItemTap: widget.onItemTap,
            animationDuration: widget.animationDuration ??
                widget.style?.animationDuration ??
                const Duration(milliseconds: 300),
            animationCurve: widget.animationCurve ??
                widget.style?.animationCurve ??
                Curves.ease,
            itemCount: widget.loop ? null : widget.items.length,
            enableDragToExpand: widget.enableDragToExpand,
            expandedHeight: widget.expandedHeight,
            collapsedHeight: widget.collapsedHeight,
            dragHandleBuilder: widget.dragHandleBuilder,
            parallaxFactor: widget.parallaxFactor ?? widget.style?.parallaxFactor ?? 0.0,
          ),
        ),
        if (widget.showIndicators ?? widget.style?.showIndicators ?? false)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, child) {
                return CarouselIndicators(
                  itemCount: widget.items.length,
                  currentIndex: currentIndex,
                  onIndicatorTap: (index) {
                    _pageController.animateToPage(
                      widget.loop
                          ? (_pageController.page!.round() ~/
                                  widget.items.length *
                                  widget.items.length) +
                              index
                          : index,
                      duration: widget.animationDuration ??
                          widget.style?.animationDuration ??
                          const Duration(milliseconds: 300),
                      curve: widget.animationCurve ??
                          widget.style?.animationCurve ??
                          Curves.ease,
                    );
                  },
                  indicatorType: widget.indicatorType,
                );
              },
            ),
          ),
      ],
    );
  }
}
