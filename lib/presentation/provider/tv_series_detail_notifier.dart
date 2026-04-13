import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter/material.dart';

class TVSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVSeriesDetail getTVSeriesDetail;
  final GetTVSeriesRecommendations getTVSeriesRecommendations;
  final GetWatchlistTVSeriesStatus getWatchlistTVSeriesStatus;
  final SaveWatchlistTVSeries saveWatchlistTVSeries;
  final RemoveWatchlistTVSeries removeWatchlistTVSeries;
  final GetSeasonDetail getSeasonDetail;

  TVSeriesDetailNotifier({
    required this.getTVSeriesDetail,
    required this.getTVSeriesRecommendations,
    required this.getWatchlistTVSeriesStatus,
    required this.saveWatchlistTVSeries,
    required this.removeWatchlistTVSeries,
    required this.getSeasonDetail,
  });

  late TVSeriesDetail _tvSeries;
  TVSeriesDetail get tvSeries => _tvSeries;

  RequestState _tvSeriesState = RequestState.empty;
  RequestState get tvSeriesState => _tvSeriesState;

  List<TVSeries> _tvSeriesRecommendations = [];
  List<TVSeries> get tvSeriesRecommendations => _tvSeriesRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  List<Episode> _seasonEpisodes = [];
  List<Episode> get seasonEpisodes => _seasonEpisodes;

  RequestState _episodeState = RequestState.empty;
  RequestState get episodeState => _episodeState;

  int _selectedSeason = 1;
  int get selectedSeason => _selectedSeason;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> fetchTVSeriesDetail(int id) async {
    _tvSeriesState = RequestState.loading;
    notifyListeners();

    final detailResult = await getTVSeriesDetail.execute(id);
    final recommendationResult = await getTVSeriesRecommendations.execute(id);

    detailResult.fold(
      (failure) {
        _tvSeriesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeries) {
        _recommendationState = RequestState.loading;
        _tvSeries = tvSeries;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (tvSeriesList) {
            _recommendationState = RequestState.loaded;
            _tvSeriesRecommendations = tvSeriesList;
          },
        );
        _tvSeriesState = RequestState.loaded;
        notifyListeners();

        // Fetch first season's episodes if seasons available
        if (tvSeries.seasons.isNotEmpty) {
          final firstSeason = tvSeries.seasons.first.seasonNumber;
          fetchSeasonEpisodes(id, firstSeason);
        }
      },
    );
  }

  Future<void> fetchSeasonEpisodes(int tvId, int seasonNumber) async {
    _selectedSeason = seasonNumber;
    _episodeState = RequestState.loading;
    notifyListeners();

    final result = await getSeasonDetail.execute(tvId, seasonNumber);
    result.fold(
      (failure) {
        _episodeState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (episodes) {
        _episodeState = RequestState.loaded;
        _seasonEpisodes = episodes;
        notifyListeners();
      },
    );
  }

  Future<void> addWatchlist(TVSeriesDetail tvSeries) async {
    final result = await saveWatchlistTVSeries.execute(tvSeries);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> removeFromWatchlist(TVSeriesDetail tvSeries) async {
    final result = await removeWatchlistTVSeries.execute(tvSeries);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchlistTVSeriesStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
