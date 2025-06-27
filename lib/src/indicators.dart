import 'package:flutter/material.dart';

class CarouselIndicators extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const CarouselIndicators({
    Key? key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.dotSize = 8.0,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentIndex == index ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}
