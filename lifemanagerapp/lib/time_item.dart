class TimePlannerTask {
  final int minutesDuration;
  final DateTime dateTime;
  final String title;
  final DateTime start;
  final DateTime end;

  TimePlannerTask({
    required this.minutesDuration,
    required this.dateTime,
    required this.title,
    required this.start,
    required this.end,
  });
}
