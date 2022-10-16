import 'package:flutter/material.dart';

class MyStFunc {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static List getCountValidDay(String d) {
    int n = 0;
    int si = -1;
    var days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    var retDay = <String>[];
    var flags = <bool>[];
    for (int i = 0; i < days.length; i++) {
      if (d[i] == '1') {
        if (si < 0) {
          n = 1;
          si = i;
        } else {
          n = i - si + 1;
        }
      }
      if (si >= 0) {
        retDay.add(days[i]);
        flags.add(d[i] == '1');
      }
    }
    return [n, retDay, flags];
  }
}
