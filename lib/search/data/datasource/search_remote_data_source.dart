import 'package:dio/dio.dart';
import 'package:kinobaza/core/error/exceptions.dart';
import 'package:kinobaza/core/network/api_constants.dart';
import 'package:kinobaza/core/network/error_message_model.dart';
import 'package:kinobaza/search/data/models/search_result_item_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultItemModel>> search(String title);
}

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl(this.dio);

  @override
  Future<List<SearchResultItemModel>> search(String title) async {
    final response = await dio.get(
      ApiConstants.searchPath,
      queryParameters: {'keyword': title},
    );

    if (response.statusCode == 200) {
      // Кинопоиск возвращает список в поле 'films'
      final films = response.data['films'] ?? [];
      return List<SearchResultItemModel>.from(
        (films as List).map((e) => SearchResultItemModel.fromJson(e)),
      );
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }
}