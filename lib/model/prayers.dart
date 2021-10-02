import 'dart:convert';

class Prayer {
  String title;
  String description;
  int date;
  bool checked;
  int lastCheck;
  int previousCheck;
  int count;
  Prayer({
    required this.title,
    required this.description,
    required this.date,
    required this.checked,
    required this.lastCheck,
    required this.previousCheck,
    required this.count,
  });

  Prayer copyWith({
    String? title,
    String? description,
    int? date,
    bool? checked,
    int? lastCheck,
    int? previousCheck,
    int? count,
  }) {
    return Prayer(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      checked: checked ?? this.checked,
      lastCheck: lastCheck ?? this.lastCheck,
      previousCheck: previousCheck ?? this.previousCheck,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'checked': checked,
      'lastCheck': lastCheck,
      'previousCheck': previousCheck,
      'count': count,
    };
  }

  factory Prayer.fromMap(Map<String, dynamic> map) {
    return Prayer(
      title: map['title'],
      description: map['description'],
      date: map['date'],
      checked: map['checked'],
      lastCheck: map['lastCheck'],
      previousCheck: map['previousCheck'],
      count: map['count'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Prayer.fromJson(String source) => Prayer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Prayer(title: $title, description: $description, date: $date, checked: $checked, lastCheck: $lastCheck, previousCheck: $previousCheck, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Prayer &&
        other.title == title &&
        other.description == description &&
        other.date == date &&
        other.checked == checked &&
        other.lastCheck == lastCheck &&
        other.previousCheck == previousCheck &&
        other.count == count;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        checked.hashCode ^
        lastCheck.hashCode ^
        previousCheck.hashCode ^
        count.hashCode;
  }
}
