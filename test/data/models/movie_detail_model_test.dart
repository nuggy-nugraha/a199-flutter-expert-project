import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  const tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: '/backdrop.jpg',
    budget: 200000000,
    genres: [GenreModel(id: 28, name: 'Action')],
    homepage: 'https://example.com',
    id: 557,
    imdbId: 'tt0145487',
    originalLanguage: 'en',
    originalTitle: 'Spider-Man',
    overview: 'A hero emerges.',
    popularity: 60.441,
    posterPath: '/poster.jpg',
    releaseDate: '2002-05-01',
    revenue: 821708551,
    runtime: 121,
    status: 'Released',
    tagline: 'Go for it.',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/movie_detail.json'),
      );
      final result = MovieDetailResponse.fromJson(jsonMap);
      expect(result, isA<MovieDetailResponse>());
      expect(result.id, isNotNull);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tMovieDetailResponse.toJson();
      expect(result['id'], 557);
      expect(result['title'], 'Spider-Man');
      expect(result['adult'], false);
      expect(result['popularity'], 60.441);
    });
  });

  group('toEntity', () {
    test('should return a MovieDetail entity with correct properties', () {
      final result = tMovieDetailResponse.toEntity();
      expect(result, isA<MovieDetail>());
      expect(result.id, 557);
      expect(result.title, 'Spider-Man');
      expect(result.genres, [const Genre(id: 28, name: 'Action')]);
    });
  });

  group('props', () {
    test('should return correct equality based on props', () {
      const tMovieDetailResponse2 = MovieDetailResponse(
        adult: false,
        backdropPath: '/backdrop.jpg',
        budget: 200000000,
        genres: [GenreModel(id: 28, name: 'Action')],
        homepage: 'https://example.com',
        id: 557,
        imdbId: 'tt0145487',
        originalLanguage: 'en',
        originalTitle: 'Spider-Man',
        overview: 'A hero emerges.',
        popularity: 60.441,
        posterPath: '/poster.jpg',
        releaseDate: '2002-05-01',
        revenue: 821708551,
        runtime: 121,
        status: 'Released',
        tagline: 'Go for it.',
        title: 'Spider-Man',
        video: false,
        voteAverage: 7.2,
        voteCount: 13507,
      );
      expect(tMovieDetailResponse, tMovieDetailResponse2);
    });
  });
}
