import 'dart:async';
import 'dart:convert';

import 'paginated_response.dart';
import 'package:http/http.dart' as http;

///
class Paginator {
  String url;

  Paginator(this.url);

  /// Get the next paginated response by [page].
  /// Throws a [PaginatorException] if the next page doesn't exist
  Future<PaginatedResponse> page(int page) async {
    var response = await http.get(
      _getUrl(page),
    );

    PaginatedResponse paginatedResponse = _parseResponse(response);

    return paginatedResponse;
  }

  ///
  String _getUrl(int page) {
    if (url.contains('?')) {
      return url + '&page=' + page.toString();
    }

    return url + '?page=' + page.toString();
  }

  ///
  PaginatedResponse _parseResponse(http.Response response) {
    var parsed = json.decode(response.body);
    var meta = parsed['meta'];
    var data = parsed['data'];
    var links = parsed['links'];

    return new PaginatedResponse(
      data,
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
}
