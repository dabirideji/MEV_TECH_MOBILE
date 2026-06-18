enum CrudAction { none, fetch, create, update, delete, paginate }

enum RequestStatus { initial, loading, success, failure }

class Status {
  const Status.initial([CrudAction action = CrudAction.none])
      : this._(action: action, status: RequestStatus.initial);

  const Status._({
    required this.action,
    required this.status,
    this.error,
    this.subtype,
  });

  const Status.loading(CrudAction action, {String? subtype})
      : this._(action: action, status: RequestStatus.loading, subtype: subtype);

  const Status.success(CrudAction action, {String? subtype})
      : this._(action: action, status: RequestStatus.success, subtype: subtype);

  const Status.failure(
      {required CrudAction action, required String error, String? subtype})
      : this._(
          action: action,
          status: RequestStatus.failure,
          error: error,
          subtype: subtype,
        );

  final CrudAction action;
  final RequestStatus status;
  final String? error;
  final String? subtype;

  // General helpers
  bool get isInitial => status == RequestStatus.initial;
  bool get isLoading => status == RequestStatus.loading;
  bool get isSuccess => status == RequestStatus.success;
  bool get isFailure => status == RequestStatus.failure;

  // CRUD-specific loading helpers
  bool get isFetching => action == CrudAction.fetch && isLoading;
  bool get isCreating => action == CrudAction.create && isLoading;
  bool get isUpdating => action == CrudAction.update && isLoading;
  bool get isDeleting => action == CrudAction.delete && isLoading;
  bool get isPaginating => action == CrudAction.paginate && isLoading;

  // CRUD-specific success helpers
  bool get isFetchSuccess => action == CrudAction.fetch && isSuccess;
  bool get isCreateSuccess => action == CrudAction.create && isSuccess;
  bool get isUpdateSuccess => action == CrudAction.update && isSuccess;
  bool get isDeleteSuccess => action == CrudAction.delete && isSuccess;
  bool get isPaginateSuccess => action == CrudAction.paginate && isSuccess;

  // CRUD-specific failure helpers
  bool get isFetchFailure => action == CrudAction.fetch && isFailure;
  bool get isCreateFailure => action == CrudAction.create && isFailure;
  bool get isUpdateFailure => action == CrudAction.update && isFailure;
  bool get isDeleteFailure => action == CrudAction.delete && isFailure;
  bool get isPaginateFailure => action == CrudAction.paginate && isFailure;

  // Custom getters

  bool get hasSubtype => subtype?.isNotEmpty ?? false;
}




// enum Action { none, fetch, create, update, delete }

// class Status {
//   const Status._({
//     required this.action,
//     required this.isLoading,
//     required this.isSuccess,
//     required this.isFailure,
//     required this.error,
//   });

//   // IDLE
//   factory Status.initial([Action action = Action.none]) => Status._(
//         action: action,
//         isLoading: false,
//         isSuccess: false,
//         isFailure: false,
//         error: null,
//       );

//   // LOADING
//   factory Status.loading(Action action) => Status._(
//         action: action,
//         isLoading: true,
//         isSuccess: false,
//         isFailure: false,
//         error: null,
//       );

//   // SUCCESS
//   factory Status.success(Action action) => Status._(
//         action: action,
//         isLoading: false,
//         isSuccess: true,
//         isFailure: false,
//         error: null,
//       );

//   // FAILURE
//   factory Status.failure(Action action, String error) => Status._(
//         action: action,
//         isLoading: false,
//         isSuccess: false,
//         isFailure: true,
//         error: error,
//       );
//   final Action action;
//   final bool isLoading;
//   final bool isSuccess;
//   final bool isFailure;
//   final String? error;

//   // Helper getters
//   bool get isFetching => action == Action.fetch && isLoading;
//   bool get isCreating => action == Action.create && isLoading;
//   bool get isUpdating => action == Action.update && isLoading;
//   bool get isDeleting => action == Action.delete && isLoading;
// }

