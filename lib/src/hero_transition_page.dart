import 'package:flutter/material.dart';

class HeroTransitionPage<T> extends PageRouteBuilder {
  final String heroTag;
  final Widget detailWidget;
  final Duration transitionDuration;
  final Curve animationCurve;

  HeroTransitionPage({
    required this.heroTag,
    required this.detailWidget,
    required this.transitionDuration,
    required this.animationCurve,
  }) : super(
          transitionDuration: transitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: Hero(
                tag: heroTag,
                child: detailWidget,
              ),
            );
          },
        );
}
