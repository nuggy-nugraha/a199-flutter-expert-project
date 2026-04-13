import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_series_list_event.dart';
part 'tv_series_list_state.dart';

class NowPlayingTVSeriesBloc
    extends Bloc<NowPlayingTVSeriesEvent, NowPlayingTVSeriesState> {
  final GetNowPlayingTVSeries getNowPlayingTVSeries;

  NowPlayingTVSeriesBloc({required this.getNowPlayingTVSeries})
    : super(NowPlayingTVSeriesEmpty()) {
    on<FetchNowPlayingTVSeries>(_onFetchNowPlayingTVSeries);
  }

  Future<void> _onFetchNowPlayingTVSeries(
    FetchNowPlayingTVSeries event,
    Emitter<NowPlayingTVSeriesState> emit,
  ) async {
    emit(NowPlayingTVSeriesLoading());
    final result = await getNowPlayingTVSeries.execute();
    result.fold(
      (failure) => emit(NowPlayingTVSeriesError(failure.message)),
      (tvSeriesList) => emit(NowPlayingTVSeriesLoaded(tvSeriesList)),
    );
  }
}

class PopularTVSeriesBloc
    extends Bloc<PopularTVSeriesEvent, PopularTVSeriesState> {
  final GetPopularTVSeries getPopularTVSeries;

  PopularTVSeriesBloc({required this.getPopularTVSeries})
    : super(PopularTVSeriesEmpty()) {
    on<FetchPopularTVSeries>(_onFetchPopularTVSeries);
  }

  Future<void> _onFetchPopularTVSeries(
    FetchPopularTVSeries event,
    Emitter<PopularTVSeriesState> emit,
  ) async {
    emit(PopularTVSeriesLoading());
    final result = await getPopularTVSeries.execute();
    result.fold(
      (failure) => emit(PopularTVSeriesError(failure.message)),
      (tvSeriesList) => emit(PopularTVSeriesLoaded(tvSeriesList)),
    );
  }
}

class TopRatedTVSeriesBloc
    extends Bloc<TopRatedTVSeriesEvent, TopRatedTVSeriesState> {
  final GetTopRatedTVSeries getTopRatedTVSeries;

  TopRatedTVSeriesBloc({required this.getTopRatedTVSeries})
    : super(TopRatedTVSeriesEmpty()) {
    on<FetchTopRatedTVSeries>(_onFetchTopRatedTVSeries);
  }

  Future<void> _onFetchTopRatedTVSeries(
    FetchTopRatedTVSeries event,
    Emitter<TopRatedTVSeriesState> emit,
  ) async {
    emit(TopRatedTVSeriesLoading());
    final result = await getTopRatedTVSeries.execute();
    result.fold(
      (failure) => emit(TopRatedTVSeriesError(failure.message)),
      (tvSeriesList) => emit(TopRatedTVSeriesLoaded(tvSeriesList)),
    );
  }
}
