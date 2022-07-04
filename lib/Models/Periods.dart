
import 'Close.dart';

class Period {
  Period({
    this.close,
    this.open,
  });

  Close? close;
  Close? open;

  factory Period.fromJson(Map<String, dynamic> json) => Period(
    close: Close.fromJson(json["close"] ?? {}),
    open: Close.fromJson(json["open"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "close": close?.toJson(),
    "open": open?.toJson(),
  };
}