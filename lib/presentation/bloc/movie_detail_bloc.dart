import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddMovieToWatchlist>(_onAddMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveMovieFromWatchlist);
    on<LoadMovieWatchlistStatus>(_onLoadMovieWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(
      event.id,
    );
    final watchlistStatus = await getWatchListStatus.execute(event.id);

    detailResult.fold((failure) => emit(MovieDetailError(failure.message)), (
      movie,
    ) {
      List<Movie> recommendations = [];
      recommendationResult.fold(
        (failure) => {},
        (movies) => recommendations = movies,
      );
      emit(
        MovieDetailLoaded(
          movie: movie,
          recommendations: recommendations,
          isAddedToWatchlist: watchlistStatus,
          watchlistMessage: '',
        ),
      );
    });
  }

  Future<void> _onAddMovieToWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state is! MovieDetailLoaded) return;
    final currentState = state as MovieDetailLoaded;
    final result = await saveWatchlist.execute(event.movie);
    String? failureMessage;
    String? successMessage;
    result.fold(
      (failure) => failureMessage = failure.message,
      (message) => successMessage = message,
    );
    if (failureMessage != null) {
      emit(currentState.copyWith(watchlistMessage: failureMessage));
    } else {
      final status = await getWatchListStatus.execute(currentState.movie.id);
      emit(
        currentState.copyWith(
          isAddedToWatchlist: status,
          watchlistMessage: successMessage,
        ),
      );
    }
  }

  Future<void> _onRemoveMovieFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    if (state is! MovieDetailLoaded) return;
    final currentState = state as MovieDetailLoaded;
    final result = await removeWatchlist.execute(event.movie);
    String? failureMessage;
    String? successMessage;
    result.fold(
      (failure) => failureMessage = failure.message,
      (message) => successMessage = message,
    );
    if (failureMessage != null) {
      emit(currentState.copyWith(watchlistMessage: failureMessage));
    } else {
      final status = await getWatchListStatus.execute(currentState.movie.id);
      emit(
        currentState.copyWith(
          isAddedToWatchlist: status,
          watchlistMessage: successMessage,
        ),
      );
    }
  }

  Future<void> _onLoadMovieWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    if (state is MovieDetailLoaded) {
      emit((state as MovieDetailLoaded).copyWith(isAddedToWatchlist: result));
    }
  }
}
