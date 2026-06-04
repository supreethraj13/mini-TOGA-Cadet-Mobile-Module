final mockProfileJson = {
  'id': 'cadet-arjun-menon',
  'name': 'Arjun Menon',
  'role': 'Cadet',
  'course': 'PPL',
  'base': 'Chennai',
  'fto': {
    'id': 'fto-airman',
    'name': 'AIRMAN Flight Academy',
    'base': 'Chennai',
  },
  'instructor': {
    'id': 'inst-sharma',
    'name': 'Capt. R. Sharma',
    'rating': 'CFI',
  },
};

final mockDashboardJson = {
  'cadet_name': 'Arjun Menon',
  'course': 'PPL',
  'training_stage': 'Navigation Phase',
  'assigned_fto': 'AIRMAN Flight Academy',
  'assigned_instructor': 'Capt. R. Sharma',
  'overall_study_progress': 64,
  'upcoming_flight': {
    'aircraft': 'Cessna 172',
    'date': '2026-05-18',
    'time': '07:30 AM',
    'lesson': 'Navigation Exercise',
  },
  'logbook': {
    'total_hours': 42.5,
    'solo_hours': 6.2,
    'last_flight': '2026-05-10',
  },
};

final mockSubjectsJson = [
  {
    'id': 'met',
    'subject': 'Meteorology',
    'progress': 72,
    'lessons_completed': 18,
    'total_lessons': 25,
    'quiz_score': 81,
    'status': 'In Progress',
    'chapters': [
      {'id': 'met-1', 'chapter': 'Atmosphere', 'completed': true},
      {'id': 'met-2', 'chapter': 'Pressure Systems', 'completed': true},
      {'id': 'met-3', 'chapter': 'Clouds and Precipitation', 'completed': false},
      {'id': 'met-4', 'chapter': 'Thunderstorms', 'completed': false},
    ],
  },
  {
    'id': 'air-reg',
    'subject': 'Air Regulations',
    'progress': 100,
    'lessons_completed': 30,
    'total_lessons': 30,
    'quiz_score': 92,
    'status': 'Completed',
    'chapters': [
      {'id': 'reg-1', 'chapter': 'Rules of the Air', 'completed': true},
      {'id': 'reg-2', 'chapter': 'Licensing Requirements', 'completed': true},
      {'id': 'reg-3', 'chapter': 'Airspace Classification', 'completed': true},
    ],
  },
  {
    'id': 'nav',
    'subject': 'Navigation',
    'progress': 58,
    'lessons_completed': 14,
    'total_lessons': 24,
    'quiz_score': 76,
    'status': 'In Progress',
    'chapters': [
      {'id': 'nav-1', 'chapter': 'Dead Reckoning', 'completed': true},
      {'id': 'nav-2', 'chapter': 'VOR Tracking', 'completed': true},
      {'id': 'nav-3', 'chapter': 'Flight Planning', 'completed': false},
    ],
  },
  {
    'id': 'tech-gen',
    'subject': 'Technical General',
    'progress': 35,
    'lessons_completed': 7,
    'total_lessons': 20,
    'quiz_score': 69,
    'status': 'In Progress',
    'chapters': [
      {'id': 'tg-1', 'chapter': 'Airframes', 'completed': true},
      {'id': 'tg-2', 'chapter': 'Engines', 'completed': false},
    ],
  },
  {
    'id': 'tech-spec',
    'subject': 'Technical Specific',
    'progress': 0,
    'lessons_completed': 0,
    'total_lessons': 16,
    'quiz_score': 0,
    'status': 'Not Started',
    'chapters': [
      {'id': 'ts-1', 'chapter': 'C172 Systems Overview', 'completed': false},
      {'id': 'ts-2', 'chapter': 'Limitations', 'completed': false},
    ],
  },
  {
    'id': 'air-nav',
    'subject': 'Air Navigation',
    'progress': 44,
    'lessons_completed': 10,
    'total_lessons': 22,
    'quiz_score': 73,
    'status': 'In Progress',
    'chapters': [
      {'id': 'an-1', 'chapter': 'Charts and Symbols', 'completed': true},
      {'id': 'an-2', 'chapter': 'Wind Triangle', 'completed': false},
    ],
  },
  {
    'id': 'rtr',
    'subject': 'RTR / Communication',
    'progress': 18,
    'lessons_completed': 3,
    'total_lessons': 17,
    'quiz_score': 61,
    'status': 'In Progress',
    'chapters': [
      {'id': 'rtr-1', 'chapter': 'Standard Phraseology', 'completed': true},
      {'id': 'rtr-2', 'chapter': 'Emergency Calls', 'completed': false},
    ],
  },
];

final mockLogbookJson = {
  'total_hours': 42.5,
  'dual_hours': 36.3,
  'solo_hours': 6.2,
  'last_flight': '2026-05-10',
  'recent_entries': [
    {
      'id': 'log-1',
      'date': '2026-05-10',
      'aircraft': 'C172',
      'route': 'VOMM - Training Area - VOMM',
      'duration': 1.2,
      'lesson': 'Navigation',
    },
    {
      'id': 'log-2',
      'date': '2026-05-06',
      'aircraft': 'C172',
      'route': 'VOMM - VOTP - VOMM',
      'duration': 1.4,
      'lesson': 'Cross-country prep',
    },
  ],
};

final mockNotificationsJson = [
  {
    'id': 'n1',
    'title': 'Upcoming flight reminder',
    'message': 'Navigation Exercise departs at 07:30 AM on Cessna 172.',
    'type': 'flight',
    'time': '2026-05-17T18:00:00Z',
    'is_read': false,
  },
  {
    'id': 'n2',
    'title': 'Study reminder',
    'message': 'Complete Thunderstorms before your next Meteorology quiz.',
    'type': 'study',
    'time': '2026-05-16T12:30:00Z',
    'is_read': false,
  },
  {
    'id': 'n3',
    'title': 'FTO connection update',
    'message': 'AIRMAN Flight Academy synced your training stage.',
    'type': 'fto',
    'time': '2026-05-15T10:10:00Z',
    'is_read': true,
  },
  {
    'id': 'n4',
    'title': 'Instructor feedback update',
    'message': 'Capt. R. Sharma added feedback on route planning.',
    'type': 'feedback',
    'time': '2026-05-14T09:15:00Z',
    'is_read': false,
  },
  {
    'id': 'n5',
    'title': 'Sync status update',
    'message': 'One offline study note is waiting for Skynet sync.',
    'type': 'sync',
    'time': '2026-05-13T16:45:00Z',
    'is_read': true,
  },
];
