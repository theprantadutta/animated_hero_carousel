import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animated_hero_carousel/src/indicators.dart';

void main() {
  group('CarouselIndicators', () {
    testWidgets('renders dot indicators by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarouselIndicators(
              itemCount: 3,
              currentIndex: 0,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsNWidgets(3));
      final Container container = tester.widget(find.byType(Container).first);
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('renders bar indicators when specified', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarouselIndicators(
              itemCount: 3,
              currentIndex: 0,
              indicatorType: IndicatorType.bar,
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsNWidgets(3));
      final Container container = tester.widget(find.byType(Container).first);
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('renders worm indicators when specified', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarouselIndicators(
              itemCount: 3,
              currentIndex: 0,
              indicatorType: IndicatorType.worm,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(3));
      final AnimatedContainer container = tester.widget(find.byType(AnimatedContainer).first);
      final BoxDecoration decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });
  });
}
