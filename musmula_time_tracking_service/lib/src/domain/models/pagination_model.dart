class PaginationModel<T> {
  final int count;
  final int offset;
  final int limit;
  final List<T> items;

  PaginationModel(
      {required this.count,
      required this.offset,
      required this.limit,
      required this.items});
}
