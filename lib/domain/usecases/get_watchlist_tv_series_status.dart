import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetWatchlistTVSeriesStatus {
  final TVSeriesRepository repository;

  GetWatchlistTVSeriesStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
