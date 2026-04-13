import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TVSeriesDetailPage extends StatefulWidget {
  static const routeName = '/tv-series-detail';

  final int id;
  const TVSeriesDetailPage({required this.id, super.key});

  @override
  State<TVSeriesDetailPage> createState() => _TVSeriesDetailPageState();
}

class _TVSeriesDetailPageState extends State<TVSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<TVSeriesDetailBloc>();
    Future.microtask(() => bloc.add(FetchTVSeriesDetail(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVSeriesDetailBloc, TVSeriesDetailState>(
        builder: (context, state) {
          if (state is TVSeriesDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TVSeriesDetailLoaded) {
            return SafeArea(
              child: TVSeriesDetailContent(
                state.tvSeries,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state is TVSeriesDetailError) {
            return Text(state.message);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class TVSeriesDetailContent extends StatelessWidget {
  final TVSeriesDetail tvSeries;
  final List<TVSeries> recommendations;
  final bool isAddedWatchlist;

  const TVSeriesDetailContent(
    this.tvSeries,
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
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 56),
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
                            Text(tvSeries.name, style: heading5),
                            BlocConsumer<
                              TVSeriesDetailBloc,
                              TVSeriesDetailState
                            >(
                              listener: (context, state) {
                                if (state is TVSeriesDetailLoaded &&
                                    state.watchlistMessage.isNotEmpty) {
                                  final message = state.watchlistMessage;
                                  if (message ==
                                          TVSeriesDetailBloc
                                              .watchlistAddSuccessMessage ||
                                      message ==
                                          TVSeriesDetailBloc
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
                                final isAdded = state is TVSeriesDetailLoaded
                                    ? state.isAddedToWatchlist
                                    : isAddedWatchlist;
                                return FilledButton(
                                  onPressed: () {
                                    if (!isAdded) {
                                      context.read<TVSeriesDetailBloc>().add(
                                        AddTVSeriesToWatchlist(tvSeries),
                                      );
                                    } else {
                                      context.read<TVSeriesDetailBloc>().add(
                                        RemoveTVSeriesFromWatchlist(tvSeries),
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
                            Text(_showGenres(tvSeries.genres)),
                            Text(
                              '${tvSeries.numberOfSeasons} Season(s) · ${tvSeries.numberOfEpisodes} Episodes',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvSeries.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: mikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvSeries.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text('Overview', style: heading6),
                            Text(tvSeries.overview),
                            const SizedBox(height: 16),
                            Text('Seasons', style: heading6),
                            _buildSeasonList(
                              context,
                              tvSeries.seasons,
                              tvSeries.id,
                            ),
                            const SizedBox(height: 16),
                            Text('Episodes', style: heading6),
                            _buildEpisodeList(),
                            const SizedBox(height: 16),
                            Text('Recommendations', style: heading6),
                            if (recommendations.isNotEmpty)
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final series = recommendations[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            TVSeriesDetailPage.routeName,
                                            arguments: series.id,
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://image.tmdb.org/t/p/w500${series.posterPath}',
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
            minChildSize: 0.25,
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

  Widget _buildSeasonList(
    BuildContext context,
    List<Season> seasons,
    int tvId,
  ) {
    if (seasons.isEmpty) {
      return const Text('No seasons available.');
    }
    return BlocBuilder<TVSeriesDetailBloc, TVSeriesDetailState>(
      builder: (context, state) {
        final selectedSeason = state is TVSeriesDetailLoaded
            ? state.selectedSeason
            : seasons.first.seasonNumber;
        return SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: seasons.length,
            itemBuilder: (context, index) {
              final season = seasons[index];
              final isSelected = selectedSeason == season.seasonNumber;
              return GestureDetector(
                onTap: () {
                  context.read<TVSeriesDetailBloc>().add(
                    FetchTVSeriesSeasonDetail(
                      tvId: tvId,
                      seasonNumber: season.seasonNumber,
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  decoration: isSelected
                      ? BoxDecoration(
                          border: Border.all(color: mikadoYellow, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: season.posterPath != null
                            ? CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w500${season.posterPath}',
                                height: 120,
                                width: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Container(
                                height: 120,
                                width: 80,
                                color: Colors.grey,
                                child: const Icon(Icons.tv),
                              ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 80,
                        child: Text(
                          season.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEpisodeList() {
    return BlocBuilder<TVSeriesDetailBloc, TVSeriesDetailState>(
      builder: (context, state) {
        if (state is! TVSeriesDetailLoaded) {
          return const SizedBox.shrink();
        }
        if (state.episodeState == TVSeriesEpisodeState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.episodeState == TVSeriesEpisodeState.error) {
          return Text(state.episodeMessage);
        } else if (state.episodeState == TVSeriesEpisodeState.loaded) {
          return _episodeListWidget(state.seasonEpisodes);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _episodeListWidget(List<Episode> episodes) {
    if (episodes.isEmpty) {
      return const Text('No episodes available.');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: episode.stillPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/w500${episode.stillPath}',
                      width: 80,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : const SizedBox(width: 80, height: 50, child: Icon(Icons.tv)),
            title: Text(
              '${episode.episodeNumber}. ${episode.name}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            subtitle: Text(
              episode.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        );
      },
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }
    if (result.isEmpty) return result;
    return result.substring(0, result.length - 2);
  }
}
