import 'dart:async';
import 'dart:convert';

import 'paginated_response.dart';
import 'package:http/http.dart' as http;

///
class Paginator {
  String url;
  int currentPage = 0;
  bool nextExists = true;

  Paginator(this.url);

  /// Get the next paginated response by [pageIndex].
  ///
  /// Throws an [PaginatorException] the next page doesn't exist
  Future<PaginatedResponse> getNext({int pageIndex}) async {
    if (false == this.nextExists) {
      throw new PaginatorException('No more items');
    }

    if (pageIndex == null) {
      pageIndex = currentPage++;
    } else {
      currentPage = pageIndex;
    }

    String x = this._getUrl(pageIndex: pageIndex);
    print(x);

    var response = await http.get(this._getUrl(pageIndex: pageIndex));

    PaginatedResponse paginatedResponse = _parseResponse(response);

    this.currentPage = paginatedResponse.page;
    this.nextExists = paginatedResponse.page < paginatedResponse.lastPage;

    return paginatedResponse;
  }

  ///
  String _getUrl({int pageIndex}) {
    if (this.url.contains('?')) {
      return this.url + '&page=' + pageIndex.toString();
    }

    return this.url + '?page=' + pageIndex.toString();
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
