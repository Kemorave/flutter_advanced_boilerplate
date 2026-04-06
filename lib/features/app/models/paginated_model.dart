class PaginatedModel<T> {
  const PaginatedModel({
    required this.currentPage,
    required this.size,
    required this.total,
    required this.items,
  });

  final int currentPage;
  final int size;
  final int total;
  final List<T> items;

  factory PaginatedModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedModel<T>(
      currentPage: json['currentPage'] as int,
      size: json['size'] as int,
      total: json['total'] as int,
      items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'currentPage': currentPage,
      'size': size,
      'total': total,
      'items': items.map(toJsonT).toList(),
    };
  }

  factory PaginatedModel.initial() =>
      PaginatedModel<T>(currentPage: 1, size: 100, total: 0, items: <T>[]);
}
