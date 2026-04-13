import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetWatchlistTVSeries(mockTVSeriesRepository);
  });

  test('should get list of watchlist tv series from the repository', () async {
    when(
      mockTVSeriesRepository.getWatchlistTVSeries(),
    ).thenAnswer((_) async => Right(testTVSeriesList));

    final result = await usecase.execute();

    expect(result, Right(testTVSeriesList));
  });
}
