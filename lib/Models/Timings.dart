// To parse this JSON data, do
//
//     final timings = timingsFromJson(jsonString);

import 'dart:convert';

Timings timingsFromJson(String str) => Timings.fromJson(json.decode(str));

String timingsToJson(Timings data) => json.encode(data.toJson());

class Timings {
  Timings({
    this.timings,
  });

  Days? timings;

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
    timings: Days.fromJson(json["timings"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "timings": timings?.toJson(),
  };

  factory Timings.clone(Timings timings) {
    return Timings(
        timings: Days.clone(timings.timings!)
    );
  }

}

class Days {
  Days({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  List<TimeObj>? monday;
  List<TimeObj>? tuesday;
  List<TimeObj>? wednesday;
  List<TimeObj>? thursday;
  List<TimeObj>? friday;
  List<TimeObj>? saturday;
  List<TimeObj>? sunday;

  factory Days.fromJson(Map<String, dynamic> json) => Days(
    monday: List<TimeObj>.from(json["monday"]?.map((x) => TimeObj.fromJson(x)) ?? []),
    tuesday: List<TimeObj>.from(json["tuesday"]?.map((x) => TimeObj.fromJson(x)) ?? []),
    wednesday: List<TimeObj>.from(json["wednesday"]?.map((x) => TimeObj.fromJson(x)) ?? []),
    thursday: List<TimeObj>.from(json["thursday"]?.map((x) => TimeObj.fromJson(x)) ?? []),
    friday: List<TimeObj>.from(json["friday"]?.map((x) => TimeObj.fromJson(x)) ?? []),
    saturday: List<TimeObj>.from(json["saturday"]?.map((x) => TimeObj.fromJson(x)) ?? []),
    sunday: List<TimeObj>.from(json["sunday"]?.map((x) => TimeObj.fromJson(x)) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "monday": List<TimeObj>.from(monday?.map((x) => x.toJson()) ?? []),
    "tuesday": List<TimeObj>.from(tuesday?.map((x) => x.toJson()) ?? []),
    "wednesday": List<TimeObj>.from(wednesday?.map((x) => x.toJson())?? []),
    "thursday": List<TimeObj>.from(thursday?.map((x) => x.toJson())?? []),
    "friday": List<TimeObj>.from(friday?.map((x) => x.toJson())?? []),
    "saturday": List<TimeObj>.from(saturday?.map((x) => x.toJson())?? []),
    "sunday": List<TimeObj>.from(sunday?.map((x) => x.toJson())?? []),
  };

  factory Days.clone(Days days) {
    return Days(
        monday: days.monday,
        tuesday: days.tuesday,
        wednesday: days.wednesday,
        thursday: days.thursday,
        friday: days.friday,
        saturday: days.saturday,
        sunday: days.sunday
    );
  }
}

class TimeObj {
  TimeObj({
    this.startTime,
    this.endTime,
  });

  String? startTime;
  String? endTime;

  factory TimeObj.fromJson(Map<String, dynamic> json) => TimeObj(
    startTime: json["startTime"],
    endTime: json["endTime"],
  );

  Map<String, dynamic> toJson() => {
    "startTime": startTime,
    "endTime": endTime,
  };

  factory TimeObj.clone(TimeObj timeObj) {
    return TimeObj(
        startTime: timeObj.startTime,
        endTime: timeObj.endTime
    );
  }
}