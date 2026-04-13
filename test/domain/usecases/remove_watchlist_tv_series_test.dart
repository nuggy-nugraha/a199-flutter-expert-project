import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = RemoveWatchlistTVSeries(mockTVSeriesRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    when(
      mockTVSeriesRepository.removeWatchlist(testTVSeriesDetail),
    ).thenAnswer((_) async => const Right('Removed from Watchlist'));

    final result = await usecase.execute(testTVSeriesDetail);

    expect(result, const Right('Removed from Watchlist'));
  });
}
