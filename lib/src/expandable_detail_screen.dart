import 'package:flutter/material.dart';

class ExpandableDetailScreen extends StatefulWidget {
  final Widget detailWidget;
  final double expandedHeight;
  final double collapsedHeight;
  final Widget Function(BuildContext context)? dragHandleBuilder;

  const ExpandableDetailScreen({
    Key? key,
    required this.detailWidget,
    required this.expandedHeight,
    required this.collapsedHeight,
    this.dragHandleBuilder,
  }) : super(key: key);

  @override
  _ExpandableDetailScreenState createState() => _ExpandableDetailScreenState();
}

class _ExpandableDetailScreenState extends State<ExpandableDetailScreen> {
  late ValueNotifier<double> _currentHeightNotifier;

  @override
  void initState() {
    super.initState();
    _currentHeightNotifier = ValueNotifier<double>(widget.collapsedHeight);
  }

  @override
  void dispose() {
    _currentHeightNotifier.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    _currentHeightNotifier.value -= details.delta.dy;
    if (_currentHeightNotifier.value < widget.collapsedHeight) {
      _currentHeightNotifier.value = widget.collapsedHeight;
    } else if (_currentHeightNotifier.value > widget.expandedHeight) {
      _currentHeightNotifier.value = widget.expandedHeight;
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_currentHeightNotifier.value > (widget.expandedHeight + widget.collapsedHeight) / 2) {
      _currentHeightNotifier.value = widget.expandedHeight;
    } else {
      _currentHeightNotifier.value = widget.collapsedHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background content (e.g., the main carousel item)
          // This will be handled by the HeroTransitionPage
          Center(child: Text('Background Content (Placeholder)')), // Placeholder

          Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder<double>(
              valueListenable: _currentHeightNotifier,
              builder: (context, currentHeight, child) {
                return GestureDetector(
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  onVerticalDragEnd: _onVerticalDragEnd,
                  child: Container(
                    key: const Key('expandable_detail_container'),
                    height: currentHeight,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white, // Or any background color
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (widget.dragHandleBuilder != null)
                          widget.dragHandleBuilder!(context)
                        else
                          Container(
                            key: const Key('defaultDragHandle'),
                            height: 20,
                            width: 40,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        Expanded(child: widget.detailWidget),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
