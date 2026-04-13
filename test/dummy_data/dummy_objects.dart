import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

const testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

const testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

// TV Series test data
const testTVSeries = TVSeries(
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  firstAirDate: '2021-03-19',
  genreIds: [10765, 10759],
  id: 88396,
  name: 'The Falcon and the Winter Soldier',
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'The Falcon and the Winter Soldier',
  overview:
      'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
  popularity: 78.978,
  posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
  voteAverage: 7.9,
  voteCount: 5765,
);

final testTVSeriesList = [testTVSeries];

const testTVSeriesDetail = TVSeriesDetail(
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  firstAirDate: '2021-03-19',
  genres: [Genre(id: 10765, name: 'Sci-Fi & Fantasy')],
  id: 88396,
  name: 'The Falcon and the Winter Soldier',
  numberOfEpisodes: 6,
  numberOfSeasons: 1,
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'The Falcon and the Winter Soldier',
  overview:
      'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
  popularity: 78.978,
  posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
  seasons: [
    Season(
      airDate: '2021-03-19',
      episodeCount: 6,
      id: 134006,
      name: 'Season 1',
      overview: 'Sam and Bucky team up for global adventure.',
      posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
      seasonNumber: 1,
    ),
  ],
  status: 'Ended',
  tagline: 'The legacy of that shield is complicated.',
  type: 'Miniseries',
  voteAverage: 7.9,
  voteCount: 5765,
);

const testWatchlistTVSeries = TVSeries.watchlist(
  id: 88396,
  name: 'The Falcon and the Winter Soldier',
  posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
  overview:
      'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
);

const testTVSeriesTable = TVSeriesTable(
  id: 88396,
  name: 'The Falcon and the Winter Soldier',
  posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
  overview:
      'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
);

final testTVSeriesMap = {
  'id': 88396,
  'name': 'The Falcon and the Winter Soldier',
  'posterPath': '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
  'overview':
      'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
};
