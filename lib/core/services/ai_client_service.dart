abstract class AiClientService {
  Future<Map<String, dynamic>> sendStructuredRequest({
    required Map<String, dynamic> payload,
  });
}

class PrototypeAiClientService implements AiClientService {
  @override
  Future<Map<String, dynamic>> sendStructuredRequest({
    required Map<String, dynamic> payload,
  }) async {
    return <String, dynamic>{'status': 'prototype-only', 'payload': payload};
  }
}
