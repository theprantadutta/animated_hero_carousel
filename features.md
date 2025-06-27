## 🏷️ Package Name: `animated_hero_carousel`

### 🧠 Goal

A **plug-and-play carousel** that supports:

* **Hero animations** from list item → details screen
* Smooth horizontal or vertical swiping
* Gesture support
* Auto snapping & momentum
* Fully customizable item builders

---

## ✨ Use Cases

* Movie browsing apps (hello, FilmMate 👀)
* Product listings → details
* Photo albums / portfolios
* Anything with preview → fullscreen transition

---

## 🧩 Core Widgets

### `AnimatedHeroCarousel`

A widget that renders your carousel and manages hero animations.

```dart
AnimatedHeroCarousel<T>(
  items: List<T>,
  itemBuilder: (context, item, index) => Widget,
  heroTagBuilder: (item, index) => String,
  detailBuilder: (item, index) => Widget,
  scrollDirection: Axis.horizontal,
  showIndicators: true,
  spacing: 16,
  initialIndex: 0,
)
```

---

## 🛠️ Props (With Behaviors)

| Prop                | Type                                               | Description                            |
| ------------------- | -------------------------------------------------- | -------------------------------------- |
| `items`             | `List<T>`                                          | Your data list (required)              |
| `itemBuilder`       | `Widget Function(BuildContext, T item, int index)` | Builds the preview tile                |
| `detailBuilder`     | `Widget Function(T item, int index)`               | What the detail screen looks like      |
| `heroTagBuilder`    | `String Function(T item, int index)`               | Must be unique to match Hero widgets   |
| `scrollDirection`   | `Axis`                                             | Horizontal or vertical carousel        |
| `initialIndex`      | `int`                                              | Where the carousel starts              |
| `spacing`           | `double`                                           | Space between carousel items           |
| `onItemTap`         | `Function(T item)?`                                | Optional callback when item tapped     |
| `showIndicators`    | `bool`                                             | Dot indicators toggle                  |
| `viewportFraction`  | `double`                                           | Similar to `PageView`, default `0.8`   |
| `animationDuration` | `Duration`                                         | Controls how fast Hero animation plays |
| `animationCurve`    | `Curve`                                            | Customize the feel of the animation    |

---

## 🔄 Behavior

* Uses a **`PageView` under the hood** with custom builders
* Each item wraps its image/preview in a `Hero` using the tag from `heroTagBuilder`
* On tap:

  * Triggers navigation to a full-screen detail page using `Navigator.push`
  * That page contains the *same Hero tag* on the matching widget
* When swiping back, it animates smoothly back into position like magic ✨

---

## 🎨 Example Usage

```dart
AnimatedHeroCarousel<Movie>(
  items: myMovies,
  itemBuilder: (ctx, movie, i) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Hero(
      tag: 'movie_${movie.id}',
      child: Image.network(movie.posterUrl),
    ),
  ),
  heroTagBuilder: (movie, i) => 'movie_${movie.id}',
  detailBuilder: (movie, i) => MovieDetailScreen(movie: movie),
)
```

---

## 🔧 Internals (How It Works Under the Hood)

* Uses `PageView.builder` for performant infinite-ish scroll
* Adds `Hero` widgets dynamically using the builder
* Detail screen is pushed with `MaterialPageRoute` (can be customized)
* Optional: include a custom fade/scale animation if user doesn’t want to use Hero
* Optional: Use `ValueNotifier` to track index for dot indicators

---

## 🧪 Bonus Features (Later Releases)

* `loop: true` for infinite carousel
* `autoplay: true` with custom interval
* Support for **drag to expand** (like Apple Maps card)
* Fancy `parallaxFactor` for images
* Prebuilt styles like “Netflix”, “Instagram Stories”, “Spotify Cards”

---

## 💥 Folder Structure (for the package)

```
lib/
├── animated_hero_carousel.dart
├── src/
│   ├── carousel_core.dart
│   ├── carousel_item.dart
│   ├── hero_transition_page.dart
│   └── indicators.dart
```

---

## 📦 Extras

* Include `example/` with movie list app
* Support dark mode out of the box
* Add `hero_carousel_controller` (later) to control scroll from outside

---

## 🔥 Tagline for pub.dev

> "A dead-simple way to create sexy, tappable carousels with built-in Hero transitions and Netflix vibes — no sweat, no boilerplate."