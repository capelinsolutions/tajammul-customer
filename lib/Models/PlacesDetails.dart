// To parse this JSON data, do
//
//     final placesDetails = placesDetailsFromJson(jsonString);

import 'dart:convert';

import 'AddressComponents.dart';
import 'Geometry.dart';
import 'OpeningHours.dart';
import 'Photo.dart';
import 'PlusCode.dart';
import 'Review.dart';

PlacesDetails placesDetailsFromJson(String str) => PlacesDetails.fromJson(json.decode(str));

String placesDetailsToJson(PlacesDetails data) => json.encode(data.toJson());


class PlacesDetails {
  PlacesDetails({
    this.addressComponents,
    this.adrAddress,
    this.businessStatus,
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.internationalPhoneNumber,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.plusCode,
    this.rating,
    this.reference,
    this.reviews,
    this.types,
    this.url,
    this.userRatingsTotal,
    this.utcOffset,
    this.vicinity,
    this.website,
  });

  List<AddressComponent>? addressComponents;
  String? adrAddress;
  String? businessStatus;
  String? formattedAddress;
  String? formattedPhoneNumber;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? internationalPhoneNumber;
  String? name;
  OpeningHours? openingHours;
  List<Photo>? photos;
  String? placeId;
  PlusCode? plusCode;
  double? rating;
  String? reference;
  List<Review>? reviews;
  List<String>? types;
  String? url;
  int? userRatingsTotal;
  int? utcOffset;
  String? vicinity;
  String? website;

  factory PlacesDetails.fromJson(Map<String, dynamic> json) => PlacesDetails(
    addressComponents: List<AddressComponent>.from(json["address_components"]?.map((x) => AddressComponent.fromJson(x)) ?? []),
    adrAddress: json["adr_address"],
    businessStatus: json["business_status"],
    formattedAddress: json["formatted_address"],
    formattedPhoneNumber: json["formatted_phone_number"],
    geometry: Geometry.fromJson(json["geometry"] ?? {}),
    icon: json["icon"],
    iconBackgroundColor: json["icon_background_color"],
    iconMaskBaseUri: json["icon_mask_base_uri"],
    internationalPhoneNumber: json["international_phone_number"],
    name: json["name"],
    openingHours: OpeningHours.fromJson(json["opening_hours"] ?? {}),
    photos: List<Photo>.from(json["photos"]?.map((x) => Photo.fromJson(x)) ?? []),
    placeId: json["place_id"],
    plusCode: PlusCode.fromJson(json["plus_code"] ?? {}),
    rating: json["rating"]?.toDouble(),
    reference: json["reference"],
    reviews: List<Review>.from(json["reviews"]?.map((x) => Review.fromJson(x)) ?? []),
    types: List<String>.from(json["types"]?.map((x) => x) ?? []),
    url: json["url"],
    userRatingsTotal: json["user_ratings_total"],
    utcOffset: json["utc_offset"],
    vicinity: json["vicinity"],
    website: json["website"],
  );

  Map<String, dynamic> toJson() => {
    "address_components": List<dynamic>.from(addressComponents?.map((x) => x.toJson()) ?? []),
    "adr_address": adrAddress,
    "business_status": businessStatus,
    "formatted_address": formattedAddress,
    "formatted_phone_number": formattedPhoneNumber,
    "geometry": geometry?.toJson(),
    "icon": icon,
    "icon_background_color": iconBackgroundColor,
    "icon_mask_base_uri": iconMaskBaseUri,
    "international_phone_number": internationalPhoneNumber,
    "name": name,
    "opening_hours": openingHours?.toJson(),
    "photos": List<dynamic>.from(photos?.map((x) => x.toJson()) ?? []),
    "place_id": placeId,
    "plus_code": plusCode?.toJson(),
    "rating": rating,
    "reference": reference,
    "reviews": List<dynamic>.from(reviews?.map((x) => x.toJson()) ?? []),
    "types": List<dynamic>.from(types?.map((x) => x) ?? []),
    "url": url,
    "user_ratings_total": userRatingsTotal,
    "utc_offset": utcOffset,
    "vicinity": vicinity,
    "website": website,
  };
}


















