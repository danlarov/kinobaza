import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/core/presentation/components/error_screen.dart';
import 'package:kinobaza/core/presentation/components/loading_indicator.dart';
import 'package:kinobaza/core/presentation/components/slider_card.dart';
import 'package:kinobaza/core/resources/app_routes.dart';
import 'package:kinobaza/core/presentation/components/custom_slider.dart';
import 'package:kinobaza/core/presentation/components/section_listview_card.dart';
import 'package:kinobaza/core/presentation/components/section_header.dart';
import 'package:kinobaza/core/presentation/components/section_listview.dart';
import 'package:kinobaza/core/resources/app_strings.dart';
import 'package:kinobaza/core/resources/app_values.dart';
import 'package:kinobaza/core/utils/enums.dart';
import 'package:kinobaza/movies/presentation/controllers/movies_bloc/movies_bloc.dart';
import 'package:kinobaza/movies/presentation/controllers/movies_bloc/movies_event.dart';
import 'package:kinobaza/movies/presentation/controllers/movies_bloc/movies_state.dart';

class MoviesView extends StatelessWidget {
  const MoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          switch (state.status) {
            case RequestStatus.loading:
              return const LoadingIndicator();
            case RequestStatus.loaded:
              return MoviesWidget(
                nowPlayingMovies: state.movies[0],
                popularMovies: state.movies[1],
                topRatedMovies: state.movies[2],
                premieres: state.movies.length > 3 ? state.movies[3] : [],
              );
            case RequestStatus.error:
              return ErrorScreen(
                onTryAgainPressed: () {
                  context.read<MoviesBloc>().add(GetMoviesEvent());
                },
              );
          }
        },
      ),
    );
  }
}

class MoviesWidget extends StatelessWidget {
  final List<Media> nowPlayingMovies;
  final List<Media> popularMovies;
  final List<Media> topRatedMovies;
  final List<Media> premieres;

  const MoviesWidget({
    super.key,
    required this.nowPlayingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.premieres,
  });

  @override
  Widget build(BuildContext context) {
    final classics = topRatedMovies
        .where((m) {
      final year = int.tryParse(m.releaseDate) ?? 9999;
      return year < 2000;
    })
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSlider(
            itemBuilder: (context, itemIndex, _) {
              return SliderCard(
                media: nowPlayingMovies[itemIndex],
                itemIndex: itemIndex,
              );
            },
          ),
          SectionHeader(title: 'Сейчас в кино', onSeeAllTap: () {
            context.goNamed(AppRoutes.nowPlayingMoviesRoute);
          }),
          SectionListView(
            height: AppSize.s240,
            itemCount: nowPlayingMovies.length,
            itemBuilder: (context, index) {
              return SectionListViewCard(media: nowPlayingMovies[index]);
            },
          ),
          if (premieres.isNotEmpty) ...[
            SectionHeader(title: 'Скоро в кино', onSeeAllTap: () {
              context.goNamed(AppRoutes.premieresMoviesRoute);
            }),
            SectionListView(
              height: AppSize.s240,
              itemCount: premieres.length,
              itemBuilder: (context, index) {
                return SectionListViewCard(media: premieres[index]);
              },
            ),
          ],
          SectionHeader(
            title: AppStrings.popularMovies,
            onSeeAllTap: () {
              context.goNamed(AppRoutes.popularMoviesRoute);
            },
          ),
          SectionListView(
            height: AppSize.s240,
            itemCount: popularMovies.length,
            itemBuilder: (context, index) {
              return SectionListViewCard(media: popularMovies[index]);
            },
          ),
          SectionHeader(
            title: AppStrings.topRatedMovies,
            onSeeAllTap: () {
              context.goNamed(AppRoutes.topRatedMoviesRoute);
            },
          ),
          SectionListView(
            height: AppSize.s240,
            itemCount: topRatedMovies.length,
            itemBuilder: (context, index) {
              return SectionListViewCard(media: topRatedMovies[index]);
            },
          ),
          if (classics.isNotEmpty) ...[
            SectionHeader(title: 'Классика', onSeeAllTap: () {
              context.goNamed(AppRoutes.classicMoviesRoute);
            }),
            SectionListView(
              height: AppSize.s240,
              itemCount: classics.length,
              itemBuilder: (context, index) {
                return SectionListViewCard(media: classics[index]);
              },
            ),
          ],
          const SizedBox(height: AppSize.s8),
        ],
      ),
    );
  }
}