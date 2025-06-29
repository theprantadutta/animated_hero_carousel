import 'package:flutter_test/flutter_test.dart';
import 'package:animated_hero_carousel/src/carousel_style.dart';
import 'package:flutter/material.dart';

void main() {
  group('CarouselStyle', () {
    test('Netflix style has correct properties', () {
      final style = CarouselStyle.netflix();
      expect(style.viewportFraction, equals(0.9));
      expect(style.spacing, equals(8.0));
      expect(style.showIndicators, isFalse);
      expect(style.parallaxFactor, equals(0.3));
      expect(style.animationDuration, equals(const Duration(milliseconds: 400)));
      expect(style.animationCurve, equals(Curves.easeOut));
    });

    test('Instagram style has correct properties', () {
      final style = CarouselStyle.instagram();
      expect(style.viewportFraction, equals(1.0));
      expect(style.spacing, equals(0.0));
      expect(style.showIndicators, isTrue);
      expect(style.parallaxFactor, equals(0.0));
      expect(style.animationDuration, equals(const Duration(milliseconds: 300)));
      expect(style.animationCurve, equals(Curves.easeInOut));
    });

    test('Spotify style has correct properties', () {
      final style = CarouselStyle.spotify();
      expect(style.viewportFraction, equals(0.85));
      expect(style.spacing, equals(16.0));
      expect(style.showIndicators, isFalse);
      expect(style.parallaxFactor, equals(0.2));
      expect(style.animationDuration, equals(const Duration(milliseconds: 350)));
      expect(style.animationCurve, equals(Curves.decelerate));
    });
  });
}