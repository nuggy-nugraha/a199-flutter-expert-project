import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTVSeries])
void main() {
  late MockSearchTVSeries mockSearchTVSeries;

  setUp(() {
    mockSearchTVSeries = MockSearchTVSeries();
  });

  const tTVSeries = TVSeries(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    firstAirDate: '2021-03-19',
    genreIds: [10765, 10759],
    id: 88396,
    name: 'The Falcon and the Winter Soldier',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'The Falcon and the Winter Soldier',
    overview: 'Overview',
    popularity: 78.978,
    posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
    voteAverage: 7.9,
    voteCount: 5765,
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];
  const tQuery = 'falcon';

  group('TVSeriesSearchBloc', () {
    blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
      'emits [Loading, Loaded] when OnTVSeriesQueryChanged succeeds',
      build: () {
        when(
          mockSearchTVSeries.execute(tQuery),
        ).thenAnswer((_) async => Right(tTVSeriesList));
        return TVSeriesSearchBloc(searchTVSeries: mockSearchTVSeries);
      },
      act: (bloc) => bloc.add(const OnTVSeriesQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        TVSeriesSearchLoading(),
        TVSeriesSearchLoaded(tTVSeriesList),
      ],
    );

    blocTest<TVSeriesSearchBloc, TVSeriesSearchState>(
      'emits [Loading, Error] when OnTVSeriesQueryChanged fails',
      build: () {
        when(
          mockSearchTVSeries.execute(tQuery),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return TVSeriesSearchBloc(searchTVSeries: mockSearchTVSeries);
      },
      act: (bloc) => bloc.add(const OnTVSeriesQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        TVSeriesSearchLoading(),
        const TVSeriesSearchError('Server Failure'),
      ],
    );
  });

  group('Event props', () {
    test('OnTVSeriesQueryChanged props contains query', () {
      const event = OnTVSeriesQueryChanged('falcon');
      expect(event.props, ['falcon']);
    });

    test('OnTVSeriesQueryChanged equality', () {
      expect(
        const OnTVSeriesQueryChanged('falcon'),
        equals(const OnTVSeriesQueryChanged('falcon')),
      );
    });
  });
}
