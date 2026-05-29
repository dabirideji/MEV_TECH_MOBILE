class StatusState {
  StatusState({
    this.isLoading = false,
    this.error,
    this.success = '',
    // this.data = const [],
  });
  final bool isLoading;
  final String? error;
  final String success;
  // final List<T> data;

  StatusState copyWith({
    bool? isLoading,
    String? error,
    String? success,
    // List<T>? data,
  }) {
    return StatusState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      success: success ?? this.success,
      // data: data ?? this.data,
    );
  }
}
