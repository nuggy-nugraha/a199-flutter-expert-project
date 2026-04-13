part of 'tv_series_detail_bloc.dart';

enum TVSeriesEpisodeState { empty, loading, loaded, error }

abstract class TVSeriesDetailState extends Equatable {
  const TVSeriesDetailState();

  @override
  List<Object> get props => [];
}

class TVSeriesDetailEmpty extends TVSeriesDetailState {}

class TVSeriesDetailLoading extends TVSeriesDetailState {}

class TVSeriesDetailError extends TVSeriesDetailState {
  final String message;
  const TVSeriesDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TVSeriesDetailLoaded extends TVSeriesDetailState {
  final TVSeriesDetail tvSeries;
  final List<TVSeries> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final List<Episode> seasonEpisodes;
  final int selectedSeason;
  final TVSeriesEpisodeState episodeState;
  final String episodeMessage;

  const TVSeriesDetailLoaded({
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
    required this.seasonEpisodes,
    required this.selectedSeason,
    required this.episodeState,
    required this.episodeMessage,
  });

  TVSeriesDetailLoaded copyWith({
    TVSeriesDetail? tvSeries,
    List<TVSeries>? recommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    List<Episode>? seasonEpisodes,
    int? selectedSeason,
    TVSeriesEpisodeState? episodeState,
    String? episodeMessage,
  }) {
    return TVSeriesDetailLoaded(
      tvSeries: tvSeries ?? this.tvSeries,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      seasonEpisodes: seasonEpisodes ?? this.seasonEpisodes,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      episodeState: episodeState ?? this.episodeState,
      episodeMessage: episodeMessage ?? this.episodeMessage,
    );
  }

  @override
  List<Object> get props => [
    tvSeries,
    recommendations,
    isAddedToWatchlist,
    watchlistMessage,
    seasonEpisodes,
    selectedSeason,
    episodeState,
    episodeMessage,
  ];
}
