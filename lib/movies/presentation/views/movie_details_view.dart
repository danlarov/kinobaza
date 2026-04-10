import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/core/domain/entities/media_details.dart';
import 'package:kinobaza/core/presentation/components/error_screen.dart';
import 'package:kinobaza/core/presentation/components/image_with_shimmer.dart';
import 'package:kinobaza/core/presentation/components/section_listview.dart';
import 'package:kinobaza/core/resources/app_colors.dart';
import 'package:kinobaza/core/resources/app_strings.dart';
import 'package:kinobaza/core/resources/app_values.dart';
import 'package:kinobaza/core/utils/enums.dart';
import 'package:kinobaza/core/utils/functions.dart';
import 'package:kinobaza/movies/domain/entities/cast.dart';
import 'package:kinobaza/movies/domain/entities/review.dart';
import 'package:kinobaza/movies/presentation/components/cast_card.dart';
import 'package:kinobaza/movies/presentation/components/movie_card_details.dart';
import 'package:kinobaza/movies/presentation/components/review_card.dart';
import 'package:kinobaza/movies/presentation/controllers/movie_details_bloc/movie_details_bloc.dart';
import 'package:kinobaza/core/presentation/components/loading_indicator.dart';
import 'package:kinobaza/core/presentation/components/details_card.dart';
import 'package:kinobaza/core/presentation/components/section_title.dart';
import 'package:kinobaza/core/services/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kinobaza/core/presentation/components/video_player_view.dart';

class MovieDetailsView extends StatelessWidget {
  final int movieId;

  const MovieDetailsView({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      sl<MovieDetailsBloc>()..add(GetMovieDetailsEvent(movieId)),
      child: Scaffold(
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            switch (state.status) {
              case RequestStatus.loading:
                return const LoadingIndicator();
              case RequestStatus.loaded:
                return MovieDetailsWidget(movieDetails: state.movieDetails!);
              case RequestStatus.error:
                return ErrorScreen(
                  onTryAgainPressed: () {
                    context
                        .read<MovieDetailsBloc>()
                        .add(GetMovieDetailsEvent(movieId));
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

class MovieDetailsWidget extends StatelessWidget {
  const MovieDetailsWidget({
    required this.movieDetails,
    super.key,
  });

  final MediaDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsCard(
            mediaDetails: movieDetails,
            detailsWidget: MovieCardDetails(movieDetails: movieDetails),
          ),
          _getInfoRow(context, movieDetails),
          _getWatchButton(context, movieDetails.webUrl),
          getOverviewSection(movieDetails.overview),
          _getImages(movieDetails.images),
          _getCast(movieDetails.cast),
          _getFacts(movieDetails.facts),
          _getSequelsAndPrequels(movieDetails.sequelsAndPrequels),
          _getVideos(context, movieDetails.videos),
          _getReviews(movieDetails.reviews),
          getSimilarSection(movieDetails.similar),
          const SizedBox(height: AppSize.s8),
        ],
      ),
    );
  }
}

Widget _getWatchButton(BuildContext context, String? webUrl) {
  if (webUrl == null || webUrl.isEmpty) return const SizedBox();
  final refUrl = '$webUrl?utm_source=твой_id';
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppPadding.p16,
      vertical: AppPadding.p8,
    ),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(refUrl);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        icon: const Icon(Icons.play_circle_outline),
        label: const Text('Смотреть на Кинопоиск'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8),
          ),
        ),
      ),
    ),
  );
}

Widget _getInfoRow(BuildContext context, MediaDetails details) {
  final textTheme = Theme.of(context).textTheme;
  final hasDirector = details.director != null && details.director!.isNotEmpty;
  final hasCountry = details.country != null && details.country!.isNotEmpty;

  if (!hasDirector && !hasCountry) return const SizedBox();

  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppPadding.p16,
      vertical: AppPadding.p8,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasDirector) ...[
          Row(
            children: [
              Text(
                'Режиссёр: ',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              Expanded(
                child: Text(
                  details.director!,
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s4),
        ],
        if (hasCountry) ...[
          Row(
            children: [
              Text(
                'Страна: ',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              Expanded(
                child: Text(
                  details.country!,
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget _getImages(List<String> images) {
  if (images.isEmpty) return const SizedBox();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(title: 'Кадры из фильма'),
      SectionListView(
        height: AppSize.s160,
        itemCount: images.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: AppPadding.p8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s8),
            child: ImageWithShimmer(
              imageUrl: images[index],
              width: AppSize.s240,
              height: AppSize.s160,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _getFacts(List<String> facts) {
  if (facts.isEmpty) return const SizedBox();

  String cleanHtml(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'&#\d+;'), '')
        .replaceAll(RegExp(r'&[a-zA-Z]+;'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
  final cleanFacts = facts.map(cleanHtml).where((f) => f.isNotEmpty).toList();
  if (cleanFacts.isEmpty) return const SizedBox();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(title: 'Знаете ли вы...'),
      SizedBox(
        height: AppSize.s200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          itemCount: cleanFacts.length,
          itemBuilder: (context, index) {
            return Container(
              width: AppSize.s240,
              margin: const EdgeInsets.only(right: AppPadding.p12),
              padding: const EdgeInsets.all(AppPadding.p16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(AppSize.s12),
              ),
              child: Text(
                cleanFacts[index],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
                maxLines: 12,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget _getSequelsAndPrequels(List<Media> sequels) {
  if (sequels.isEmpty) return const SizedBox();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(title: 'Сиквелы и приквелы'),
      SectionListView(
        height: AppSize.s190,
        itemCount: sequels.length,
        itemBuilder: (context, index) {
          final movie = sequels[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppPadding.p8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.s8),
                  child: ImageWithShimmer(
                    imageUrl: movie.posterUrl,
                    width: AppSize.s110,
                    height: AppSize.s150,
                  ),
                ),
                const SizedBox(height: AppSize.s4),
                SizedBox(
                  width: AppSize.s110,
                  child: Text(
                    movie.title,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}

Widget _getVideos(BuildContext context, List<Map<String, String>> videos) {
  if (videos.isEmpty) return const SizedBox();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SectionTitle(title: 'Трейлеры'),
      SizedBox(
        height: AppSize.s60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerView(
                      url: video['url'] ?? '',
                      title: video['name'] ?? 'Трейлер',
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(right: AppPadding.p8),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p16,
                  vertical: AppPadding.p8,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  borderRadius: BorderRadius.circular(AppSize.s8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow,
                        color: Colors.white, size: AppSize.s20),
                    const SizedBox(width: AppSize.s8),
                    Text(
                      video['name'] ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget _getCast(List<Cast>? cast) {
  if (cast != null && cast.isNotEmpty) {
    final actors = cast
        .where((c) => c.staffRole == 'ACTOR' || c.staffRole == '')
        .toList();
    if (actors.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: AppStrings.cast),
        SectionListView(
          height: AppSize.s175,
          itemCount: actors.length,
          itemBuilder: (context, index) => CastCard(
            cast: actors[index],
          ),
        ),
      ],
    );
  } else {
    return const SizedBox();
  }
}

Widget _getReviews(List<Review>? reviews) {
  if (reviews != null && reviews.isNotEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: AppStrings.reviews),
        SectionListView(
          height: AppSize.s175,
          itemCount: reviews.length,
          itemBuilder: (context, index) => ReviewCard(
            review: reviews[index],
          ),
        ),
      ],
    );
  } else {
    return const SizedBox();
  }
}