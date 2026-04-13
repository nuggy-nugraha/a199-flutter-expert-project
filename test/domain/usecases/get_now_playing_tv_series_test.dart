import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetNowPlayingTVSeries(mockTVSeriesRepository);
  });

  test('should get list of tv series from the repository', () async {
    when(
      mockTVSeriesRepository.getNowPlayingTVSeries(),
    ).thenAnswer((_) async => Right(testTVSeriesList));

    final result = await usecase.execute();

    expect(result, Right(testTVSeriesList));
  });
}
