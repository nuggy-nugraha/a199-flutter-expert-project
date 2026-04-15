import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVSeries, GetPopularTVSeries, GetTopRatedTVSeries])
void main() {
  late MockGetNowPlayingTVSeries mockGetNowPlayingTVSeries;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;

  setUp(() {
    mockGetNowPlayingTVSeries = MockGetNowPlayingTVSeries();
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
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

  group('NowPlayingTVSeriesBloc', () {
    blocTest<NowPlayingTVSeriesBloc, NowPlayingTVSeriesState>(
      'emits [Loading, Loaded] when FetchNowPlayingTVSeries succeeds',
      build: () {
        when(
          mockGetNowPlayingTVSeries.execute(),
        ).thenAnswer((_) async => Right(tTVSeriesList));
        return NowPlayingTVSeriesBloc(
          getNowPlayingTVSeries: mockGetNowPlayingTVSeries,
        );
      },
      act: (bloc) => bloc.add(FetchNowPlayingTVSeries()),
      expect: () => [
        NowPlayingTVSeriesLoading(),
        NowPlayingTVSeriesLoaded(tTVSeriesList),
      ],
    );

    blocTest<NowPlayingTVSeriesBloc, NowPlayingTVSeriesState>(
      'emits [Loading, Error] when FetchNowPlayingTVSeries fails',
      build: () {
        when(
          mockGetNowPlayingTVSeries.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return NowPlayingTVSeriesBloc(
          getNowPlayingTVSeries: mockGetNowPlayingTVSeries,
        );
      },
      act: (bloc) => bloc.add(FetchNowPlayingTVSeries()),
      expect: () => [
        NowPlayingTVSeriesLoading(),
        const NowPlayingTVSeriesError('Server Failure'),
      ],
    );
  });

  group('PopularTVSeriesBloc', () {
    blocTest<PopularTVSeriesBloc, PopularTVSeriesState>(
      'emits [Loading, Loaded] when FetchPopularTVSeries succeeds',
      build: () {
        when(
          mockGetPopularTVSeries.execute(),
        ).thenAnswer((_) async => Right(tTVSeriesList));
        return PopularTVSeriesBloc(getPopularTVSeries: mockGetPopularTVSeries);
      },
      act: (bloc) => bloc.add(FetchPopularTVSeries()),
      expect: () => [
        PopularTVSeriesLoading(),
        PopularTVSeriesLoaded(tTVSeriesList),
      ],
    );

    blocTest<PopularTVSeriesBloc, PopularTVSeriesState>(
      'emits [Loading, Error] when FetchPopularTVSeries fails',
      build: () {
        when(
          mockGetPopularTVSeries.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return PopularTVSeriesBloc(getPopularTVSeries: mockGetPopularTVSeries);
      },
      act: (bloc) => bloc.add(FetchPopularTVSeries()),
      expect: () => [
        PopularTVSeriesLoading(),
        const PopularTVSeriesError('Server Failure'),
      ],
    );
  });

  group('TopRatedTVSeriesBloc', () {
    blocTest<TopRatedTVSeriesBloc, TopRatedTVSeriesState>(
      'emits [Loading, Loaded] when FetchTopRatedTVSeries succeeds',
      build: () {
        when(
          mockGetTopRatedTVSeries.execute(),
        ).thenAnswer((_) async => Right(tTVSeriesList));
        return TopRatedTVSeriesBloc(
          getTopRatedTVSeries: mockGetTopRatedTVSeries,
        );
      },
      act: (bloc) => bloc.add(FetchTopRatedTVSeries()),
      expect: () => [
        TopRatedTVSeriesLoading(),
        TopRatedTVSeriesLoaded(tTVSeriesList),
      ],
    );

    blocTest<TopRatedTVSeriesBloc, TopRatedTVSeriesState>(
      'emits [Loading, Error] when FetchTopRatedTVSeries fails',
      build: () {
        when(
          mockGetTopRatedTVSeries.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return TopRatedTVSeriesBloc(
          getTopRatedTVSeries: mockGetTopRatedTVSeries,
        );
      },
      act: (bloc) => bloc.add(FetchTopRatedTVSeries()),
      expect: () => [
        TopRatedTVSeriesLoading(),
        const TopRatedTVSeriesError('Server Failure'),
      ],
    );
  });
}
