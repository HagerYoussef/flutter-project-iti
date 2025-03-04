// movie_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Events
abstract class MovieEvent {}
class FetchMovies extends MovieEvent {}

// States
abstract class MovieState {}
class MovieLoading extends MovieState {}
class MovieLoaded extends MovieState {
  final List nowPlayingMovies;
  final List popularMovies;
  MovieLoaded(this.nowPlayingMovies, this.popularMovies);
}
class MovieError extends MovieState {}

// Bloc
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading()) {
    on<FetchMovies>((event, emit) async {
      try {
        final nowPlayingResponse = await http.get(Uri.parse(
            'https://api.themoviedb.org/3/movie/now_playing?api_key=837aa67b269303622a476bbe24283a57'));
        final popularResponse = await http.get(Uri.parse(
            'https://api.themoviedb.org/3/movie/popular?api_key=837aa67b269303622a476bbe24283a57'));

        if (nowPlayingResponse.statusCode == 200 && popularResponse.statusCode == 200) {
          final nowPlayingMovies = json.decode(nowPlayingResponse.body)['results'];
          final popularMovies = json.decode(popularResponse.body)['results'];
          emit(MovieLoaded(nowPlayingMovies, popularMovies));
        } else {
          emit(MovieError());
        }
      } catch (e) {
        emit(MovieError());
      }
    });
  }
}
