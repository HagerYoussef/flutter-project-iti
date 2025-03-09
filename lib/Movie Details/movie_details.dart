import 'package:final_project/movie_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieDetails extends StatelessWidget {
  final int movieId;

  const MovieDetails({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9FA),
      body: BlocProvider(
        create: (context) => MovieDetailsBloc()..add(FetchMovieDetails(movieId)),
        child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsError) {
              return const Center(child: Text('Error loading movie details'));
            } else if (state is MovieDetailsLoaded) {
              final movie = state.movie;
              return SafeArea(
                child: SizedBox(
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['backdrop_path']}',
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 240,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                          decoration: const BoxDecoration(
                            color: Color(0xffF9F9FA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          height: 550,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      movie['title'],
                                      style: GoogleFonts.mulish(fontWeight: FontWeight.w900, fontSize: 20),
                                      maxLines: 2,
                                    ),
                                  ),
                                  const Icon(Icons.bookmark_outline_outlined, color: Color(0xffFFC319)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Color(0xffFFC319), size: 18),
                                  const SizedBox(width: 5),
                                  Text('${movie['vote_average']}/10 IMDb',
                                      style: GoogleFonts.mulish(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black)),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: List.generate(movie['genres'].length, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Container(
                                      decoration: BoxDecoration(color: const Color(0xffDBE3FF), borderRadius: BorderRadius.circular(30)),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                      child: Text(
                                        movie['genres'][index]['name'],
                                        style: GoogleFonts.mulish(fontWeight: FontWeight.w700, fontSize: 11, color: const Color(0xff88A4E8)),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Length', style: GoogleFonts.mulish(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff9C9C9C))),
                                      Text('${movie['runtime']} min',
                                          style: GoogleFonts.mulish(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Language', style: GoogleFonts.mulish(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff9C9C9C))),
                                      Text(movie['original_language'].toUpperCase(),
                                          style: GoogleFonts.mulish(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Rating', style: GoogleFonts.mulish(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff9C9C9C))),
                                      Text(movie['adult'] ? '18+' : 'PG-13',
                                          style: GoogleFonts.mulish(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text('Description', style: GoogleFonts.merriweather(fontWeight: FontWeight.w900, fontSize: 20)),
                              const SizedBox(height: 10),
                              Text(movie['overview'], style: GoogleFonts.mulish(fontWeight: FontWeight.w400, fontSize: 16)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            return const Center(child: Text('Unexpected state'));
          },
        ),
      ),
    );
  }
}
