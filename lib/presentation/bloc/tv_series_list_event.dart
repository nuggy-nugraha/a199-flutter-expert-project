part of 'tv_series_list_bloc.dart';

abstract class NowPlayingTVSeriesEvent extends Equatable {
  const NowPlayingTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTVSeries extends NowPlayingTVSeriesEvent {}

abstract class PopularTVSeriesEvent extends Equatable {
  const PopularTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTVSeries extends PopularTVSeriesEvent {}

abstract class TopRatedTVSeriesEvent extends Equatable {
  const TopRatedTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTVSeries extends TopRatedTVSeriesEvent {}
