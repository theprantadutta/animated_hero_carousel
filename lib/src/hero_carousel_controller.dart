import 'package:flutter/material.dart';

/// A controller for programmatically managing the `AnimatedHeroCarousel`.
///
/// This controller allows you to animate, jump, or navigate to specific pages
/// in the carousel from outside the widget.
class HeroCarouselController extends ChangeNotifier {
  PageController? _pageController;

  /// Attaches the `PageController` to this controller.
  ///
  /// This is called internally by the `AnimatedHeroCarousel` widget.
  void attach(PageController pageController) {
    _pageController = pageController;
  }

  /// Detaches the `PageController` from this controller.
  ///
  /// This is called internally by the `AnimatedHeroCarousel` widget.
  void detach() {
    _pageController = null;
  }

  /// Animates the carousel to the given page.
  Future<void> animateToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) async {
    if (_pageController?.hasClients == true) {
      await _pageController!
          .animateToPage(page, duration: duration, curve: curve);
    }
  }

  /// Jumps the carousel to the given page without animation.
  void jumpToPage(int page) {
    if (_pageController?.hasClients == true) {
      _pageController!.jumpToPage(page);
    }
  }

  /// Animates the carousel to the next page.
  Future<void> next({required Duration duration, required Curve curve}) async {
    if (_pageController?.hasClients == true) {
      await _pageController!.nextPage(duration: duration, curve: curve);
    }
  }

  /// Animates the carousel to the previous page.
  Future<void> previous(
      {required Duration duration, required Curve curve}) async {
    if (_pageController?.hasClients == true) {
      await _pageController!.previousPage(duration: duration, curve: curve);
    }
  }

  /// The current page displayed in the carousel.
  ///
  /// Returns `0` if the controller is not attached to a carousel.
  int get page {
    if (_pageController?.hasClients == true) {
      return _pageController!.page!.round();
    }
    return 0;
  }
}
