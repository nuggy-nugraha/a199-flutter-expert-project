import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'tv_series_search_event.dart';
part 'tv_series_search_state.dart';

class TVSeriesSearchBloc
    extends Bloc<TVSeriesSearchEvent, TVSeriesSearchState> {
  final SearchTVSeries searchTVSeries;

  TVSeriesSearchBloc({required this.searchTVSeries})
    : super(TVSeriesSearchEmpty()) {
    on<OnTVSeriesQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  Future<void> _onQueryChanged(
    OnTVSeriesQueryChanged event,
    Emitter<TVSeriesSearchState> emit,
  ) async {
    final query = event.query;
    emit(TVSeriesSearchLoading());
    final result = await searchTVSeries.execute(query);
    result.fold(
      (failure) => emit(TVSeriesSearchError(failure.message)),
      (data) => emit(TVSeriesSearchLoaded(data)),
    );
  }
}
