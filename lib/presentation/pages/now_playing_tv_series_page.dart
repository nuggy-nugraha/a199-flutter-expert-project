import 'package:ditonton/presentation/bloc/tv_series_list_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingTVSeriesPage extends StatefulWidget {
  static const routeName = '/now-playing-tv-series';

  const NowPlayingTVSeriesPage({super.key});

  @override
  State<NowPlayingTVSeriesPage> createState() => _NowPlayingTVSeriesPageState();
}

class _NowPlayingTVSeriesPageState extends State<NowPlayingTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<NowPlayingTVSeriesBloc>();
    Future.microtask(() => bloc.add(FetchNowPlayingTVSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Now Playing TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTVSeriesBloc, NowPlayingTVSeriesState>(
          builder: (context, state) {
            if (state is NowPlayingTVSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NowPlayingTVSeriesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.tvSeriesList[index];
                  return TVSeriesCard(tvSeries);
                },
                itemCount: state.tvSeriesList.length,
              );
            } else if (state is NowPlayingTVSeriesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
