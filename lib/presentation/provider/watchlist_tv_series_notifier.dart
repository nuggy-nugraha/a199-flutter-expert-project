import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter/material.dart';

class WatchlistTVSeriesNotifier extends ChangeNotifier {
  final GetWatchlistTVSeries getWatchlistTVSeries;

  WatchlistTVSeriesNotifier({required this.getWatchlistTVSeries});

  var _watchlistTVSeries = <TVSeries>[];
  List<TVSeries> get watchlistTVSeries => _watchlistTVSeries;

  RequestState _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  Future<void> fetchWatchlistTVSeries() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final result = await getWatchlistTVSeries.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _watchlistState = RequestState.loaded;
        _watchlistTVSeries = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
