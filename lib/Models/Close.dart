
class Close {
  Close({
    this.day,
    this.time,
  });

  int? day;
  String? time;

  factory Close.fromJson(Map<String, dynamic> json) => Close(
    day: json["day"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "time": time,
  };
}