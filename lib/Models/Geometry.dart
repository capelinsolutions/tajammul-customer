
import 'package:tajammul_customer_app/Models/Location.dart';

import 'Viewport.dart';

class Geometry {
  Geometry({
    this.location,
    this.viewport,
  });

  Location? location;
  Viewport? viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"] ?? {}),
    viewport: Viewport.fromJson(json["viewport"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "location": location?.toJson(),
    "viewport": viewport?.toJson(),
  };
}