import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTVSeriesStatus usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetWatchlistTVSeriesStatus(mockTVSeriesRepository);
  });

  test('should get watchlist status from repository', () async {
    when(
      mockTVSeriesRepository.isAddedToWatchlist(1),
    ).thenAnswer((_) async => true);

    final result = await usecase.execute(1);

    expect(result, true);
  });
}
