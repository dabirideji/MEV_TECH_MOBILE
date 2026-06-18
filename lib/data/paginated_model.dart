class PaginatedResponse<T> {
  PaginatedResponse({
    required this.pageNumber,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
    required this.result,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse(
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      totalRecords: json['totalRecords'] as int,
      totalPages: json['totalPages'] as int,
      result: (json['result'] as List)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
  final int pageNumber;
  final int pageSize;
  final int totalRecords;
  final int totalPages;
  final List<T> result;
}

///  ==================== CourseContentCommentModel
