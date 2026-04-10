class ApiConstants {
  ApiConstants._();

  static const String baseBackdropUrl = '';
  static const String basePosterUrl = '';
  static const String baseProfileUrl = '';
  static const String baseStillUrl = '';
  static const String baseAvatarUrl = '';
  static const String baseVideoUrl = 'https://www.youtube.com/watch?v=';

  static const String moviePlaceHolder =
      'https://davidkoepp.com/wp-content/themes/blankslate/images/Movie%20Placeholder.jpg';

  static const String castPlaceHolder =
      'https://palmbayprep.org/wp-content/uploads/2015/09/user-icon-placeholder.png';

  static const String avatarPlaceHolder =
      'https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049__480.png';

  static const String stillPlaceHolder =
      'https://popcornsg.s3.amazonaws.com/gallery/1577405144-six-year.png';

  // movies paths
  static String nowPlayingMoviesPath = '/api/v2.2/films';
  static String popularMoviesPath = '/api/v2.2/films/top';
  static String topRatedMoviesPath = '/api/v2.2/films/top';
  static String movieDetailsPath(int id) => '/api/v2.2/films/$id';

  // tv shows paths
  static String onAirTvShowsPath = '/api/v2.2/films';
  static String popularTvShowsPath = '/api/v2.2/films';
  static String topRatedTvShowsPath = '/api/v2.2/films';
  static String tvShowDetailsPath(int id) => '/api/v2.2/films/$id';
  static String seasonDetailsPath({required int id, required int seasonNumber}) =>
      '/api/v2.2/films/$id/seasons';

  // search
  static String searchPath = '/api/v2.1/films/search-by-keyword';

  // каст и отзывы
  static String movieCastPath(int id) => '/api/v1/staff?filmId=$id';
  static String movieReviewsPath(int id) => '/api/v1/reviews?filmId=$id';
  static String similarMoviesPath(int id) => '/api/v2.2/films/$id/similars';

  // Этап 2 — изображения (кадры, постеры, фото со съёмок)
  static String imagesPath(int id) => '/api/v2.2/films/$id/images';

  // Этап 3 — факты и ошибки ("Знаете ли вы...")
  static String factsPath(int id) => '/api/v2.2/films/$id/facts';

  // Этап 4 — сиквелы и приквелы
  static String sequelsAndPrequelsPath(int id) => '/api/v2.1/films/$id/sequels_and_prequels';

  // Этап 6 — бюджет и сборы
  static String boxOfficePath(int id) => '/api/v2.2/films/$id/box_office';

  // Этап 7 — трейлеры и видео
  static String videosPath(int id) => '/api/v2.2/films/$id/videos';

  // Премьеры
  static String premieresPath = '/api/v2.2/films/premieres';

  // Награды
  static String awardsPath(int id) => '/api/v2.2/films/$id/awards';

  // Персоны
  static String personsPath = '/api/v1/persons';
}