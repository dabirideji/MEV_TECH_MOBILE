// bottom_sheet_state.dart

class BottomSheetState<T> {
  BottomSheetState({
    this.isLoading = false,
    this.error,
    this.chatUsers = const [],
  });
  final bool isLoading;
  final String? error;
  final List<T> chatUsers;

  BottomSheetState<T> copyWith({
    bool? isLoading,
    String? error,
    List<T>? chatUsers,
  }) {
    return BottomSheetState<T>(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      chatUsers: chatUsers ?? this.chatUsers,
    );
  }
}
