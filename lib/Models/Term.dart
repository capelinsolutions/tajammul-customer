
class Term {
  Term({
    this.offset,
    this.value,
  });

  int? offset;
  String? value;

  factory Term.fromJson(Map<String, dynamic> json) => Term(
    offset: json["offset"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "offset": offset,
    "value": value,
  };
}