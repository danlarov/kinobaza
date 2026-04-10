import 'package:flutter/material.dart';
import 'package:kinobaza/core/presentation/components/image_with_shimmer.dart';
import 'package:kinobaza/core/presentation/components/loading_indicator.dart';
import 'package:kinobaza/core/resources/app_values.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:kinobaza/core/network/api_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TicketsView extends StatefulWidget {
  const TicketsView({super.key});

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  List<Map<String, dynamic>> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPremieres();
  }

  Future<void> _loadPremieres() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
        headers: {
          'X-API-KEY': dotenv.env['API_KEY'] ?? '',
          'Content-Type': 'application/json',
        },
      ));
      final response = await dio.get(
        ApiConstants.premieresPath,
        queryParameters: {'year': 2026, 'month': 'APRIL'},
      );
      if (response.statusCode == 200) {
        final items = (response.data['items'] as List? ?? []);
        setState(() {
          _movies = items.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _getTicketUrl(dynamic kinopoiskId) {
    return 'https://www.kinopoisk.ru/film/$kinopoiskId/?utm_source=твой_id';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Билеты в кино',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _movies.isEmpty
          ? const Center(
        child: Text('Нет данных',
            style: TextStyle(color: Colors.white)),
      )
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Большой баннер первого фильма
            _buildBanner(_movies[0]),
            const SizedBox(height: AppSize.s16),
            // Заголовок секции
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
              child: Text(
                'Сейчас в кино',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSize.s12),
            // Горизонтальный список
            SizedBox(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16),
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  return _buildMovieCard(_movies[index]);
                },
              ),
            ),
            const SizedBox(height: AppSize.s24),
            // Вертикальный список
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
              child: Text(
                'Все премьеры',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSize.s12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p16),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                return _buildListItem(_movies[index]);
              },
            ),
            const SizedBox(height: AppSize.s16),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(Map<String, dynamic> movie) {
    final title = movie['nameRu'] ?? movie['nameEn'] ?? 'Без названия';
    final posterUrl = movie['posterUrl'] ?? '';
    final kinopoiskId = movie['kinopoiskId'] ?? 0;
    final genres = (movie['genres'] as List? ?? [])
        .map((g) => g['genre']?.toString() ?? '')
        .where((g) => g.isNotEmpty)
        .take(2)
        .join(', ');

    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(_getTicketUrl(kinopoiskId));
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Stack(
        children: [
          // Постер
          SizedBox(
            width: double.infinity,
            height: 420,
            child: ImageWithShimmer(
              imageUrl: posterUrl,
              width: double.infinity,
              height: 420,

            ),
          ),
          // Градиент снизу
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black87,
                    Colors.black,
                  ],
                  stops: [0.0, 0.4, 0.8, 1.0],
                ),
              ),
            ),
          ),
          // Текст и кнопка внизу
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (genres.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      genres,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSize.s12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uri =
                        Uri.parse(_getTicketUrl(kinopoiskId));
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      },
                      icon: const Icon(Icons.local_activity_rounded),
                      label: const Text(
                        'Купить билет',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Map<String, dynamic> movie) {
    final title = movie['nameRu'] ?? movie['nameEn'] ?? 'Без названия';
    final posterUrl = movie['posterUrl'] ?? '';
    final kinopoiskId = movie['kinopoiskId'] ?? 0;
    final premiereRu = movie['premiereRu']?.toString() ?? '';
    String dateLabel = '';
    if (premiereRu.isNotEmpty) {
      try {
        final date = DateTime.parse(premiereRu);
        const months = [
          '', 'янв', 'фев', 'мар', 'апр', 'май', 'июн',
          'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
        ];
        dateLabel = '${date.day} ${months[date.month]}';
      } catch (_) {}
    }

    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(_getTicketUrl(kinopoiskId));
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: AppPadding.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dateLabel.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  dateLabel,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                ),
              ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s10),
                child: ImageWithShimmer(
                  imageUrl: posterUrl,
                  width: 150,
                  height: double.infinity,

                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> movie) {
    final title = movie['nameRu'] ?? movie['nameEn'] ?? 'Без названия';
    final posterUrl = movie['posterUrl'] ?? '';
    final kinopoiskId = movie['kinopoiskId'] ?? 0;
    final year = movie['year']?.toString() ?? '';
    final genres = (movie['genres'] as List? ?? [])
        .map((g) => g['genre']?.toString() ?? '')
        .where((g) => g.isNotEmpty)
        .join(', ');
    final premiereRu = movie['premiereRu']?.toString() ?? '';
    String dateLabel = '';
    if (premiereRu.isNotEmpty) {
      try {
        final date = DateTime.parse(premiereRu);
        const months = [
          '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
          'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
        ];
        dateLabel = '${date.day} ${months[date.month]}';
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppPadding.p12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSize.s12),
              bottomLeft: Radius.circular(AppSize.s12),
            ),
            child: ImageWithShimmer(
              imageUrl: posterUrl,
              width: 90,
              height: 130,

            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$year • $genres',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (dateLabel.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Премьера: $dateLabel',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSize.s8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final uri = Uri.parse(_getTicketUrl(kinopoiskId));
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(vertical: AppPadding.p8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s8),
                        ),
                      ),
                      child: const Text('Купить билет'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}