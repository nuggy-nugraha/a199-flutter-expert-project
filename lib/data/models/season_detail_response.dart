import 'package:ditonton/data/models/episode_model.dart';
import 'package:equatable/equatable.dart';

class SeasonDetailResponse extends Equatable {
  const SeasonDetailResponse({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.episodes,
  });

  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final List<EpisodeModel> episodes;

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'],
        episodes: (json['episodes'] as List)
            .map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [
    id,
    name,
    overview,
    posterPath,
    seasonNumber,
    episodes,
  ];
}
