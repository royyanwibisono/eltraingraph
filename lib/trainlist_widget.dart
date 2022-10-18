// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:eltraingraph/expanded_widget.dart';
import 'package:eltraingraph/myresponsive.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:flutter/material.dart';

class TrainList extends ExpandedSTF {
  const TrainList({
    Key? key,
    bool isExpand = false,
  }) : super(key: key, isExpand: isExpand);

  @override
  State<ExpandedSTF> createState() => TrainListState();
}

class TrainListState extends ExpandedSTFState {
  // This list will be displayed in the ListView
  List _trains = [];

  // This function will be triggered when the app starts
  @override
  void loadData() {
    if (MyStaDat.A != null && MyStaDat.A!.stationlist != null) {
      final stationList = MyStaDat.A!.stationlist!;
      if (stationList.length >= 2) {
        MyStaDat.dirRight =
            "Trains from ${MyStaDat.A!.stationlist!.first['name']} heading to ${MyStaDat.A!.stationlist!.last['name']}";
        MyStaDat.dirLeft =
            "Trains from ${MyStaDat.A!.stationlist!.last['name']} heading to ${MyStaDat.A!.stationlist!.first['name']}";
      }
    }
    if (MyStaDat.selectedIndexTrain > 0) {
      if (MyStaDat.A != null && MyStaDat.A!.trainlistA != null) {
        final trainlist = MyStaDat.A!.trainlistA!;

        setState(() {
          _trains = trainlist;
        });
      }
    } else {
      if (MyStaDat.A != null && MyStaDat.A!.trainlistI != null) {
        final trainlist = MyStaDat.A!.trainlistI!;

        setState(() {
          _trains = trainlist;
        });
      }
    }
  }

  List<Row> createColList(int colCount) {
    var res = <Row>[];
    for (var i = 0; i < _trains.length; i += colCount) {
      List<Widget> _row = <Widget>[];
      for (var j = 0; j < colCount; j++) {
        int index = i + j;
        if (index < _trains.length) {
          _row.add(Flexible(
            flex: 1,
            child: SafeArea(
              child: Card(
                child: Container(
                    constraints: BoxConstraints(minHeight: 100),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(_trains[index]['name']),
                          subtitle: Text("- ${_trains[index]['cm']}"),
                          trailing: Icon(Icons.info),
                        ),
                        Container(
                          height: 1.0,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          color: Colors.grey,
                        ),
                        CheckboxListTile(
                            title: const Text("Show in train graph."),
                            value: _trains[index]['sh'] == 'true',
                            onChanged: (value) {
                              setState(() {
                                _trains[index]['sh'] =
                                    value! ? 'true' : 'false';
                              });
                            }),
                        ListTile(
                          title: Text("Operation Days: "),
                          subtitle: Container(
                            margin: EdgeInsets.fromLTRB(10, 2, 10, 10),
                            child: createDayOp(index),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ));
        } else {
          _row.add(Flexible(
            flex: 1,
            child: Container(),
          ));
        }
      }
      res.add(
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: _row));
    }

    return res;
  }

  Widget createDayOp(index) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: createCheckDay(index),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> createCheckDay(index) {
    var opd = _trains[index]['d'];
    var res = <Widget>[];
    var days = "MTWTFSS";
    if (days.length == opd.length) {
      for (int i = 0; i < opd.length; i++) {
        res.add(Flexible(
            flex: 1,
            child: Column(
              children: [
                Text(days[i]),
                Checkbox(
                    value: opd[i] == '1',
                    onChanged: (value) {
                      var s = (_trains[index]['d'] as String)
                          .replaceRange(i, i + 1, value! ? '1' : '0');
                      print(s);
                      setState(() {
                        _trains[index]['d'] = s;
                      });
                    }),
              ],
            )));
      }
    }
    return res;
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
      bool isMobile = MediaQuery.of(context).size.width -
              (MyStaDat.showSideNavBar ? 0 : MyResponsive.NAVBARWIDTH) <
          MyResponsive.PHONEWIDTHMAX;
      return [
        const SizedBox(height: 15),
        ListTile(
          title: text,
          leading: isMobile ? null : const Icon(Icons.arrow_forward_ios),
        ),
      ];
    }
  }

  @override
  getChild() {
    var _w = MediaQuery.of(context).size.width -
        (MyStaDat.showSideNavBar ? MyResponsive.NAVBARWIDTH : 0);
    _w = _w < 300 ? 300.0 : _w;
    if (widget.isExpand) {
      return ListView(
        children: [
          ...(_w < MyResponsive.PHOTRAITMAX
              ? createColList(1)
              : _w < MyResponsive.PHONEWIDTHMAX
                  ? createColList(2)
                  : _w < MyResponsive.TABLETMAX
                      ? createColList(3)
                      : _w < MyResponsive.HDWIDTH
                          ? createColList(4)
                          : createColList(5)),
          const SizedBox(
            height: 100,
          ),
        ],
      );
    } else {
      return (_w < MyResponsive.PHOTRAITMAX
          ? createColList(1)
          : _w < MyResponsive.PHONEWIDTHMAX
              ? createColList(2)
              : _w < MyResponsive.TABLETMAX
                  ? createColList(3)
                  : _w < MyResponsive.HDWIDTH
                      ? createColList(4)
                      : createColList(5));
    }
  }
}
