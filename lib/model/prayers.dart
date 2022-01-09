import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:prayer_list/model/historyobj.dart';

class Prayer {
  String title;
  String description;
  int date;
  bool checked;
  int lastCheck;
  int previousCheck;
  int count;
  List<HistoryObj> history = [];
  Prayer({
    required this.title,
    required this.description,
    required this.date,
    required this.checked,
    required this.lastCheck,
    required this.previousCheck,
    required this.count,
    required this.history,
  });

  Prayer copyWith({
    String? title,
    String? description,
    int? date,
    bool? checked,
    int? lastCheck,
    int? previousCheck,
    int? count,
    List<HistoryObj>? history,
  }) {
    return Prayer(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      checked: checked ?? this.checked,
      lastCheck: lastCheck ?? this.lastCheck,
      previousCheck: previousCheck ?? this.previousCheck,
      count: count ?? this.count,
      history: history ?? this.history,
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
      'history': history.map((x) => x.toMap()).toList(),
    };
  }

  factory Prayer.fromMap(Map<String, dynamic> map) {
    return Prayer(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date']?.toInt() ?? 0,
      checked: map['checked'] ?? false,
      lastCheck: map['lastCheck']?.toInt() ?? 0,
      previousCheck: map['previousCheck']?.toInt() ?? 0,
      count: map['count']?.toInt() ?? 0,
      history: List<HistoryObj>.from(
          map['history']?.map((x) => HistoryObj.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Prayer.fromJson(String source) => Prayer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Prayer(title: $title, description: $description, date: $date, checked: $checked, lastCheck: $lastCheck, previousCheck: $previousCheck, count: $count, history: $history)';
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
        other.count == count &&
        listEquals(other.history, history);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        checked.hashCode ^
        lastCheck.hashCode ^
        previousCheck.hashCode ^
        count.hashCode ^
        history.hashCode;
  }
}
