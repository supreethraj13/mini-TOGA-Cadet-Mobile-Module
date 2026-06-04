import '../../../core/errors/app_error.dart';

class DashboardModel {
  DashboardModel({
    required this.cadetName,
    required this.course,
    required this.trainingStage,
    required this.assignedFto,
    required this.assignedInstructor,
    required this.overallStudyProgress,
    required this.upcomingFlight,
    required this.logbook,
  }) {
    if (overallStudyProgress < 0 || overallStudyProgress > 100) {
      throw AppError('Dashboard study progress must stay between 0 and 100.');
    }
  }

  final String cadetName;
  final String course;
  final String trainingStage;
  final String assignedFto;
  final String assignedInstructor;
  final int overallStudyProgress;
  final UpcomingFlight upcomingFlight;
  final DashboardLogbook logbook;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        cadetName: json['cadet_name'] as String,
        course: json['course'] as String,
        trainingStage: json['training_stage'] as String,
        assignedFto: json['assigned_fto'] as String,
        assignedInstructor: json['assigned_instructor'] as String,
        overallStudyProgress: json['overall_study_progress'] as int,
        upcomingFlight: UpcomingFlight.fromJson(Map<String, dynamic>.from(json['upcoming_flight'] as Map)),
        logbook: DashboardLogbook.fromJson(Map<String, dynamic>.from(json['logbook'] as Map)),
      );

  Map<String, dynamic> toJson() => {
        'cadet_name': cadetName,
        'course': course,
        'training_stage': trainingStage,
        'assigned_fto': assignedFto,
        'assigned_instructor': assignedInstructor,
        'overall_study_progress': overallStudyProgress,
        'upcoming_flight': upcomingFlight.toJson(),
        'logbook': logbook.toJson(),
      };
}

class UpcomingFlight {
  const UpcomingFlight({
    required this.aircraft,
    required this.date,
    required this.time,
    required this.lesson,
  });

  final String aircraft;
  final String date;
  final String time;
  final String lesson;

  factory UpcomingFlight.fromJson(Map<String, dynamic> json) => UpcomingFlight(
        aircraft: json['aircraft'] as String,
        date: json['date'] as String,
        time: json['time'] as String,
        lesson: json['lesson'] as String,
      );

  Map<String, dynamic> toJson() => {
        'aircraft': aircraft,
        'date': date,
        'time': time,
        'lesson': lesson,
      };
}

class DashboardLogbook {
  const DashboardLogbook({
    required this.totalHours,
    required this.soloHours,
    required this.lastFlight,
  });

  final double totalHours;
  final double soloHours;
  final String lastFlight;

  factory DashboardLogbook.fromJson(Map<String, dynamic> json) => DashboardLogbook(
        totalHours: (json['total_hours'] as num).toDouble(),
        soloHours: (json['solo_hours'] as num).toDouble(),
        lastFlight: json['last_flight'] as String,
      );

  Map<String, dynamic> toJson() => {
        'total_hours': totalHours,
        'solo_hours': soloHours,
        'last_flight': lastFlight,
      };
}
