import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVSeriesRecommendations usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetTVSeriesRecommendations(mockTVSeriesRepository);
  });

  const tId = 88396;

  test(
    'should get list of tv series recommendations from the repository',
    () async {
      when(
        mockTVSeriesRepository.getTVSeriesRecommendations(tId),
      ).thenAnswer((_) async => Right(testTVSeriesList));

      final result = await usecase.execute(tId);

      expect(result, Right(testTVSeriesList));
    },
  );
}
