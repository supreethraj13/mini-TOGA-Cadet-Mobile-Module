import '../models/logbook_summary.dart';
import 'logbook_service.dart';

class LogbookRepository {
  LogbookRepository(this._service);

  final LogbookService _service;

  Future<LogbookSummary> fetchSummary() async {
    final json = await _service.fetchSummary();
    return LogbookSummary.fromJson(json);
  }
}
