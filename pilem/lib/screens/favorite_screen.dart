import 'package:flutter/material.dart';
import 'package:pilem/screens/detail_screen.dart';
import 'package:pilem/services/api_services.dart';
import 'package:pilem/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefs;

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  ApiService apiService = ApiService();
  List<Movie> favoriteMovieList = [];

  Future<void> fetchFavoriteMovieList() async {
    final res = await apiService.getAllMovies();
    final pref = await prefs.SharedPreferences.getInstance();
    final listFavoriteMovie = pref.getStringList('favoriteMovies') ?? [];

    setState(() {
      favoriteMovieList = res
          .where(
            (movieData) =>
                listFavoriteMovie.contains(movieData['id'].toString()),
          )
          .map((movieData) => Movie.fromJson(movieData))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFavoriteMovieList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: 0.6,
      ),
      itemCount: favoriteMovieList.length,
      itemBuilder: (context, index) {
        final movie = favoriteMovieList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailScreen(movie: movie)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // child: Card(
            // clipBehavior: Clip.antiAlias,
            // color: Colors.white,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            // elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    height: 200,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                // Judul Movie
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    movie.title,
                    // maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // ),
          ),
        );
      },
    );
  }
}
