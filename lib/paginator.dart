import 'dart:async';
import 'dart:convert';

import 'paginated_response.dart';
import 'package:http/http.dart' as http;

///
class Paginator {
  String url;
  int currentPage = 0;
  bool nextExists = true;
  Map items;

  Paginator(this.url);

  /// Get the next paginated response (or throw an exception).
  Future<PaginatedResponse> getNext() async {
    if (false == this.nextExists) {
      throw new PaginatorException('No more items');
    }

    var response = await http.get(this._getUrl());

    PaginatedResponse paginatedResponse = _parseResponse(response);

    this.currentPage = paginatedResponse.page;
    this.nextExists = paginatedResponse.page < paginatedResponse.lastPage;

    return paginatedResponse;
  }

  ///
  String _getUrl() {
    Uri uri = Uri.dataFromString(this.url);

    // We override the page with the expected value.
    uri.queryParameters['page'] = (this.currentPage + 1).toString();

    return uri.toString();
  }

  ///
  PaginatedResponse _parseResponse(http.Response response) {
    var parsed = json.decode(response.body);
    var meta = parsed['meta'];
    var data = parsed['data'];
    var links = parsed['link'];

    return new PaginatedResponse(
      Map.from(data),
      links['url'] as String,
      meta['current_page'] as int,
      meta['per_page'] as int,
      meta['last_page'] as int,
    );
  }
}

class PaginatorException implements Exception {
  final String message;

  PaginatorException(this.message);
};
