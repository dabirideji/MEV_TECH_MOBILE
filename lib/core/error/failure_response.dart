class FailureResponse implements Exception {
  FailureResponse(this.message);

  factory FailureResponse.fromResponse(dynamic response) {
    if (response is Map &&
        response['data'] != null &&
        (response['data'] as Map).containsKey('additionalData')) {
      final data = response['data'] as Map<String, dynamic>;

      final additionalData = data['additionalData'];

      if (additionalData != null && additionalData is List) {
        final messageList = additionalData;

        final buffer = StringBuffer();
        for (var i = 0; i < messageList.length; i++) {
          final map = messageList[i] as Map<String, dynamic>;
          final description = map['description'] ?? '';
          buffer.writeln(description ?? '');
        }
        if (buffer.isNotEmpty) {
          return FailureResponse(buffer.toString());
        } else {
          return FailureResponse(
            (response['responseMessage'] ?? 'Unknown Error') as String,
          );
        }
      } else if (additionalData != null &&
          additionalData is Map &&
          additionalData.containsKey('message')) {
        final message = additionalData['message'];
        return FailureResponse(message.toString());
      } else {
        return FailureResponse(
          (response['responseMessage'] ?? 'Unknown Error') as String,
        );
      }
    } else if (response is Map) {
      return FailureResponse(
        (response['responseMessage'] ?? 'Unknown Error') as String,
      );
    }
    return FailureResponse(response as String);
  }
  final String message;

  @override
  String toString() => message;
}
