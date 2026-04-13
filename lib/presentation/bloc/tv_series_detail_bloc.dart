import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TVSeriesDetailBloc
    extends Bloc<TVSeriesDetailEvent, TVSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVSeriesDetail getTVSeriesDetail;
  final GetTVSeriesRecommendations getTVSeriesRecommendations;
  final GetWatchlistTVSeriesStatus getWatchlistTVSeriesStatus;
  final SaveWatchlistTVSeries saveWatchlistTVSeries;
  final RemoveWatchlistTVSeries removeWatchlistTVSeries;
  final GetSeasonDetail getSeasonDetail;

  TVSeriesDetailBloc({
    required this.getTVSeriesDetail,
    required this.getTVSeriesRecommendations,
    required this.getWatchlistTVSeriesStatus,
    required this.saveWatchlistTVSeries,
    required this.removeWatchlistTVSeries,
    required this.getSeasonDetail,
  }) : super(TVSeriesDetailEmpty()) {
    on<FetchTVSeriesDetail>(_onFetchTVSeriesDetail);
    on<AddTVSeriesToWatchlist>(_onAddTVSeriesToWatchlist);
    on<RemoveTVSeriesFromWatchlist>(_onRemoveTVSeriesFromWatchlist);
    on<LoadTVSeriesWatchlistStatus>(_onLoadTVSeriesWatchlistStatus);
    on<FetchTVSeriesSeasonDetail>(_onFetchTVSeriesSeasonDetail);
  }

  Future<void> _onFetchTVSeriesDetail(
    FetchTVSeriesDetail event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    emit(TVSeriesDetailLoading());
    final detailResult = await getTVSeriesDetail.execute(event.id);
    final recommendationResult = await getTVSeriesRecommendations.execute(
      event.id,
    );
    final watchlistStatus = await getWatchlistTVSeriesStatus.execute(event.id);

    detailResult.fold((failure) => emit(TVSeriesDetailError(failure.message)), (
      tvSeries,
    ) {
      List<TVSeries> recommendations = [];
      recommendationResult.fold(
        (failure) => {},
        (list) => recommendations = list,
      );

      final loadedState = TVSeriesDetailLoaded(
        tvSeries: tvSeries,
        recommendations: recommendations,
        isAddedToWatchlist: watchlistStatus,
        watchlistMessage: '',
        seasonEpisodes: const [],
        selectedSeason: tvSeries.seasons.isNotEmpty
            ? tvSeries.seasons.first.seasonNumber
            : 1,
        episodeState: TVSeriesEpisodeState.empty,
        episodeMessage: '',
      );
      emit(loadedState);

      if (tvSeries.seasons.isNotEmpty) {
        add(
          FetchTVSeriesSeasonDetail(
            tvId: event.id,
            seasonNumber: tvSeries.seasons.first.seasonNumber,
          ),
        );
      }
    });
  }

  Future<void> _onAddTVSeriesToWatchlist(
    AddTVSeriesToWatchlist event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    if (state is! TVSeriesDetailLoaded) return;
    final currentState = state as TVSeriesDetailLoaded;
    final result = await saveWatchlistTVSeries.execute(event.tvSeries);
    String? failureMessage;
    String? successMessage;
    result.fold(
      (failure) => failureMessage = failure.message,
      (message) => successMessage = message,
    );
    if (failureMessage != null) {
      emit(currentState.copyWith(watchlistMessage: failureMessage));
    } else {
      final status = await getWatchlistTVSeriesStatus.execute(
        currentState.tvSeries.id,
      );
      emit(
        currentState.copyWith(
          isAddedToWatchlist: status,
          watchlistMessage: successMessage,
        ),
      );
    }
  }

  Future<void> _onRemoveTVSeriesFromWatchlist(
    RemoveTVSeriesFromWatchlist event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    if (state is! TVSeriesDetailLoaded) return;
    final currentState = state as TVSeriesDetailLoaded;
    final result = await removeWatchlistTVSeries.execute(event.tvSeries);
    String? failureMessage;
    String? successMessage;
    result.fold(
      (failure) => failureMessage = failure.message,
      (message) => successMessage = message,
    );
    if (failureMessage != null) {
      emit(currentState.copyWith(watchlistMessage: failureMessage));
    } else {
      final status = await getWatchlistTVSeriesStatus.execute(
        currentState.tvSeries.id,
      );
      emit(
        currentState.copyWith(
          isAddedToWatchlist: status,
          watchlistMessage: successMessage,
        ),
      );
    }
  }

  Future<void> _onLoadTVSeriesWatchlistStatus(
    LoadTVSeriesWatchlistStatus event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    final result = await getWatchlistTVSeriesStatus.execute(event.id);
    if (state is TVSeriesDetailLoaded) {
      emit(
        (state as TVSeriesDetailLoaded).copyWith(isAddedToWatchlist: result),
      );
    }
  }

  Future<void> _onFetchTVSeriesSeasonDetail(
    FetchTVSeriesSeasonDetail event,
    Emitter<TVSeriesDetailState> emit,
  ) async {
    if (state is TVSeriesDetailLoaded) {
      emit(
        (state as TVSeriesDetailLoaded).copyWith(
          selectedSeason: event.seasonNumber,
          episodeState: TVSeriesEpisodeState.loading,
        ),
      );
      final result = await getSeasonDetail.execute(
        event.tvId,
        event.seasonNumber,
      );
      if (state is TVSeriesDetailLoaded) {
        result.fold(
          (failure) => emit(
            (state as TVSeriesDetailLoaded).copyWith(
              episodeState: TVSeriesEpisodeState.error,
              episodeMessage: failure.message,
            ),
          ),
          (episodes) => emit(
            (state as TVSeriesDetailLoaded).copyWith(
              seasonEpisodes: episodes,
              episodeState: TVSeriesEpisodeState.loaded,
            ),
          ),
        );
      }
    }
  }
}
