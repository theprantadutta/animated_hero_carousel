import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animated_hero_carousel/animated_hero_carousel.dart';

void main() {
  group('AnimatedHeroCarousel', () {
    testWidgets('navigates to detail screen on tap', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroCarousel<String>(
              items: ['Item 1', 'Item 2', 'Item 3'],
              itemBuilder: (context, item, index) => Text(item),
              detailBuilder: (item, index) => Text('Detail for $item'),
              heroTagBuilder: (item, index) => 'hero_$index',
            ),
          ),
        ),
      );

      // Verify that the initially visible carousel item is displayed.
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget); // Item 2 might be partially visible due to viewportFraction

      // Tap on the first item.
      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle(); // Wait for the navigation animation to complete

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
              heroTagBuilder: (item, index) => 'hero_$index',
              onItemTap: (item) {
                tappedItem = item;
              },
            ),
          ),
        ),
      );

      // Tap on the first item.
      await tester.tap(find.text('Item A'));
      await tester.pumpAndSettle();

      // Verify that the onItemTap callback was triggered with the correct item.
      expect(tappedItem, 'Item A');
    });

    testWidgets('loop property enables infinite scrolling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroCarousel<String>(
              items: ['Item 1', 'Item 2', 'Item 3'],
              itemBuilder: (context, item, index) => Text(item),
              detailBuilder: (item, index) => Text('Detail for $item'),
              heroTagBuilder: (item, index) => 'hero_$index',
              loop: true,
              initialIndex: 0,
            ),
          ),
        ),
      );

      // Verify that the first item is visible.
      expect(find.text('Item 1'), findsOneWidget);

      // Swipe to the next item (which should be Item 2).
      await tester.drag(find.text('Item 1'), const Offset(-300.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.text('Item 2'), findsOneWidget);

      // Swipe past the last item (which should loop back to Item 1).
      await tester.drag(find.text('Item 2'), const Offset(-300.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.text('Item 3'), findsOneWidget);

      await tester.drag(find.text('Item 3'), const Offset(-300.0, 0.0));
      await tester.pumpAndSettle();
      expect(find.text('Item 1'), findsOneWidget);
    });
  });
}