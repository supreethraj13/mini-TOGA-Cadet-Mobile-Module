class NotesService {
  int _attempt = 0;

  Future<bool> syncNote(Map<String, dynamic> noteJson) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    _attempt++;
    return _attempt % 3 != 1;
  }
}
