import 'package:flutter/material.dart';
import 'package:kinobaza/core/presentation/components/circle_dot.dart';

class TVShowCardDetails extends StatelessWidget {
  const TVShowCardDetails({
    super.key,
    required this.genres,
    required this.releaseDate,
  });

  final String genres;
  final String releaseDate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasGenres = genres.isNotEmpty;
    final hasDate = releaseDate.isNotEmpty;

    if (!hasGenres && !hasDate) return const SizedBox();

    return Wrap(
      children: [
        if (hasDate) ...[
          Text(releaseDate, style: textTheme.bodyLarge),
          const CircleDot(),
        ],
        if (hasGenres) ...[
          Text(genres, style: textTheme.bodyLarge),
        ],
      ],
    );
  }
}