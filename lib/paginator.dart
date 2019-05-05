import 'dart:async';
import 'dart:convert';

import 'paginated_response.dart';
import 'package:http/http.dart' as http;

///
class Paginator {
  Uri _uri;

  Paginator(Uri uri) {
    this._uri = _cleanUri(uri);
  }

  /// Get the next paginated response by [page].
  /// Throws a [PaginatorException] if the next page doesn't exist
  Future<PaginatedResponse> page(int page) async {
    var response = await http.get(
      _getUri(page),
    );

    PaginatedResponse paginatedResponse = _parseResponse(response);

    return paginatedResponse;
  }

  ///
  Uri _getUri(int page) {
    Map<String, dynamic> query = Map.from(_uri.queryParameters);

    query['page'] = page.toString();

    return _uri.replace(
      queryParameters: query
    );
  }

  Uri _cleanUri(uri) {
    Map<String, dynamic> query = Map.from(uri.queryParameters);

    /// Remove any page parameters from the Uri.
    query.remove('page');

    return uri.replace(queryParameters: query);
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
