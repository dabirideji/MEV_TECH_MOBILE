enum RequestStatus { initial, loading, success, failure }

class RequestState {
  const RequestState.initial() : this._(status: RequestStatus.initial);

  const RequestState._({
    required this.status,
    this.error,
  });
  const RequestState.loading() : this._(status: RequestStatus.loading);
  const RequestState.success() : this._(status: RequestStatus.success);
  const RequestState.failure(String error)
      : this._(status: RequestStatus.failure, error: error);

  final RequestStatus status;
  final String? error;

  bool get isInitial => status == RequestStatus.initial;
  bool get isLoading => status == RequestStatus.loading;
  bool get isSuccess => status == RequestStatus.success;
  bool get isFailure => status == RequestStatus.failure;
}
