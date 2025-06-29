import 'package:flutter/material.dart';

class CarouselStyle {
  final double? viewportFraction;
  final double? spacing;
  final bool? showIndicators;
  final double? parallaxFactor;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const CarouselStyle({
    this.viewportFraction,
    this.spacing,
    this.showIndicators,
    this.parallaxFactor,
    this.animationDuration,
    this.animationCurve,
  });

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