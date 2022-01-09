// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:prayer_list/convert.dart';
import 'package:prayer_list/main.dart';
import 'package:prayer_list/model/historyobj.dart';
import 'package:prayer_list/screens/home_screen.dart';

class Checkmark with ChangeNotifier {
  bool _check = false;
  int _count = 0;

  bool get check => _check;
  int get count => _count;

  common() {
    notifyListeners();
    HapticFeedback.vibrate();
    saveData();
  }

  void addCount(int i) {
    _count = prayers[i].count++;

    HistoryObj _historyOBJ = HistoryObj(
      date: Convert().dateTimeToInt(
        DateTime.now(),
      ),
      count: prayers[i].count,
    );

    prayers[i].history.add(_historyOBJ);
  }

  void subtractCount(int i) {
    if (prayers[i].count > 0) {
      _count = prayers[i].count--;

      HistoryObj _historyOBJ = HistoryObj(
        date: Convert().dateTimeToInt(
          DateTime.now(),
        ),
        count: prayers[i].count,
      );

      prayers[i].history.add(_historyOBJ);
    }
  }

  void checkToggle(int i) {
    print("${i.toString()} is now ${_check.toString()}");

    if (prayers[i].checked == false) {
      addCount(i);
      prayers[i].checked = true;
      _check = prayers[i].checked;
    } else {
      subtractCount(i);
      prayers[i].checked = false;
      _check = prayers[i].checked;
    }

    common();
  }
}
