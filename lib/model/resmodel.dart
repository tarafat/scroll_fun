import 'dart:convert';

class Issue {
  final String title;
  final User user;
  final List<Label>? labels;
  final DateTime createdAt;
  final String body;

  Issue({
    required this.title,
    required this.user,
    this.labels,
    required this.createdAt,
    required this.body,
  });

  Issue copyWith({
    String? title,
    User? user,
    List<Label>? labels,
    DateTime? createdAt,
    String? body,
  }) =>
      Issue(
        title: title ?? this.title,
        user: user ?? this.user,
        labels: labels ?? this.labels,
        createdAt: createdAt ?? this.createdAt,
        body: body ?? this.body,
      );

  factory Issue.fromRawJson(String str) => Issue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        title: json["title"],
        user: User.fromJson(json["user"]),
        labels: json["labels"] == null
            ? []
            : List<Label>.from(json["labels"]!.map((x) => Label.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "user": user.toJson(),
        "labels": labels == null
            ? []
            : List<dynamic>.from(labels!.map((x) => x.toJson())),
        "created_at": createdAt.toIso8601String(),
        "body": body,
      };
}

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

class User {
  final String login;

  User({
    required this.login,
  });

  User copyWith({
    String? login,
  }) =>
      User(
        login: login ?? this.login,
      );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        login: json["login"],
      );

  Map<String, dynamic> toJson() => {
        "login": login,
      };
}
