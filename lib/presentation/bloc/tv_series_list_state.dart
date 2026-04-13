part of 'tv_series_list_bloc.dart';

abstract class NowPlayingTVSeriesState extends Equatable {
  const NowPlayingTVSeriesState();

  @override
  List<Object> get props => [];
}

class NowPlayingTVSeriesEmpty extends NowPlayingTVSeriesState {}

class NowPlayingTVSeriesLoading extends NowPlayingTVSeriesState {}

class NowPlayingTVSeriesError extends NowPlayingTVSeriesState {
  final String message;
  const NowPlayingTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class NowPlayingTVSeriesLoaded extends NowPlayingTVSeriesState {
  final List<TVSeries> tvSeriesList;
  const NowPlayingTVSeriesLoaded(this.tvSeriesList);

  @override
  List<Object> get props => [tvSeriesList];
}

abstract class PopularTVSeriesState extends Equatable {
  const PopularTVSeriesState();

  @override
  List<Object> get props => [];
}

class PopularTVSeriesEmpty extends PopularTVSeriesState {}

class PopularTVSeriesLoading extends PopularTVSeriesState {}

class PopularTVSeriesError extends PopularTVSeriesState {
  final String message;
  const PopularTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularTVSeriesLoaded extends PopularTVSeriesState {
  final List<TVSeries> tvSeriesList;
  const PopularTVSeriesLoaded(this.tvSeriesList);

  @override
  List<Object> get props => [tvSeriesList];
}

abstract class TopRatedTVSeriesState extends Equatable {
  const TopRatedTVSeriesState();

  @override
  List<Object> get props => [];
}

class TopRatedTVSeriesEmpty extends TopRatedTVSeriesState {}

class TopRatedTVSeriesLoading extends TopRatedTVSeriesState {}

class TopRatedTVSeriesError extends TopRatedTVSeriesState {
  final String message;
  const TopRatedTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedTVSeriesLoaded extends TopRatedTVSeriesState {
  final List<TVSeries> tvSeriesList;
  const TopRatedTVSeriesLoaded(this.tvSeriesList);

  @override
  List<Object> get props => [tvSeriesList];
}
