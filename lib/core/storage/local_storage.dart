import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const sessionBox = 'session_box';
  static const notesBox = 'notes_box';
  static const notificationBox = 'notification_box';
  static const chapterBox = 'chapter_box';
  static const settingsBox = 'settings_box';

  static Future<void> init() async {
    await Future.wait([
      Hive.openBox<dynamic>(sessionBox),
      Hive.openBox<dynamic>(notesBox),
      Hive.openBox<dynamic>(notificationBox),
      Hive.openBox<dynamic>(chapterBox),
      Hive.openBox<dynamic>(settingsBox),
    ]);
  }

  static Box<dynamic> box(String name) => Hive.box<dynamic>(name);
}
