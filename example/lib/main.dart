import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/animated_hero_carousel.dart';

// A simple data model for our movie items.
class Movie {
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String description;

  const Movie({
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.description,
  });
}

// Sample movie data using the provided image paths.
const List<Movie> movieData = [
  Movie(
    title: 'Final Destination: Bloodlines',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/6WxhEvFsauuACfv8HyoVX6mZKFj.jpg',
    backdropUrl:
        'https://image.tmdb.org/t/p/original/6WxhEvFsauuACfv8HyoVX6mZKFj.jpg',
    description: 'The sixth installment in the Final Destination franchise.',
  ),
  Movie(
    title: 'Lilo & Stitch',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/7c5VBuCbjZOk7lSfj9sMpmDIaKX.jpg',
    backdropUrl:
        'https://image.tmdb.org/t/p/original/7c5VBuCbjZOk7lSfj9sMpmDIaKX.jpg',
    description:
        'A tale of a young girl\'s close encounter with the galaxy\'s most wanted extraterrestrial.',
  ),
  Movie(
    title: 'The Twisters',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/8OP3h80BzIDgmMNANVaYlQ6H4Oc.jpg',
    backdropUrl:
        'https://image.tmdb.org/t/p/original/8OP3h80BzIDgmMNANVaYlQ6H4Oc.jpg',
    description: 'A current-day chapter of the 1996 blockbuster, Twister.',
  ),
  Movie(
    title: 'Distant',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/czh8HOhsbBUKoKsmRmLQMCLHUev.jpg',
    backdropUrl:
        'https://image.tmdb.org/t/p/original/czh8HOhsbBUKoKsmRmLQMCLHUev.jpg',
    description:
        'An asteroid miner crash-lands on an alien planet and must make his way across the harsh terrain.',
  ),
  Movie(
    title: 'First Shift',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/ajsGI4JYaciPIe3gPgiJ3Vw5Vre.jpg',
    backdropUrl:
        'https://image.tmdb.org/t/p/original/ajsGI4JYaciPIe3gPgiJ3Vw5Vre.jpg',
    description:
        'As a new rookie, one of the cops has to apprehend a gang of violent criminals on his first night shift.',
  ),
  Movie(
    title: 'K-Pop: Demon Hunters',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/jfS5KEfiwsS35ieZvdUdJKkwLlZ.jpg',
    backdropUrl:
        'https://image.tmdb.org/t/p/original/jfS5KEfiwsS35ieZvdUdJKkwLlZ.jpg',
    description:
        'A world-renowned K-Pop girl group secretly moonlights as demon hunters.',
  ),
  Movie(
    title: 'How to Train Your Dragon',
    posterUrl:
        'https://image.tmdb.org/t/p/w500/q5pXRYTycaeW6dEgsCrd4mYPmxM.jpg',
    backdropUrl:
        'https://image.tmdb.org/t/p/original/q5pXRYTycaeW6dEgsCrd4mYPmxM.jpg',
    description:
        'A hapless young Viking who aspires to hunt dragons becomes the unlikely friend of a young dragon himself.',
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Hero Carousel Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.blueAccent,
        indicatorColor: Colors.blueAccent,
      ),
      home: const MovieCarouselExample(),
    );
  }
}

class MovieCarouselExample extends StatelessWidget {
  const MovieCarouselExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Carousels'),
          backgroundColor: const Color(0xFF121212),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Featured'),
              Tab(text: 'Parallax'),
              Tab(text: 'Watchlist'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNetflixCarousel(),
            _buildParallaxCarousel(),
            _buildVerticalListCarousel(),
          ],
        ),
      ),
    );
  }

  /// Tab 1: A Netflix-inspired carousel.
  Widget _buildNetflixCarousel() {
    return Center(
      child: SizedBox(
        height: 380,
        child: AnimatedHeroCarousel(
          items: movieData,
          style: CarouselStyle.netflix(),
          showIndicators: true,
          indicatorType: IndicatorType.worm,
          itemBuilder: (context, movie, index, pageController) =>
              _buildPosterCard(movie),
          detailBuilder: (movie, index) => _buildDetailScreen(movie),
          heroTagBuilder: (movie, actualIndex, pageViewIndex) =>
              'netflix_${movie.title}_$actualIndex',
        ),
      ),
    );
  }

  /// Tab 2: A carousel demonstrating the parallax effect.
  Widget _buildParallaxCarousel() {
    return Center(
      child: SizedBox(
        height: 380,
        child: AnimatedHeroCarousel(
          items: movieData.reversed.toList(),
          showIndicators: true,
          indicatorType: IndicatorType.bar,
          viewportFraction: 0.7,
          itemBuilder: (context, movie, index, pageController) {
            return ParallaxMovieCard(
              movie: movie,
              pageController: pageController,
              pageIndex: index,
            );
          },
          detailBuilder: (movie, index) => _buildDetailScreen(movie),
          heroTagBuilder: (movie, actualIndex, pageViewIndex) =>
              'parallax_${movie.title}_$actualIndex',
        ),
      ),
    );
  }

  /// Tab 3: A redesigned vertical carousel that looks like a watchlist.
  Widget _buildVerticalListCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AnimatedHeroCarousel(
        items: movieData,
        scrollDirection: Axis.vertical,
        showIndicators: false, // Indicators are less common for list views
        loop: false,
        spacing: 20.0,
        itemBuilder: (context, movie, index, pageController) =>
            _buildWatchlistItem(movie),
        detailBuilder: (movie, index) => _buildDetailScreen(movie),
        heroTagBuilder: (movie, actualIndex, pageViewIndex) =>
            'watchlist_${movie.title}_$actualIndex',
      ),
    );
  }

  /// The beautiful, reusable widget for displaying a movie poster.
  Widget _buildPosterCard(Movie movie) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            movie.posterUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error, color: Colors.red));
            },
          ),
        ),
      ),
    );
  }

  /// A new list item design for the vertical carousel.
  Widget _buildWatchlistItem(Movie movie) {
    return Row(
      children: [
        SizedBox(width: 100, child: _buildPosterCard(movie)),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// A reusable widget to build the detail screen.
  Widget _buildDetailScreen(Movie movie) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(movie.backdropUrl, fit: BoxFit.cover),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  _buildPosterCard(movie),
                  const SizedBox(height: 24),
                  Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    movie.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: BackButton(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// A specialized movie card that creates a parallax and 3D effect as you scroll.
class ParallaxMovieCard extends StatefulWidget {
  final Movie movie;
  final PageController pageController;
  final int pageIndex;

  const ParallaxMovieCard({
    Key? key,
    required this.movie,
    required this.pageController,
    required this.pageIndex,
  }) : super(key: key);

  @override
  _ParallaxMovieCardState createState() => _ParallaxMovieCardState();
}

class _ParallaxMovieCardState extends State<ParallaxMovieCard> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_updateOffset);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_updateOffset);
    super.dispose();
  }

  void _updateOffset() {
    if (widget.pageController.hasClients &&
        widget.pageController.position.hasContentDimensions) {
      setState(() {
        _offset = widget.pageController.page! - widget.pageIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1 - (0.2 * _offset.abs()),
      child: Opacity(
        opacity: 1 - (0.4 * _offset.abs()),
        child: _buildPosterCard(widget.movie),
      ),
    );
  }

  /// The beautiful, reusable widget for displaying a movie poster.
  Widget _buildPosterCard(Movie movie) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            movie.posterUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error, color: Colors.red));
            },
          ),
        ),
      ),
    );
  }
}
