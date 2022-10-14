import 'package:eltraingraph/expanded_widget.dart';
import 'package:eltraingraph/multiplication_table.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:flutter/material.dart';

class Schedules extends ExpandedSTF {
  const Schedules({
    Key? key,
    bool isExpand = false,
  }) : super(key: key, isExpand: isExpand);

  @override
  State<ExpandedSTF> createState() => SchedulesState();
}

class SchedulesState extends ExpandedSTFState {
  var data = <List<String>>[];

  @override
  void loadData() {
    var _data = createData();
    setState(() {
      data = _data;
    });
  }

  List<List<String>> createData() {
    var ret = <List<String>>[];

    var header = <String>[];
    header.add(
      "Train",
    );
    if (MyStaDat.A != null && MyStaDat.A!.stationlist != null) {
      var stationList = MyStaDat.selectedIndexTrain > 0
          ? MyStaDat.A!.stationlist!.reversed.toList()
          : MyStaDat.A!.stationlist!;

      if (stationList.length >= 2) {
        MyStaDat.dirRight =
            "Trains from ${MyStaDat.A!.stationlist!.first['name']} heading to ${MyStaDat.A!.stationlist!.last['name']}";
        MyStaDat.dirLeft =
            "Trains from ${MyStaDat.A!.stationlist!.last['name']} heading to ${MyStaDat.A!.stationlist!.first['name']}";
      }

      for (var i = 0; i < stationList.length; i++) {
        header.add(
          stationList[i]['name'] + " arr",
        );
        header.add(
          stationList[i]['name'] + " dep",
        );
      }
    }

    ret.add(header);

    if (MyStaDat.selectedIndexTrain > 0) {
      if (MyStaDat.A != null && MyStaDat.A!.trainlistA != null) {
        final ta = MyStaDat.A!.trainlistA!;
        for (var i = 0; i < ta.length; i++) {
          var res = <String>[];
          res.add(
            ta[i]['name'],
          );
          //reverse timetable
          var tt = (ta[i]['t'] as List).reversed.toList();
          for (var j = 0; j < tt.length; j++) {
            var mapdata = Map<String, String>.from(tt[j]);
            res.add(
              mapdata['a']!,
            );
            res.add(
              mapdata['d']!,
            );
          }
          ret.add(res);
        }
      }
    } else {
      if (MyStaDat.A != null && MyStaDat.A!.trainlistI != null) {
        final ti = MyStaDat.A!.trainlistI!;
        for (var i = 0; i < ti.length; i++) {
          var res = <String>[];
          res.add(
            ti[i]['name'],
          );
          var tt = ti[i]['t'] as List;
          for (var j = 0; j < tt.length; j++) {
            var mapdata = Map<String, String>.from(tt[j]);
            res.add(
              mapdata['a']!,
            );
            res.add(
              mapdata['d']!,
            );
          }
          ret.add(res);
        }
      }
    }
    return ret;
  }

  @override
  getTitle() {
    var text = Text(
      MyStaDat.selectedIndexTrain == 0 ? MyStaDat.dirRight : MyStaDat.dirLeft,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
    if (widget.isExpand) {
      return text;
    } else {
      return [
        const SizedBox(height: 15),
        ListTile(
          title: text,
          leading: const Icon(Icons.arrow_forward_ios),
        ),
      ];
    }
  }

  @override
  getChild() {
    var cellWidth = MyStaDat.tableCellSize.width;
    var cellHeight = MyStaDat.tableCellSize.height;
    var container = SizedBox(
      // margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: data.isNotEmpty ? data[0].length * cellWidth : 0,
      height: data.length * cellHeight,
      child: data.isNotEmpty
          ? MultiplicationTable(
              data: data, width: cellWidth, height: cellHeight)
          : const Center(
              child: Text("loading data..."),
            ),
    );
    if (widget.isExpand) {
      return container;
    }
    return [
      container,
    ];
  }
}
