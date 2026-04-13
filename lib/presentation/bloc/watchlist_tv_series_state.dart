part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTVSeriesState extends Equatable {
  const WatchlistTVSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTVSeriesEmpty extends WatchlistTVSeriesState {}

class WatchlistTVSeriesLoading extends WatchlistTVSeriesState {}

class WatchlistTVSeriesError extends WatchlistTVSeriesState {
  final String message;
  const WatchlistTVSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTVSeriesLoaded extends WatchlistTVSeriesState {
  final List<TVSeries> tvSeriesList;
  const WatchlistTVSeriesLoaded(this.tvSeriesList);

  @override
  List<Object> get props => [tvSeriesList];
}
