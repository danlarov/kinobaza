import 'package:dartz/dartz.dart';
import 'package:kinobaza/core/error/failure.dart';
import 'package:kinobaza/search/domain/entities/search_result_item.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<SearchResultItem>>> search(String title);
}
