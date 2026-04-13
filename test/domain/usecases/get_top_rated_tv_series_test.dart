import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetTopRatedTVSeries(mockTVSeriesRepository);
  });

  test('should get list of top rated tv series from the repository', () async {
    when(
      mockTVSeriesRepository.getTopRatedTVSeries(),
    ).thenAnswer((_) async => Right(testTVSeriesList));

    final result = await usecase.execute();

    expect(result, Right(testTVSeriesList));
  });
}
