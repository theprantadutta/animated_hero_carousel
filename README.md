<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A customizable and animated hero carousel for Flutter, with pre-built styles and support for different indicator types.

## Features

*   **Hero Animations:** Smooth hero animations between the carousel and detail screens.
*   **Customizable Styles:** Easily customize the carousel with pre-built styles or create your own.
*   **Multiple Indicator Types:** Choose from `dot`, `bar`, and `worm` indicators.
*   **Autoplay and Looping:** Enable autoplay and infinite looping for a dynamic experience.
*   **Drag to Expand:** Support for drag-to-expand detail screens, similar to Apple Maps.
*   **Parallax Effect:** Add a parallax effect to your carousel items for a sense of depth.

## Getting started

To use this package, add `animated_hero_carousel` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  animated_hero_carousel: ^1.0.0
```

## Usage

```dart
import 'package:animated_hero_carousel/animated_hero_carousel.dart';

// ...

AnimatedHeroCarousel(
  items: <String>['Item 1', 'Item 2', 'Item 3'],
  itemBuilder: (BuildContext context, String item, int index) {
    return // Your item widget;
  },
  detailBuilder: (String item, int index) {
    return // Your detail widget;
  },
  heroTagBuilder: (String item, int actualIndex, int pageViewIndex) {
    return 'hero_tag_${item}_${actualIndex}_$pageViewIndex';
  },
  indicatorType: IndicatorType.worm,
  style: CarouselStyle.netflix(),
);
```

## Additional information

For more information, check out the example in the `/example` folder. To contribute to the package, please file an issue or submit a pull request on GitHub.
