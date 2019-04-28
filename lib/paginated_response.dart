class PaginatedResponse {
  final List<dynamic> data;
  final String url;
  final int page;
  final int perPage;
  final int lastPage;

  PaginatedResponse(
    this.data,
    this.url,
    this.page,
    this.perPage,
    this.lastPage,
  );
}
