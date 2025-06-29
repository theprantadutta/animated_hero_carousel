import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animated_hero_carousel/src/expandable_detail_screen.dart';

void main() {
  group('ExpandableDetailScreen', () {
    testWidgets('initial state is collapsed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExpandableDetailScreen(
            detailWidget: const SizedBox(height: 50.0, child: Text('Detail Content')),
            expandedHeight: 500.0,
            collapsedHeight: 100.0,
          ),
        ),
      );
      await tester.pump(); // Ensure the widget is fully built and rendered

      expect(find.text('Detail Content'), findsOneWidget);
      // Verify that the height is initially collapsed
      final RenderBox renderBox = tester.renderObject(find.byKey(const Key('expandable_detail_container')));
      expect(renderBox.size.height, equals(100.0));
    });

    testWidgets('drags to expand and collapses', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExpandableDetailScreen(
            detailWidget: const SizedBox(height: 50.0, child: Text('Detail Content')),
            expandedHeight: 500.0,
            collapsedHeight: 100.0,
          ),
        ),
      );

      // Drag up to expand
      await tester.drag(find.byKey(const Key('expandable_detail_container')), const Offset(0.0, -300.0));
      await tester.pumpAndSettle();

      final RenderBox expandedRenderBox = tester.renderObject(find.byKey(const Key('expandable_detail_container')));
      expect(expandedRenderBox.size.height, equals(500.0));

      // Drag down to collapse
      await tester.drag(find.byKey(const Key('expandable_detail_container')), const Offset(0.0, 300.0));
      await tester.pumpAndSettle();

      final RenderBox collapsedRenderBox = tester.renderObject(find.byKey(const Key('expandable_detail_container')));
      expect(collapsedRenderBox.size.height, equals(100.0));
    });

    testWidgets('drag handle builder is rendered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExpandableDetailScreen(
            detailWidget: const SizedBox(height: 50.0, child: Text('Detail Content')),
            expandedHeight: 500.0,
            collapsedHeight: 100.0,
            dragHandleBuilder: (context) => Container(key: const Key('customDragHandle'), height: 10, width: 10, color: Colors.red),
          ),
        ),
      );

      expect(find.byKey(const Key('customDragHandle')), findsOneWidget);
    });

    testWidgets('default drag handle is rendered when no custom builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ExpandableDetailScreen(
            detailWidget: const SizedBox(height: 50.0, child: Text('Detail Content')),
            expandedHeight: 500.0,
            collapsedHeight: 100.0,
          ),
        ),
      );

      expect(find.byKey(const Key('defaultDragHandle')), findsOneWidget);
    });
  });
}