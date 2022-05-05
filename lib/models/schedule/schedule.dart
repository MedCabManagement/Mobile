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

  getTimeString() {
    var seconds = time!;
    var hours = (seconds / 3600).floor();

    seconds -= hours * 3600;

    final minutes = (seconds / 60).floor();
    seconds -= minutes * 60;

    final ampm = hours >= 12 ? "PM" : "AM";

    if (hours > 12) hours -= 12;

    String str = hours.toString().padLeft(2, '0') +
        ':' +
        minutes.toString().padLeft(2, '0');
    return "$str $ampm";
  }

  DateTime toDateTime() {
    var seconds = time!;
    var hours = (seconds / 3600).floor();
    seconds -= hours * 3600;
    final minutes = (seconds / 60).floor();
    seconds -= minutes * 60;

    return DateTime(2022, 1, 1, hours, minutes, seconds);
  }
}
