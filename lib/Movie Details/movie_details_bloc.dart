import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Events
abstract class MovieDetailsEvent {}
class FetchMovieDetails extends MovieDetailsEvent {
  final int movieId;
  FetchMovieDetails(this.movieId);
}

// States
abstract class MovieDetailsState {}
class MovieDetailsLoading extends MovieDetailsState {}
class MovieDetailsLoaded extends MovieDetailsState {
  final Map<String, dynamic> movie;
  MovieDetailsLoaded(this.movie);
}
class MovieDetailsError extends MovieDetailsState {}

// Bloc
class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc() : super(MovieDetailsLoading()) {
    on<FetchMovieDetails>((event, emit) async {
      try {
        final response = await http.get(Uri.parse(
            'https://api.themoviedb.org/3/movie/${event.movieId}?api_key=837aa67b269303622a476bbe24283a57'));

        if (response.statusCode == 200) {
          final movie = json.decode(response.body);
          emit(MovieDetailsLoaded(movie));
        } else {
          emit(MovieDetailsError());
        }
      } catch (e) {
        emit(MovieDetailsError());
      }
    });
  }
}