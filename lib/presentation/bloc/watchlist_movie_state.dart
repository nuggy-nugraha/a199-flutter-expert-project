part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieEmpty extends WatchlistMovieState {}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieError extends WatchlistMovieState {
  final String message;
  const WatchlistMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMovieLoaded extends WatchlistMovieState {
  final List<Movie> movies;
  const WatchlistMovieLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}
