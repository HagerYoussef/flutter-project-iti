import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_bloc.dart';
import 'movie_details.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});
  static const routeName = 'Movie Screen';

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final Map<int, String> genreMap = {
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    80: "Crime",
    99: "Documentary",
    18: "Drama",
    10751: "Family",
    14: "Fantasy",
    36: "History",
    27: "Horror",
    10402: "Music",
    9648: "Mystery",
    10749: "Romance",
    878: "Sci-Fi",
    10770: "TV Movie",
    53: "Thriller",
    10752: "War",
    37: "Western",
  };
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMovies());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffF9F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F9FA),
        elevation: 0,
        title: Center(
          child: Text("FilmKu",
              style: GoogleFonts.merriweather(
                  fontWeight: FontWeight.w900, fontSize: 20)),
        ),
        leading: const Icon(Icons.menu, color: Colors.black54),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
            child: const Icon(Icons.notifications_sharp,
                size: 25, color: Colors.black54),
          )
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Column(
                children: [
                  _buildSectionHeader("Now Showing", () {}),
                  SizedBox(
                    height: screenHeight * 0.35,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.nowPlayingMovies.length,
                      itemBuilder: (context, index) =>
                          _buildMovieCard(state.nowPlayingMovies[index]),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildSectionHeader("Popular", () {}),
                  SizedBox(height: screenHeight * 0.01),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.popularMovies.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) =>
                          _buildMovieListItem(state.popularMovies[index]),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Failed to load movies"));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: const Color(0xffF9F9FA),
        selectedItemColor: const Color(0xff88A4E9),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.merriweather(
                fontWeight: FontWeight.w900, fontSize: 16)),
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.black38, width: 1.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            minimumSize: const Size(90, 25),
          ),
          child: Text("See more",
              style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  color: Colors.black38)),
        )
      ],
    );
  }

  Widget _buildMovieCard(movie) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetails(movieId: movie['id']),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                height: 212,
                width: 143,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 140,
              child: Text(
                movie['title'],
                style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xffFFC319), size: 18),
                const SizedBox(width: 5),
                Text('${movie['vote_average']}/10 IMDb',
                    style: GoogleFonts.mulish(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieListItem(movie) {
    List<String> genres = (movie['genre_ids'] as List)
        .map((id) => genreMap[id] ?? "Unknown")
        .toList();
    genres = genres.take(3).toList();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetails(movieId: movie['id']),
          ),
        );
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              height: 138,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  movie['title'],
                  style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xffFFC319), size: 18),
                  const SizedBox(width: 5),
                  Text('${movie['vote_average']}/10 IMDb',
                      style: GoogleFonts.mulish(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.black)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(genres.length.clamp(0, 3), (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffDBE3FF),
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Text(
                        genres[index],
                        style: GoogleFonts.mulish(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: const Color(0xff88A4E8)),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.access_time,color: Colors.black,size: 16,),
                  const SizedBox(width: 3),
                  Text('1h 47m', style: GoogleFonts.mulish(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black),)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
