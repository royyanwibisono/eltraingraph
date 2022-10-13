// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/myresponsive.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:xml/xml.dart' as xml;

class TrainList extends StatefulWidget {
  const TrainList({
    Key? key,
  }) : super(key: key);

  @override
  State<TrainList> createState() => TrainListState();
}

class TrainListState extends State<TrainList> {
  // This list will be displayed in the ListView
  List _trains = [];

  // This function will be triggered when the app starts
  void loadData() async {
    final temporaryList = [];

    // Parse XML data
    if (MyStaDat.A != null && MyStaDat.A!.traingraphxml.isNotEmpty) {
      final document = xml.XmlDocument.parse(MyStaDat.A!.traingraphxml);
      final trainsNode = document
          .findElements('jTrainGraph_timetable')
          .first
          .findElements('trains')
          .first;
      final trainA = MyStaDat.selectedIndexTrain > 0
          ? trainsNode.findElements('ta')
          : trainsNode.findElements('ti');
      // loop through the document and extract values
      for (final ta in trainA) {
        final temporaryTimeTable = [];
        final timetable = ta.findElements('t');

        for (final t in timetable) {
          temporaryTimeTable.add({
            'a': t.getAttribute('a'),
            'd': t.getAttribute('d'),
            'at': t.getAttribute('at'),
            'dt': t.getAttribute('dt'),
          });
        }
        temporaryList.add({
          'name': ta.getAttribute("name"),
          "cm": ta.getAttribute("cm"),
          "cl": ta.getAttribute("cl"),
          "sh": ta.getAttribute("sh"),
          "sz": ta.getAttribute("sz"),
          "sy": ta.getAttribute("sy"),
          "d": ta.getAttribute("d"),
          "id": ta.getAttribute("d"),
          't': temporaryTimeTable
        });
      }
    }

    temporaryList
        .sort((a, b) => int.parse(a['id']).compareTo(int.parse(b['id'])));
    // Update the UI
    setState(() {
      _trains = temporaryList;
    });
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
                        ListTile(
                          title: Text("Operation Days: "),
                          subtitle: Container(
                            margin: EdgeInsets.fromLTRB(10, 2, 10, 10),
                            child: createDayOp(_trains[index]),
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

  Widget createDayOp(dynamic d) {
    var opd = d['d'];
    return Container(
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: createCheckDay(opd),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> createCheckDay(String opd) {
    var res = <Widget>[];
    var days = "MTWTFSS";
    if (days.length == opd.length) {
      for (int i = 0; i < opd.length; i++) {
        if (opd[i] == '1') {
          res.add(Flexible(
              flex: 1,
              child: Column(
                children: [
                  Text(days[i]),
                  const Icon(Icons.check_box),
                ],
              )));
        } else {
          res.add(Flexible(
              flex: 1,
              child: Column(
                children: [
                  Text(days[i]),
                  const Icon(Icons.check_box_outline_blank),
                ],
              )));
        }
      }
    }
    return res;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    var _w = MediaQuery.of(context).size.width -
        (MyStaDat.showSideNavBar ? MyResponsive.NAVBARWIDTH : 0);
    _w = _w < 300 ? 300.0 : _w;
    return Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            ListTile(
              title: Text(
                MyStaDat.selectedIndexTrain == 0
                    ? MyStaDat.dirRight
                    : MyStaDat.dirLeft,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.arrow_forward_ios),
            ),
            ...(_w < MyResponsive.PHOTRAITMAX
                ? createColList(1)
                : _w < MyResponsive.PHONEWIDTHMAX
                    ? createColList(2)
                    : _w < MyResponsive.TABLETMAX
                        ? createColList(3)
                        : _w < MyResponsive.HDWIDTH
                            ? createColList(4)
                            : createColList(5))
          ],
        ));
  }
}
