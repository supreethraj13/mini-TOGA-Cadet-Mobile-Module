class LogbookSummary {
  const LogbookSummary({
    required this.totalHours,
    required this.dualHours,
    required this.soloHours,
    required this.lastFlight,
    required this.recentEntries,
  });

  final double totalHours;
  final double dualHours;
  final double soloHours;
  final String lastFlight;
  final List<LogbookEntry> recentEntries;

  factory LogbookSummary.fromJson(Map<String, dynamic> json) => LogbookSummary(
        totalHours: (json['total_hours'] as num).toDouble(),
        dualHours: (json['dual_hours'] as num).toDouble(),
        soloHours: (json['solo_hours'] as num).toDouble(),
        lastFlight: json['last_flight'] as String,
        recentEntries: (json['recent_entries'] as List? ?? const [])
            .map((item) => LogbookEntry.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'total_hours': totalHours,
        'dual_hours': dualHours,
        'solo_hours': soloHours,
        'last_flight': lastFlight,
        'recent_entries': recentEntries.map((entry) => entry.toJson()).toList(),
      };
}

class LogbookEntry {
  const LogbookEntry({
    required this.id,
    required this.date,
    required this.aircraft,
    required this.route,
    required this.duration,
    required this.lesson,
  });

  final String id;
  final String date;
  final String aircraft;
  final String route;
  final double duration;
  final String lesson;

  factory LogbookEntry.fromJson(Map<String, dynamic> json) => LogbookEntry(
        id: json['id'] as String,
        date: json['date'] as String,
        aircraft: json['aircraft'] as String,
        route: json['route'] as String,
        duration: (json['duration'] as num).toDouble(),
        lesson: json['lesson'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'aircraft': aircraft,
        'route': route,
        'duration': duration,
        'lesson': lesson,
      };
}
