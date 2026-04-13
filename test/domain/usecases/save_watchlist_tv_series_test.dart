import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = SaveWatchlistTVSeries(mockTVSeriesRepository);
  });

  test('should save tv series to the repository', () async {
    when(
      mockTVSeriesRepository.saveWatchlist(testTVSeriesDetail),
    ).thenAnswer((_) async => const Right('Added to Watchlist'));

    final result = await usecase.execute(testTVSeriesDetail);

    expect(result, const Right('Added to Watchlist'));
  });
}
