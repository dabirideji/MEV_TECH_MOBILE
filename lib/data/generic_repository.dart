import 'package:mevtech/core/error/failure_response.dart';
import 'package:mevtech/core/network/api_service.dart';
import 'package:mevtech/data/paginated_model.dart';

class GenericRepository<T> {
  GenericRepository({
    required this.apiService,
    required this.endPoint,
    required this.fromJson,
    this.uri,
  });

  final ApiService apiService;
  final String endPoint;
  final T Function(Map<String, dynamic>) fromJson;
  final Uri? uri;

  Future<PaginatedResponse<T>> getPaginated({
    required int page,
    required int pageSize,
    String token = '',
  }) async {
    final queryParams = {
      'PageNumber': page.toString(),
      'PageSize': pageSize.toString(),
    };

    final result = await apiService.getJsonRequest(
      endPoint,
      queryParams: queryParams,
      token: token,
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as Map<String, dynamic>;

        return PaginatedResponse<T>.fromJson(data, fromJson);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<T>> getAll({
    bool authRequired = true,
    Map<String, dynamic>? queryParams,
    String token = '',
  }) async {
    final result = await apiService.getJsonRequest(
      endPoint,
      authRequired: authRequired,
      queryParams: queryParams,
      token: token,
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<T> getById(
    String id, {
    bool authRequired = true,
    Map<String, dynamic>? queryParams,
    String token = '',
  }) async {
    final result = await apiService.getJsonRequest(
      '$endPoint/$id',
      authRequired: authRequired,
      queryParams: queryParams,
      token: token,
    );

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        return fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> add(
    Map<String, dynamic> jsonData, {
    bool authRequired = true,
  }) async {
    final result = await apiService.postJsonRequest(
      jsonData,
      endPoint,
      authRequired: authRequired,
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<T> addModel(
    Map<String, dynamic> jsonData, {
    bool authRequired = true,
  }) async {
    final result = await apiService.postJsonRequest(
      jsonData,
      endPoint,
      authRequired: authRequired,
    );

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        return fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<T> edit(Map<String, dynamic> jsonData, String id) async {
    final result = await apiService.updateJsonRequest(
      jsonData,
      '$endPoint/$id',
    );

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        return fromJson(data);
      } else if (result is Map && result['status'] == true) {
        final getFromJson = await getById(id);
        return getFromJson;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> remove(String id) async {
    final result = await apiService.deleteJsonRequest(
      '$endPoint/$id',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<T>> getOdata({
    required Uri url,
    bool authRequired = true,
    String token = '',
  }) async {
    final result = await apiService.odataRequest(
      url: url,
      authRequired: authRequired,
      token: token,
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;

        return data.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // Future<String> multipartCreate(Map<String, dynamic> jsonData) async {
  //   final result = await apiService.multipartRequestCreate(
  //     endPoint,
  //     jsonData as CreateCourseRequest,
  //   );

  //   if (result != null) {
  //     if (result is Map && result['status'] == true) {
  //       return result['responseMessage'] as String;
  //     } else {
  //       throw FailureResponse.fromResponse(result);
  //     }
  //   } else {
  //     throw FailureResponse.fromResponse('Unknown');
  //   }
  // }
}
