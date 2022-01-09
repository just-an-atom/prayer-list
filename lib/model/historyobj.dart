import 'dart:convert';

class HistoryObj {
  int date;
  int count;
  HistoryObj({
    required this.date,
    required this.count,
  });

  HistoryObj copyWith({
    int? date,
    int? count,
  }) {
    return HistoryObj(
      date: date ?? this.date,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'count': count,
    };
  }

  factory HistoryObj.fromMap(Map<String, dynamic> map) {
    return HistoryObj(
      date: map['date']?.toInt() ?? 0,
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryObj.fromJson(String source) =>
      HistoryObj.fromMap(json.decode(source));

  @override
  String toString() => 'HistoryObj(date: $date, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HistoryObj && other.date == date && other.count == count;
  }

  @override
  int get hashCode => date.hashCode ^ count.hashCode;
}
