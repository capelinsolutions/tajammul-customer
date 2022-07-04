// To parse this JSON data, do
//
//     final places = placesFromJson(jsonString);

import 'dart:convert';

import 'MatchedSubstring.dart';
import 'StructuredFormatting.dart';
import 'Term.dart';

List<Places> placesFromJson(String str) => List<Places>.from(json.decode(str).map((x) => Places.fromJson(x)));

String placesToJson(List<Places> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Places {
  Places({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
  });

  String? description;
  List<MatchedSubstring>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Term>? terms;
  List<String>? types;

  factory Places.fromJson(Map<String, dynamic> json) => Places(
    description: json["description"],
    matchedSubstrings: List<MatchedSubstring>.from(json["matched_substrings"].map((x) => MatchedSubstring.fromJson(x))),
    placeId: json["place_id"],
    reference: json["reference"],
    structuredFormatting: StructuredFormatting.fromJson(json["structured_formatting"] ?? {}),
    terms: List<Term>.from(json["terms"].map((x) => Term.fromJson(x))),
    types: List<String>.from(json["types"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "matched_substrings": List<dynamic>.from(matchedSubstrings?.map((x) => x.toJson())??[]),
    "place_id": placeId,
    "reference": reference,
    "structured_formatting": structuredFormatting?.toJson(),
    "terms": List<dynamic>.from(terms?.map((x) => x.toJson())?? []),
    "types": List<dynamic>.from(types?.map((x) => x)?? []),
  };
}





