part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;
  const MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailLoaded({
    required this.movie,
    required this.recommendations,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
  });

  MovieDetailLoaded copyWith({
    MovieDetail? movie,
    List<Movie>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailLoaded(
      movie: movie ?? this.movie,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object> get props => [
    movie,
    recommendations,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
