export 'src/carousel_style.dart';
export 'src/indicators.dart';

import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/src/indicators.dart';
import 'package:animated_hero_carousel/src/carousel_core.dart';
import 'package:animated_hero_carousel/src/hero_carousel_controller.dart';
import 'dart:async';
import 'package:animated_hero_carousel/src/carousel_style.dart';

/// A highly customizable and animated hero carousel widget for Flutter.
///
/// This widget provides a carousel with smooth hero animations,
/// various indicator types, and pre-built styles.
class AnimatedHeroCarousel<T> extends StatefulWidget {
  /// The list of data items to display in the carousel.
  final List<T> items;

  /// A builder function that returns the widget for each carousel item.
  ///
  /// Provides access to the `PageController` for custom effects like parallax.
  final Widget Function(
    BuildContext context,
    T item,
    int index,
    PageController pageController,
  ) itemBuilder;

  /// A builder function that returns the widget for the detail screen,
  /// which is shown when an item is tapped.
  final Widget Function(T item, int index) detailBuilder;

  /// A function that returns a unique hero tag for each item
  /// to enable the transition animation.
  final String Function(T item, int actualIndex, int pageViewIndex)
      heroTagBuilder;

  /// The axis along which the carousel scrolls. Defaults to `Axis.horizontal`.
  final Axis scrollDirection;

  /// The initial page index to display. Defaults to `0`.
  final int initialIndex;

  /// The spacing between carousel items.
  ///
  /// If a `style` is provided, this value will be overridden by the style's spacing.
  final double? spacing;

  /// A callback function that is invoked when a carousel item is tapped.
  final Function(T item)? onItemTap;

  /// Whether to display the page indicators.
  ///
  /// If a `style` is provided, this value will be overridden. Defaults to `true`.
  final bool? showIndicators;

  /// The fraction of the viewport that each page should occupy.
  ///
  /// If a `style` is provided, this value will be overridden.
  final double? viewportFraction;

  /// The duration of the page transition animation.
  ///
  /// If a `style` is provided, this value will be overridden.
  final Duration? animationDuration;

  /// The curve of the page transition animation.
  ///
  /// If a `style` is provided, this value will be overridden.
  final Curve? animationCurve;

  /// Whether the carousel should loop infinitely. Defaults to `false`.
  final bool loop;

  /// Whether the carousel should autoplay. Defaults to `false`.
  final bool autoplay;

  /// The time interval between autoplay transitions. Defaults to `3 seconds`.
  final Duration autoplayInterval;

  /// An optional controller to programmatically control the carousel.
  final HeroCarouselController? controller;

  /// Whether to enable the drag-to-expand functionality on the detail screen.
  /// Defaults to `false`.
  final bool enableDragToExpand;

  /// The height of the detail screen when fully expanded.
  ///
  /// **Required** if `enableDragToExpand` is `true`.
  final double? expandedHeight;

  /// The height of the detail screen when collapsed.
  ///
  /// **Required** if `enableDragToExpand` is `true`.
  final double? collapsedHeight;

  /// An optional builder for a custom drag handle on the expandable detail screen.
  final Widget Function(BuildContext context)? dragHandleBuilder;

  /// A pre-defined or custom `CarouselStyle` to apply to the carousel.
  ///
  /// Overrides individual styling properties.
  final CarouselStyle? style;

  /// The type of indicator to display.
  ///
  /// Can be `dot`, `bar`, or `worm`. Defaults to `dot`.
  final IndicatorType indicatorType;

  /// The parallax effect factor.
  ///
  /// A value between `0.0` and `1.0` is recommended.
  /// If a `style` is provided, this value will be overridden.
  final double? parallaxFactor;

  const AnimatedHeroCarousel({
    super.key,
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
  });

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
            parallaxFactor:
                widget.parallaxFactor ?? widget.style?.parallaxFactor ?? 0.0,
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