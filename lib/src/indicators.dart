import 'package:flutter/material.dart';

/// Defines the types of indicators available for the carousel.
enum IndicatorType {
  /// A circular dot indicator.
  dot,

  /// A rectangular bar indicator.
  bar,

  /// A "worm" style indicator that animates its width.
  worm,
}

/// A widget that displays indicators for a `PageView`.
///
/// This widget can display different types of indicators, such as dots, bars,
/// or a "worm" style indicator.
class CarouselIndicators extends StatelessWidget {
  /// The total number of items in the carousel.
  final int itemCount;

  /// The index of the currently active item.
  final int currentIndex;

  /// The color of the active indicator.
  final Color activeColor;

  /// The color of the inactive indicators.
  final Color inactiveColor;

  /// The size of the indicator.
  final double dotSize;

  /// The spacing between indicators.
  final double spacing;

  /// A callback function that is invoked when an indicator is tapped.
  final Function(int)? onIndicatorTap;

  /// The type of indicator to display.
  final IndicatorType indicatorType;

  const CarouselIndicators({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.dotSize = 8.0,
    this.spacing = 8.0,
    this.onIndicatorTap,
    this.indicatorType = IndicatorType.dot,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return GestureDetector(
          onTap: () => onIndicatorTap?.call(index),
          child: _buildIndicator(index),
        );
      }),
    );
  }

  Widget _buildIndicator(int index) {
    switch (indicatorType) {
      case IndicatorType.bar:
        return _buildBarIndicator(index);
      case IndicatorType.worm:
        return _buildWormIndicator(index);
      case IndicatorType.dot:
        return _buildDotIndicator(index);
    }
  }

  Widget _buildDotIndicator(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == index ? activeColor : inactiveColor,
      ),
    );
  }

  Widget _buildBarIndicator(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      width: dotSize * 2.5,
      height: dotSize / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dotSize / 4),
        color: currentIndex == index ? activeColor : inactiveColor,
      ),
    );
  }

  Widget _buildWormIndicator(int index) {
    final bool isActive = currentIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: spacing / 2),
      width: isActive ? dotSize * 2.5 : dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(dotSize),
        color: isActive ? activeColor : inactiveColor,
      ),
    );
  }
}
