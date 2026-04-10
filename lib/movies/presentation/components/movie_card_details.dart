import 'package:flutter/material.dart';
import 'package:kinobaza/core/domain/entities/media_details.dart';
import 'package:kinobaza/core/presentation/components/circle_dot.dart';

class MovieCardDetails extends StatelessWidget {
  const MovieCardDetails({
    super.key,
    required this.movieDetails,
  });

  final MediaDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final hasYear = movieDetails.releaseDate.isNotEmpty;
    final hasGenres = movieDetails.genres.isNotEmpty;
    final hasRuntime = movieDetails.runtime != null &&
        movieDetails.runtime!.isNotEmpty;

    if (!hasYear && !hasGenres && !hasRuntime) {
      return const SizedBox();
    }

    return Wrap(
      children: [
        if (hasYear) ...[
          Text(
            movieDetails.releaseDate,
            style: textTheme.bodyLarge,
          ),
          const CircleDot(),
        ],
        if (hasGenres) ...[
          Text(
            movieDetails.genres,
            style: textTheme.bodyLarge,
          ),
          const CircleDot(),
        ],
        if (hasRuntime) ...[
          Text(
            movieDetails.runtime!,
            style: textTheme.bodyLarge,
          ),
        ],
      ],
    );
  }
}