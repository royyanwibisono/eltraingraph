import 'dart:convert';

import 'package:eltraingraph/mystaticdata.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyStFunc {
  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static String TODtoStr(TimeOfDay tod) {
    return '${tod.hour.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay timeOfDayParse(String s) {
    if (s.contains(':')) {
      return TimeOfDay(
          hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));
    } else {
      return TimeOfDay(hour: 0, minute: 0);
    }
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
    var dayIndex = [];
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
        dayIndex.add(i);
        flags.add(d[i] == '1');
      }
    }
    return [n, retDay, flags, dayIndex];
  }

  static Future<void> saveFile(context) async {
    if (MyStaDat.D != null && MyStaDat.D!.document != null) {
      MyStaDat.D!.updateDocument();
      String source = MyStaDat.D!.document!.toXmlString(pretty: true);
      List<int> list = utf8.encode(source);
      Uint8List bytes = Uint8List.fromList(list);
      await FileSaver.instance
          .saveFile("Eltraingraph.xml", bytes, 'xml', mimeType: MimeType.OTHER);
      showMyDialog(context, "Info", "File saved!");
    }
  }

  static Future<void> showMyDialog(
      dynamic context, String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
