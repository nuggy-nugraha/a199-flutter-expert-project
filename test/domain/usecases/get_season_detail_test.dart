import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/usecases/get_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeasonDetail usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetSeasonDetail(mockTVSeriesRepository);
  });

  const tTvId = 88396;
  const tSeasonNumber = 1;
  const tEpisodes = [
    Episode(
      airDate: '2021-03-19',
      episodeNumber: 1,
      id: 1234567,
      name: 'New World Order',
      overview: 'Overview.',
      stillPath: '/still_path.jpg',
      voteAverage: 7.5,
      voteCount: 100,
      seasonNumber: 1,
    ),
  ];

  test('should get season detail from the repository', () async {
    when(
      mockTVSeriesRepository.getSeasonDetail(tTvId, tSeasonNumber),
    ).thenAnswer((_) async => const Right(tEpisodes));

    final result = await usecase.execute(tTvId, tSeasonNumber);

    expect(result, const Right(tEpisodes));
    verify(mockTVSeriesRepository.getSeasonDetail(tTvId, tSeasonNumber));
    verifyNoMoreInteractions(mockTVSeriesRepository);
  });
}
