import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTVSeries])
void main() {
  late WatchlistTVSeriesNotifier provider;
  late MockGetWatchlistTVSeries mockGetWatchlistTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTVSeries = MockGetWatchlistTVSeries();
    provider =
        WatchlistTVSeriesNotifier(
          getWatchlistTVSeries: mockGetWatchlistTVSeries,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  test(
    'should change tv series data when data is gotten successfully',
    () async {
      when(
        mockGetWatchlistTVSeries.execute(),
      ).thenAnswer((_) async => const Right([testWatchlistTVSeries]));
      await provider.fetchWatchlistTVSeries();
      expect(provider.watchlistState, RequestState.loaded);
      expect(provider.watchlistTVSeries, [testWatchlistTVSeries]);
      expect(listenerCallCount, 2);
    },
  );

  test('should return error when data is unsuccessful', () async {
    when(
      mockGetWatchlistTVSeries.execute(),
    ).thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
    await provider.fetchWatchlistTVSeries();
    expect(provider.watchlistState, RequestState.error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
