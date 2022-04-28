class Schedule {
  String? id;
  List<String>? days;
  int? time;

  Schedule({required this.id, required this.days, required this.time});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
        id: json['_id'],
        days: (json['days'] as List<dynamic>).map((e) => e.toString()).toList(),
        time: json['time']);
  }
}
