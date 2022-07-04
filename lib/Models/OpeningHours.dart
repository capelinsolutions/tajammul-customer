
import 'Periods.dart';

class OpeningHours {
  OpeningHours({
    this.openNow,
    this.periods,
    this.weekdayText,
  });

  bool? openNow;
  List<Period>? periods;
  List<String>? weekdayText;

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
    openNow: json["open_now"],
    periods: List<Period>.from(json["periods"]?.map((x) => Period.fromJson(x)) ?? []),
    weekdayText: List<String>.from(json["weekday_text"]?.map((x) => x) ?? []),
  );

  Map<String, dynamic> toJson() => {
    "open_now": openNow,
    "periods": List<dynamic>.from(periods?.map((x) => x.toJson()) ?? []),
    "weekday_text": List<dynamic>.from(weekdayText?.map((x) => x) ?? []),
  };
}
