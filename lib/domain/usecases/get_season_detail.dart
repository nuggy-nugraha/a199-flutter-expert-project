import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetSeasonDetail {
  final TVSeriesRepository repository;

  GetSeasonDetail(this.repository);

  Future<Either<Failure, List<Episode>>> execute(
    int tvId,
    int seasonNumber,
  ) async {
    return repository.getSeasonDetail(tvId, seasonNumber);
  }
}
