import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/material.dart';

class TVSeriesListNotifier extends ChangeNotifier {
  var _nowPlayingTVSeries = <TVSeries>[];
  List<TVSeries> get nowPlayingTVSeries => _nowPlayingTVSeries;

  RequestState _nowPlayingState = RequestState.empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popularTVSeries = <TVSeries>[];
  List<TVSeries> get popularTVSeries => _popularTVSeries;

  RequestState _popularTVSeriesState = RequestState.empty;
  RequestState get popularTVSeriesState => _popularTVSeriesState;

  var _topRatedTVSeries = <TVSeries>[];
  List<TVSeries> get topRatedTVSeries => _topRatedTVSeries;

  RequestState _topRatedTVSeriesState = RequestState.empty;
  RequestState get topRatedTVSeriesState => _topRatedTVSeriesState;

  String _message = '';
  String get message => _message;

  final GetNowPlayingTVSeries getNowPlayingTVSeries;
  final GetPopularTVSeries getPopularTVSeries;
  final GetTopRatedTVSeries getTopRatedTVSeries;

  TVSeriesListNotifier({
    required this.getNowPlayingTVSeries,
    required this.getPopularTVSeries,
    required this.getTopRatedTVSeries,
  });

  Future<void> fetchNowPlayingTVSeries() async {
    _nowPlayingState = RequestState.loading;
    notifyListeners();

    final result = await getNowPlayingTVSeries.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _nowPlayingState = RequestState.loaded;
        _nowPlayingTVSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTVSeries() async {
    _popularTVSeriesState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTVSeries.execute();
    result.fold(
      (failure) {
        _popularTVSeriesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _popularTVSeriesState = RequestState.loaded;
        _popularTVSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVSeries() async {
    _topRatedTVSeriesState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTVSeries.execute();
    result.fold(
      (failure) {
        _topRatedTVSeriesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _topRatedTVSeriesState = RequestState.loaded;
        _topRatedTVSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
