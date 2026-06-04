import '../../../core/data/mock_data.dart';

class LogbookService {
  Future<Map<String, dynamic>> fetchSummary() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return mockLogbookJson;
  }
}
