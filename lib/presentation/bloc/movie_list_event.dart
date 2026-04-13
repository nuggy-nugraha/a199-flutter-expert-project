part of 'movie_list_bloc.dart';

abstract class NowPlayingMoviesEvent extends Equatable {
  const NowPlayingMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends NowPlayingMoviesEvent {}

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMovies extends PopularMoviesEvent {}

abstract class TopRatedMoviesEvent extends Equatable {
  const TopRatedMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedMovies extends TopRatedMoviesEvent {}
