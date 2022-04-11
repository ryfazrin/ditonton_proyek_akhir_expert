import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/detail/bloc/detail_bloc.dart';
import 'package:core/presentation/bloc/now_playing/bloc/now_playing_bloc.dart';
import 'package:core/presentation/bloc/popular/bloc/popular_bloc.dart';
import 'package:core/presentation/bloc/recommendation/bloc/recommendation_bloc.dart';
import 'package:core/presentation/bloc/top_rated/bloc/top_rated_bloc.dart';
import 'package:core/presentation/bloc/watchlist/bloc/watchlist_bloc.dart';
import 'package:core/presentation/bloc/watchlist/movie_watchlist/bloc/movie_watchlist_bloc.dart';
import 'package:core/presentation/bloc/watchlist/tv_watchlist/bloc/tv_watchlist_bloc.dart';
import 'package:core/presentation/pages/home_movie_page.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';
import 'package:core/presentation/pages/on_the_air_page.dart';
import 'package:core/presentation/pages/popular_movies_page.dart';
import 'package:core/presentation/pages/popular_tv_page.dart';
import 'package:core/presentation/pages/top_rated_movies_page.dart';
import 'package:core/presentation/pages/top_rated_tv_page.dart';
import 'package:core/presentation/pages/tv_detail_page.dart';
import 'package:core/presentation/pages/tv_page.dart';
import 'package:core/presentation/pages/watchlist_page.dart';
import 'package:core/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:search/bloc/search_bloc.dart';
import 'package:search/presentation/pages/movie_search_page.dart';
import 'package:search/presentation/pages/tv_search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Bloc Provider
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<RecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieWatchlistBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvWatchlistBloc>(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          colorScheme: kColorScheme.copyWith(secondary: kMikadoYellow),
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HOME_ROUTE:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case POPULAR_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TOP_RATED_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MOVIE_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SEARCH_MOVIES_ROUTE:
              return CupertinoPageRoute(builder: (_) => MovieSearchPage());
            case WATCHLIST_ROUTE:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case TV_PAGE_ROUTE:
              return MaterialPageRoute(builder: (_) => TvPage());
            case TV_DETAIL_ROUTE:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case POPULAR_TV_ROUTE:
              return CupertinoPageRoute(builder: (_) => PopularTvPage());
            case TOP_RATED_TV_ROUTE:
              return CupertinoPageRoute(builder: (_) => TopRatedTvPage());
            case ON_THE_AIR_TV_ROUTE:
              return CupertinoPageRoute(builder: (_) => OnTheAirTvPage());
            case SEARCH_TV_ROUTE:
              return CupertinoPageRoute(builder: (_) => TvSearchPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
