import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail';

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<MovieDetailBloc>();
    Future.microtask(() => bloc.add(FetchMovieDetail(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailLoaded) {
            return SafeArea(
              child: DetailContent(
                state.movie,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state is MovieDetailError) {
            return Text(state.message);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(
    this.movie,
    this.recommendations,
    this.isAddedWatchlist, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: richBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: heading5),
                            BlocConsumer<MovieDetailBloc, MovieDetailState>(
                              listener: (context, state) {
                                if (state is MovieDetailLoaded &&
                                    state.watchlistMessage.isNotEmpty) {
                                  final message = state.watchlistMessage;
                                  if (message ==
                                          MovieDetailBloc
                                              .watchlistAddSuccessMessage ||
                                      message ==
                                          MovieDetailBloc
                                              .watchlistRemoveSuccessMessage) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              builder: (context, state) {
                                final isAdded = state is MovieDetailLoaded
                                    ? state.isAddedToWatchlist
                                    : isAddedWatchlist;
                                return FilledButton(
                                  onPressed: () {
                                    if (!isAdded) {
                                      context.read<MovieDetailBloc>().add(
                                        AddMovieToWatchlist(movie),
                                      );
                                    } else {
                                      context.read<MovieDetailBloc>().add(
                                        RemoveMovieFromWatchlist(movie),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isAdded
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.add),
                                      const Text('Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(_showGenres(movie.genres)),
                            Text(_showDuration(movie.runtime)),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: mikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: heading6),
                            Text(movie.overview),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: heading6),
                            if (recommendations.isNotEmpty)
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final rec = recommendations[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            MovieDetailPage.routeName,
                                            arguments: rec.id,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w500${rec.posterPath}',
                                            placeholder: (context, url) =>
                                                const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: recommendations.length,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: richBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
