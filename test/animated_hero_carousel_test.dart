import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animated_hero_carousel/animated_hero_carousel.dart';
import 'package:animated_hero_carousel/src/hero_carousel_controller.dart';

void main() {
  group('AnimatedHeroCarousel', () {
    tearDown(() {
      // Ensure any controllers are disposed after each test
      // This is a general cleanup for tests that might create controllers
      // and not explicitly dispose them within the test body.
      // In a real app, controllers should be managed by the widget that creates them.
    });

    testWidgets('navigates to detail screen on tap', (
      WidgetTester tester,
    ) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroCarousel<String>(
              items: ['Item 1', 'Item 2', 'Item 3'],
              itemBuilder: (context, item, index) => Text(item),
              detailBuilder: (item, index) => Text('Detail for $item'),
              heroTagBuilder: (item, actualIndex, pageViewIndex) =>
                  'hero_${item}_${actualIndex}_$pageViewIndex',
            ),
          ),
        ),
      );

      // Verify that the initially visible carousel item is displayed.
      expect(find.text('Item 1'), findsOneWidget);
      expect(
        find.text('Item 2'),
        findsOneWidget,
      ); // Item 2 might be partially visible due to viewportFraction

      // Tap on the first item.
      await tester.tap(find.text('Item 1'));
      await tester
          .pumpAndSettle(); // Wait for the navigation animation to complete

      // Verify that the detail screen is displayed.
      expect(find.text('Detail for Item 1'), findsOneWidget);

      // Verify that the carousel items are no longer visible (as the detail screen is on top).
      expect(find.text('Item 1'), findsNothing);
      expect(find.text('Item 2'), findsNothing);
    });

    testWidgets('onItemTap callback is triggered', (WidgetTester tester) async {
      String? tappedItem;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroCarousel<String>(
              items: ['Item A', 'Item B'],
              itemBuilder: (context, item, index) => Text(item),
              detailBuilder: (item, index) => Text('Detail for $item'),
              heroTagBuilder: (item, actualIndex, pageViewIndex) =>
                  'hero_${item}_${actualIndex}_$pageViewIndex',
              onItemTap: (item) {
                tappedItem = item;
              },
            ),
          ),
        ),
      );

      // Tap on the first item.
      await tester.tap(find.text('Item A'));
      // The callback should be called synchronously on tap.
      expect(tappedItem, 'Item A');

      // Now wait for the navigation animation to complete.
      await tester.pumpAndSettle();

      // Verify that the detail screen is displayed.
      expect(find.text('Detail for Item A'), findsOneWidget);
    });

    testWidgets('loop property enables infinite scrolling', (WidgetTester tester) async {
      final controller = HeroCarouselController();
      const animationDuration = Duration(milliseconds: 300);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroCarousel<String>(
              items: ['Item 1', 'Item 2', 'Item 3'],
              itemBuilder: (context, item, index) => Text(item),
              detailBuilder: (item, index) => Text('Detail for $item'),
              heroTagBuilder: (item, actualIndex, pageViewIndex) => 'hero_${item}_${actualIndex}_$pageViewIndex',
              loop: true,
              controller: controller,
              animationDuration: animationDuration,
              initialIndex: 0,
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);

      // Advance to the next page.
      controller.next(duration: animationDuration, curve: Curves.ease);
      await tester.pump(animationDuration);
      await tester.pumpAndSettle(); // Settle after the animation
      expect(find.text('Item 2'), findsOneWidget);

      // Advance to the next page.
      controller.next(duration: animationDuration, curve: Curves.ease);
      await tester.pump(animationDuration);
      await tester.pumpAndSettle(); // Settle after the animation
      expect(find.text('Item 3'), findsOneWidget);

      // Advance again, which should loop back to the first item.
      controller.next(duration: animationDuration, curve: Curves.ease);
      await tester.pump(animationDuration);
      await tester.pumpAndSettle(); // Settle after the animation
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('autoplay advances carousel', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroCarousel<String>(
              items: ['Item 1', 'Item 2', 'Item 3'],
              itemBuilder: (context, item, index) => Text(item),
              detailBuilder: (item, index) => Text('Detail for $item'),
              heroTagBuilder: (item, actualIndex, pageViewIndex) =>
                  'hero_${item}_${actualIndex}_$pageViewIndex',
              autoplay: true,
              autoplayInterval: const Duration(milliseconds: 500),
              loop: true, // Ensure loop is true for autoplay test
            ),
          ),
        ),
      );

      // Initially, Item 1 should be visible.
      expect(find.text('Item 1'), findsOneWidget);

      // Advance time by more than the autoplay interval.
      await tester.pump(const Duration(milliseconds: 550));
      expect(find.text('Item 2'), findsOneWidget);

      // Advance time again.
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Item 3'), findsOneWidget);

      // Advance time again (should loop back to Item 1).
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('controller can animate to a specific page', (
      WidgetTester tester,
    ) async {
      final HeroCarouselController controller = HeroCarouselController();
      const animationDuration = Duration(milliseconds: 300);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroCarousel<String>(
              items: ['Page 0', 'Page 1', 'Page 2'],
              itemBuilder: (context, item, index) => Text(item),
              detailBuilder: (item, index) => Text('Detail for $item'),
              heroTagBuilder: (item, actualIndex, pageViewIndex) =>
                  'hero_${item}_${actualIndex}_$pageViewIndex',
              controller: controller,
              animationDuration: animationDuration,
              viewportFraction: 1.0, // Ensure only one item is visible
            ),
          ),
        ),
      );

      expect(find.text('Page 0'), findsOneWidget);

      controller.animateToPage(
        1,
        duration: animationDuration,
        curve: Curves.ease,
      );
      await tester.pump(animationDuration);
      await tester.pumpAndSettle();

      expect(find.text('Page 1'), findsOneWidget);
      expect(find.text('Page 0'), findsNothing);
    });

    testWidgets('controller can jump to a specific page', (
      WidgetTester tester,
    ) async {
      final HeroCarouselController controller = HeroCarouselController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroCarousel<String>(
              items: ['Page 0', 'Page 1', 'Page 2'],
              itemBuilder: (context, item, index) => Text(item),
              detailBuilder: (item, index) => Text('Detail for $item'),
              heroTagBuilder: (item, actualIndex, pageViewIndex) =>
                  'hero_${item}_${actualIndex}_$pageViewIndex',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Page 0'), findsOneWidget);

      controller.jumpToPage(2);
      await tester.pumpAndSettle();

      expect(find.text('Page 2'), findsOneWidget);
      expect(find.text('Page 0'), findsNothing);
    });
  });
}
