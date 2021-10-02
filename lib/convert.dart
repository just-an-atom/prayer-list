class Convert {
  int dateTimeToInt(DateTime _fullDate) {
    int _date;

    _date = _fullDate.millisecondsSinceEpoch;

    return _date;
  }

  DateTime fromIntToDateTime(int _epoch) {
    DateTime _date = DateTime.fromMillisecondsSinceEpoch(_epoch);
    return _date;
  }
}
