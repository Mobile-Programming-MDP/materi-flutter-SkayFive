import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isfavorite = false;

  @override
  void initState() {
    super.initState();
    _getFavoriteStatus;
  }

  Future _getFavoriteStatus() async {
    final pref = await SharedPreferences.getInstance();
    final favoriteSMovies = pref.getStringList('favoriteMovies') ?? [];

    setState(() {
      _isfavorite = favoriteSMovies.contains(widget.movie.id.toString());
    });
  }

  Future<void> _toggleFavorite() async {
    final pref = await SharedPreferences.getInstance();
    final favoriteMovies = pref.getStringList('favoriteMovies') ?? [];

    if (_isfavorite) {
      favoriteMovies.remove(widget.movie.id.toString());
    } else {
      favoriteMovies.add(widget.movie.id.toString());
    }

    await pref.setStringList('favoriteMovies', favoriteMovies);

    setState(() {
      _isfavorite = !_isfavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  IconButton(
                    hoverColor: Colors.transparent,
                    icon: Icon(
                      _isfavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isfavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                  Text(
                    _isfavorite ? 'Added to Favorite' : 'Add to Favorite',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const Text(
                'Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(widget.movie.overview),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.blue),
                  const SizedBox(width: 10),
                  const Text(
                    'Release Date',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.movie.releaseDate),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 10),
                  const Text(
                    'Rating',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Text(widget.movie.voteAverage.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
