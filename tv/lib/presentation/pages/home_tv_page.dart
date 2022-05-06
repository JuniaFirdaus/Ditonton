import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv/tv_entity.dart';
import 'package:core/utils/routes.dart';
import 'package:core/utils/state_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/nowplaying/now_playing_tv_bloc.dart';
import 'package:tv/presentation/bloc/popular/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/toprated/top_rated_tv_bloc.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:tv/presentation/pages/top_rated_tv_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

import '../bloc/nowplaying/now_playing_event.dart';
import '../bloc/popular/popular_event.dart';
import '../bloc/toprated/top_rated_event.dart';

class HomeTvPage extends StatefulWidget {
  static const routeName = '/home-tv';

  const HomeTvPage({Key? key}) : super(key: key);

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingTvBloc>().add(NowPlayingTv());
      context.read<PopularTvBloc>().add(PopularTv());
      context.read<TopRatedTvBloc>().add(TopRatedTv());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tv'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, searchRoute, arguments: false);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Airing today',
                  style: kHeading6,
                ),
                BlocBuilder<NowPlayingTvBloc, StateRequest>(
                    builder: (context, state) {
                  if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HasData) {
                    return TvList(state.result);
                  } else {
                    return Container();
                  }
                }),
                _buildSubHeading(
                  title: 'Popular',
                  onTap: () =>
                      Navigator.pushNamed(context, PopularTvPage.routeName),
                ),
                BlocBuilder<PopularTvBloc, StateRequest>(
                    builder: (context, state) {
                  if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HasData) {
                    return TvList(state.result);
                  } else if (state is Error) {
                    return Center(
                      child: Text(state.message, key: const Key('error')),
                    );
                  } else {
                    return const Text('Failed');
                  }
                }),
                _buildSubHeading(
                  title: 'Top Rated',
                  onTap: () =>
                      Navigator.pushNamed(context, TopRatedTvPage.routeName),
                ),
                BlocBuilder<TopRatedTvBloc, StateRequest>(
                    builder: (context, state) {
                  if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HasData) {
                    return TvList(state.result);
                  } else {
                    return Container();
                  }
                }),
              ]),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<TvEntity> tv;

  const TvList(this.tv, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = tv[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.routeName,
                  arguments: item.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${item.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tv.length,
      ),
    );
  }
}
