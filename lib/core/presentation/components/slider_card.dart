import 'package:flutter/material.dart';
import 'package:kinobaza/core/domain/entities/media.dart';
import 'package:kinobaza/core/presentation/components/slider_card_image.dart';
import 'package:kinobaza/core/utils/functions.dart';
import 'package:kinobaza/core/resources/app_colors.dart';
import 'package:kinobaza/core/resources/app_constants.dart';
import 'package:kinobaza/core/resources/app_values.dart';

class SliderCard extends StatelessWidget {
  const SliderCard({
    super.key,
    required this.media,
    required this.itemIndex,
  });

  final Media media;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        navigateToDetailsView(context, media);
      },
      child: SafeArea(
        child: Stack(
          children: [
            // Постер
            SliderCardImage(imageUrl: media.backdropUrl),

            // Градиент снизу
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Контент
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p16,
                left: AppPadding.p16,
                bottom: AppPadding.p10,
              ),
              child: SizedBox(
                height: size.height * 0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Рейтинг
                    if (media.voteAverage > 0) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rate_rounded,
                            color: AppColors.ratingIconColor,
                            size: AppSize.s16,
                          ),
                          const SizedBox(width: AppSize.s4),
                          Text(
                            media.voteAverage.toStringAsFixed(1),
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.ratingIconColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s4),
                    ],

                    // Название
                    Text(
                      media.title,
                      maxLines: 2,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          const Shadow(
                            blurRadius: 8,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSize.s4),

                    // Год
                    Text(
                      media.releaseDate,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: AppSize.s8),

                    // Кнопка Подробнее
                    ElevatedButton.icon(
                      onPressed: () {
                        navigateToDetailsView(context, media);
                      },
                      icon: const Icon(Icons.info_outline, size: AppSize.s16),
                      label: const Text('Подробнее'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p16,
                          vertical: AppPadding.p8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s20),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSize.s8),

                    // Точки навигации
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        AppConstants.carouselSliderItemsCount,
                            (indexDot) {
                          return Container(
                            margin: const EdgeInsets.only(right: AppMargin.m10),
                            width: indexDot == itemIndex
                                ? AppSize.s30
                                : AppSize.s6,
                            height: AppSize.s6,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(AppSize.s6),
                              color: indexDot == itemIndex
                                  ? AppColors.primary
                                  : AppColors.inactiveColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}