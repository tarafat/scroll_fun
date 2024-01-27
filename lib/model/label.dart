import 'dart:convert';

class Label {
  final String? name;
  final String? color;

  Label({
    this.name,
    this.color,
  });

  Label copyWith({
    String? name,
    String? color,
  }) =>
      Label(
        name: name ?? this.name,
        color: color ?? this.color,
      );

  factory Label.fromRawJson(String str) => Label.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        name: json["name"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "color": color,
      };
}
