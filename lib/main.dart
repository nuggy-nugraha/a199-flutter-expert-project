import 'dart:ui';

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_series_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_tv_series_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
   PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // movies
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        // tv series
        BlocProvider(create: (_) => di.locator<NowPlayingTVSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTVSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTVSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TVSeriesDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TVSeriesSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTVSeriesBloc>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: colorScheme,
          primaryColor: richBlack,
          scaffoldBackgroundColor: richBlack,
          textTheme: textTheme,
          drawerTheme: drawerTheme,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeMoviePage(),
        navigatorObservers: [
          routeObserver,
          FirebaseAnalyticsObserver(analytics: _analytics),
        ],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularMoviesPage(),
              );
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedMoviesPage(),
              );
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const WatchlistMoviesPage(),
              );
            case HomeTVSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const HomeTVSeriesPage(),
              );
            case PopularTVSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularTVSeriesPage(),
              );
            case TopRatedTVSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedTVSeriesPage(),
              );
            case NowPlayingTVSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const NowPlayingTVSeriesPage(),
              );
            case TVSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVSeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchTVSeriesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const SearchTVSeriesPage(),
              );
            case WatchlistTVSeriesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const WatchlistTVSeriesPage(),
              );
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
