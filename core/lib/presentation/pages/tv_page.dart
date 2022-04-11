import 'package:cached_network_image/cached_network_image.dart';

import 'package:about/about.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/presentation/bloc/now_playing/bloc/now_playing_bloc.dart';
import 'package:core/presentation/bloc/popular/bloc/popular_bloc.dart';
import 'package:core/presentation/bloc/top_rated/bloc/top_rated_bloc.dart';
import 'package:core/presentation/pages/popular_tv_page.dart';
import 'package:core/presentation/pages/top_rated_tv_page.dart';
import 'package:core/presentation/pages/tv_detail_page.dart';
import 'package:search/presentation/pages/tv_search_page.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:core/utils/routes.dart';
import 'home_movie_page.dart';
import 'on_the_air_page.dart';

class TvPage extends StatefulWidget {
  const TvPage({Key? key}) : super(key: key);

  @override
  _TvPageState createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => Provider.of<NowPlayingBloc>(context, listen: false)
        .add(FetchTvOnTheAir()));
    Future.microtask(() =>
        Provider.of<PopularBloc>(context, listen: false).add(FetchTvPopular()));
    Future.microtask(() => Provider.of<TopRatedBloc>(context, listen: false)
        .add(FetchTvTopRated()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pushReplacementNamed(context, HOME_ROUTE);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Tv'),
              onTap: () {
                Navigator.pushReplacementNamed(context, TV_PAGE_ROUTE);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WATCHLIST_ROUTE);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_TV_ROUTE);
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
            children: [
              _buildSubHeading(
                title: 'On The Air',
                onTap: () => Navigator.pushNamed(context, ON_THE_AIR_TV_ROUTE),
              ),
              BlocBuilder<NowPlayingBloc, NowPlayingState>(
                  builder: (context, state) {
                if (state is NowPlayingLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvOnTheAirHasData) {
                  return TvList(state.result);
                } else if (state is NowPlayingError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center();
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, POPULAR_TV_ROUTE),
              ),
              BlocBuilder<PopularBloc, PopularState>(builder: (context, state) {
                if (state is PopularLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvPopularHasData) {
                  return TvList(state.result);
                } else if (state is PopularError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center();
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(context, TOP_RATED_TV_ROUTE),
              ),
              BlocBuilder<TopRatedBloc, TopRatedState>(
                  builder: (context, state) {
                if (state is TopRatedLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvTopRatedHasData) {
                  return TvList(state.result);
                } else if (state is TopRatedError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center();
                }
              }),
            ],
          ),
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
              children: const [
                Text('See More'),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  const TvList(this.tvs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TV_DETAIL_ROUTE,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
