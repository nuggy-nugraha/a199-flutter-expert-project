import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVSeriesRepositoryImpl repository;
  late MockTVSeriesRemoteDataSource mockRemoteDataSource;
  late MockTVSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVSeriesRemoteDataSource();
    mockLocalDataSource = MockTVSeriesLocalDataSource();
    repository = TVSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tTVSeriesModel = TVSeriesModel(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    firstAirDate: '2021-03-19',
    genreIds: [10765, 10759],
    id: 88396,
    name: 'The Falcon and the Winter Soldier',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'The Falcon and the Winter Soldier',
    overview:
        'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
    popularity: 78.978,
    posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
    voteAverage: 7.9,
    voteCount: 5765,
  );

  const tTVSeries = TVSeries(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    firstAirDate: '2021-03-19',
    genreIds: [10765, 10759],
    id: 88396,
    name: 'The Falcon and the Winter Soldier',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'The Falcon and the Winter Soldier',
    overview:
        'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
    popularity: 78.978,
    posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
    voteAverage: 7.9,
    voteCount: 5765,
  );

  final tTVSeriesModelList = <TVSeriesModel>[tTVSeriesModel];
  const tTVSeriesList = <TVSeries>[tTVSeries];

  group('Now Playing TV Series', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        when(
          mockRemoteDataSource.getNowPlayingTVSeries(),
        ).thenAnswer((_) async => tTVSeriesModelList);
        final result = await repository.getNowPlayingTVSeries();
        verify(mockRemoteDataSource.getNowPlayingTVSeries());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getNowPlayingTVSeries(),
        ).thenThrow(ServerException());
        final result = await repository.getNowPlayingTVSeries();
        verify(mockRemoteDataSource.getNowPlayingTVSeries());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        when(
          mockRemoteDataSource.getNowPlayingTVSeries(),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getNowPlayingTVSeries();
        verify(mockRemoteDataSource.getNowPlayingTVSeries());
        expect(
          result,
          equals(
            const Left(ConnectionFailure('Failed to connect to the network')),
          ),
        );
      },
    );
  });

  group('Popular TV Series', () {
    test(
      'should return tv series list when call to remote data source is successful',
      () async {
        when(
          mockRemoteDataSource.getPopularTVSeries(),
        ).thenAnswer((_) async => tTVSeriesModelList);
        final result = await repository.getPopularTVSeries();
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getPopularTVSeries(),
        ).thenThrow(ServerException());
        final result = await repository.getPopularTVSeries();
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.getPopularTVSeries(),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getPopularTVSeries();
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Top Rated TV Series', () {
    test(
      'should return tv series list when call to remote data source is successful',
      () async {
        when(
          mockRemoteDataSource.getTopRatedTVSeries(),
        ).thenAnswer((_) async => tTVSeriesModelList);
        final result = await repository.getTopRatedTVSeries();
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getTopRatedTVSeries(),
        ).thenThrow(ServerException());
        final result = await repository.getTopRatedTVSeries();
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.getTopRatedTVSeries(),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getTopRatedTVSeries();
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Get TV Series Detail', () {
    const tId = 88396;
    const tTVSeriesDetailModel = TVSeriesDetailResponse(
      backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
      firstAirDate: '2021-03-19',
      genres: [],
      id: 88396,
      name: 'The Falcon and the Winter Soldier',
      numberOfEpisodes: 6,
      numberOfSeasons: 1,
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'The Falcon and the Winter Soldier',
      overview: 'Following the events of Avengers: Endgame.',
      popularity: 78.978,
      posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
      seasons: [],
      status: 'Ended',
      tagline: 'The legacy of that shield is complicated.',
      type: 'Miniseries',
      voteAverage: 7.9,
      voteCount: 5765,
    );

    test(
      'should return TV Series data when the call to remote data source is successful',
      () async {
        when(
          mockRemoteDataSource.getTVSeriesDetail(tId),
        ).thenAnswer((_) async => tTVSeriesDetailModel);
        final result = await repository.getTVSeriesDetail(tId);
        verify(mockRemoteDataSource.getTVSeriesDetail(tId));
        expect(result, equals(Right(tTVSeriesDetailModel.toEntity())));
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getTVSeriesDetail(tId),
        ).thenThrow(ServerException());
        final result = await repository.getTVSeriesDetail(tId);
        verify(mockRemoteDataSource.getTVSeriesDetail(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.getTVSeriesDetail(tId),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getTVSeriesDetail(tId);
        expect(
          result,
          equals(
            const Left(ConnectionFailure('Failed to connect to the network')),
          ),
        );
      },
    );
  });

  group('Get TV Series Recommendations', () {
    final tTVSeriesModelList = <TVSeriesModel>[];
    const tId = 88396;

    test(
      'should return data (tv series list) when the call is successful',
      () async {
        when(
          mockRemoteDataSource.getTVSeriesRecommendations(tId),
        ).thenAnswer((_) async => tTVSeriesModelList);
        final result = await repository.getTVSeriesRecommendations(tId);
        verify(mockRemoteDataSource.getTVSeriesRecommendations(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(<TVSeries>[]));
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.getTVSeriesRecommendations(tId),
        ).thenThrow(ServerException());
        final result = await repository.getTVSeriesRecommendations(tId);
        verify(mockRemoteDataSource.getTVSeriesRecommendations(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.getTVSeriesRecommendations(tId),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.getTVSeriesRecommendations(tId);
        expect(
          result,
          equals(
            const Left(ConnectionFailure('Failed to connect to the network')),
          ),
        );
      },
    );
  });

  group('Search TV Series', () {
    const tQuery = 'falcon';

    test(
      'should return tv series list when call to remote data source is successful',
      () async {
        when(
          mockRemoteDataSource.searchTVSeries(tQuery),
        ).thenAnswer((_) async => tTVSeriesModelList);
        final result = await repository.searchTVSeries(tQuery);
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTVSeriesList);
      },
    );

    test(
      'should return server failure when call to remote data source is unsuccessful',
      () async {
        when(
          mockRemoteDataSource.searchTVSeries(tQuery),
        ).thenThrow(ServerException());
        final result = await repository.searchTVSeries(tQuery);
        expect(result, const Left(ServerFailure('')));
      },
    );

    test(
      'should return connection failure when device is not connected',
      () async {
        when(
          mockRemoteDataSource.searchTVSeries(tQuery),
        ).thenThrow(const SocketException('Failed to connect to the network'));
        final result = await repository.searchTVSeries(tQuery);
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      },
    );
  });

  group('Save Watchlist', () {
    test('should return success message when saving is successful', () async {
      when(
        mockLocalDataSource.insertWatchlist(testTVSeriesTable),
      ).thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testTVSeriesDetail);
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return database failure when saving unsuccessful', () async {
      when(
        mockLocalDataSource.insertWatchlist(testTVSeriesTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testTVSeriesDetail);
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('Remove Watchlist', () {
    test('should return success message when remove successful', () async {
      when(
        mockLocalDataSource.removeWatchlist(testTVSeriesTable),
      ).thenAnswer((_) async => 'Removed from Watchlist');
      final result = await repository.removeWatchlist(testTVSeriesDetail);
      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return database failure when remove unsuccessful', () async {
      when(
        mockLocalDataSource.removeWatchlist(testTVSeriesTable),
      ).thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testTVSeriesDetail);
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('Get Watchlist Status', () {
    test('should return watch status whether data is found', () async {
      const tId = 88396;
      when(
        mockLocalDataSource.getTVSeriesById(tId),
      ).thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, false);
    });
  });

  group('Get Watchlist TV Series', () {
    test('should return list of TV Series', () async {
      when(
        mockLocalDataSource.getWatchlistTVSeries(),
      ).thenAnswer((_) async => [testTVSeriesTable]);
      final result = await repository.getWatchlistTVSeries();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTVSeries]);
    });
  });
}
