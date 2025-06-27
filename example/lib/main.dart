import 'package:flutter/material.dart';
import 'package:animated_hero_carousel/animated_hero_carousel.dart';

void main() {
  runApp(const MyApp());
}

class Movie {
  final String title;
  final String imageUrl;
  final String description;

  Movie({required this.title, required this.imageUrl, required this.description});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Movie> movies = [
      Movie(
        title: 'Movie 1',
        imageUrl: 'https://picsum.photos/id/1/200/300',
        description: 'Description for Movie 1',
      ),
      Movie(
        title: 'Movie 2',
        imageUrl: 'https://picsum.photos/id/10/200/300',
        description: 'Description for Movie 2',
      ),
      Movie(
        title: 'Movie 3',
        imageUrl: 'https://picsum.photos/id/100/200/300',
        description: 'Description for Movie 3',
      ),
      Movie(
        title: 'Movie 4',
        imageUrl: 'https://picsum.photos/id/1000/200/300',
        description: 'Description for Movie 4',
      ),
    ];

    return MaterialApp(
      title: 'Animated Hero Carousel Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Animated Hero Carousel'),
        ),
        body: Center(
          child: SizedBox(
            height: 300,
            child: AnimatedHeroCarousel<Movie>(
              items: movies,
              itemBuilder: (context, movie, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: 'movie_${movie.title}_$index', // Updated heroTagBuilder
                    child: Image.network(
                      movie.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              heroTagBuilder: (movie, actualIndex, pageViewIndex) => 'movie_${movie.title}_${actualIndex}_$pageViewIndex', // Updated heroTagBuilder
              detailBuilder: (movie, index) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(movie.title),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'movie_${movie.title}_$index', // Updated heroTagBuilder
                          child: Image.network(movie.imageUrl),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(movie.description),
                        ),
                      ],
                    ),
                  ),
                );
              },
              showIndicators: true,
              spacing: 16.0,
              viewportFraction: 0.7,
            ),
          ),
        ),
      ),
    );
  }
}
