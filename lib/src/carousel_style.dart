import 'package:flutter/material.dart';

/// Defines the visual style of the carousel.
///
/// Use the pre-built factories (`netflix`, `instagram`, `spotify`) for a quick
/// setup, or create a custom `CarouselStyle` for a unique look.
class CarouselStyle {
  /// The fraction of the viewport that each page should occupy.
  final double? viewportFraction;

  /// The spacing between carousel items.
  final double? spacing;

  /// Whether to display the page indicators.
  final bool? showIndicators;

  /// The parallax effect factor.
  final double? parallaxFactor;

  /// The duration of the page transition animation.
  final Duration? animationDuration;

  /// The curve of the page transition animation.
  final Curve? animationCurve;

  const CarouselStyle({
    this.viewportFraction,
    this.spacing,
    this.showIndicators,
    this.parallaxFactor,
    this.animationDuration,
    this.animationCurve,
  });

  /// A sleek, modern carousel style inspired by Netflix's UI.
  factory CarouselStyle.netflix() {
    return const CarouselStyle(
      viewportFraction: 0.9,
      spacing: 8.0,
      showIndicators: false,
      parallaxFactor: 0.3,
      animationDuration: Duration(milliseconds: 400),
      animationCurve: Curves.easeOut,
    );
  }

  /// A full-width carousel style similar to Instagram's feed.
  factory CarouselStyle.instagram() {
    return const CarouselStyle(
      viewportFraction: 1.0,
      spacing: 0.0,
      showIndicators: true,
      parallaxFactor: 0.0,
      animationDuration: Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
    );
  }

  /// A carousel style with a prominent item and spacing, like Spotify's UI.
  factory CarouselStyle.spotify() {
    return const CarouselStyle(
      viewportFraction: 0.85,
      spacing: 16.0,
      showIndicators: false,
      parallaxFactor: 0.2,
      animationDuration: Duration(milliseconds: 350),
      animationCurve: Curves.decelerate,
    );
  }
}
