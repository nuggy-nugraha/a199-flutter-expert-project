import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = SearchTVSeries(mockTVSeriesRepository);
  });

  const tQuery = 'falcon';

  test('should get a list of tv series from the repository', () async {
    when(
      mockTVSeriesRepository.searchTVSeries(tQuery),
    ).thenAnswer((_) async => Right(testTVSeriesList));

    final result = await usecase.execute(tQuery);

    expect(result, Right(testTVSeriesList));
  });
}
