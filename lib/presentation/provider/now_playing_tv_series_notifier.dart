import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:flutter/material.dart';

class NowPlayingTVSeriesNotifier extends ChangeNotifier {
  final GetNowPlayingTVSeries getNowPlayingTVSeries;

  NowPlayingTVSeriesNotifier({required this.getNowPlayingTVSeries});

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TVSeries> _tvSeries = [];
  List<TVSeries> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  Future<void> fetchNowPlayingTVSeries() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getNowPlayingTVSeries.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvSeriesData) {
        _tvSeries = tvSeriesData;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
