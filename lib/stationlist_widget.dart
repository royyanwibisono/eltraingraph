import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/myresponsive.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_tags/flutter_tags.dart';

class StationList extends StatefulWidget {
  const StationList({
    Key? key,
  }) : super(key: key);

  @override
  State<StationList> createState() => StationListState();
}

class StationListState extends State<StationList> {
  // This list will be displayed in the ListView
  List _stations = [];

  // This function will be triggered when the app starts
  void _loadData() async {
    if (MyStaDat.A != null && MyStaDat.A!.traingraphxml.isNotEmpty) {
      final document = xml.XmlDocument.parse(MyStaDat.A!.traingraphxml);
      final temporaryList = MyStaDat.loadStation(document);
      final stationList = MyStaDat.loadStation(document);
      if (stationList.length >= 2) {
        MyStaDat.dirRight =
            "Trains from ${stationList.first['name']} heading to ${stationList.last['name']}";
        MyStaDat.dirLeft =
            "Trains from ${stationList.last['name']} heading to ${stationList.first['name']}";
      }

      // Update the UI
      setState(() {
        _stations = temporaryList;
      });
    }
  }

  List<Row> createColList(int colCount) {
    var res = <Row>[];
    for (var i = 0; i < _stations.length; i += colCount) {
      List<Widget> _row = <Widget>[];
      for (var j = 0; j < colCount; j++) {
        int index = i + j;
        if (index < _stations.length) {
          _row.add(Flexible(
            flex: 1,
            child: SafeArea(
              child: Card(
                child: Container(
                    constraints: BoxConstraints(minHeight: 100),
                    child: Column(
                      children: [
                        ListTile(
                          title:
                              Text("${index + 1}. ${_stations[index]['name']}"),
                          subtitle: Text("KM: +${_stations[index]['kml']}"),
                          trailing: Icon(Icons.info),
                        ),
                        Container(
                          height: 1.0,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          color: Colors.grey,
                        ),
                        ListTile(
                          title: Text("Platforms: "),
                          subtitle: Container(
                            margin: EdgeInsets.fromLTRB(10, 2, 10, 10),
                            child: createTagsTrack(_stations[index]),
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

  Tags createTagsTrack(dynamic d) {
    var tracks = d['tracks'];
    return Tags(
      itemCount: tracks.length,
      itemBuilder: (int index) {
        final item = Map<String, String>.from(tracks[index]);
        return Tooltip(
          message: d['dTi'] == item['name'] || d['dTa'] == item['name']
              ? "default/primary"
              : "primary",
          child: ItemTags(
            title: item['name'],
            index: index,
            combine: ItemTagsCombine.withTextAfter,
            elevation: 0,
            textColor: Colors.white,
            color: MyAppColors.ACCENT_COLOR,
            activeColor: MyAppColors.ACCENT_COLOR,
            key: Key((_stations[index]['name'] + "_t" + index.toString())),
            icon: ItemTagsIcon(
              icon: d['dTi'] == item['name'] || d['dTa'] == item['name']
                  ? Icons.nature
                  : Icons.nature_outlined,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    var _w = MediaQuery.of(context).size.width -
        (MyStaDat.showSideNavBar ? MyResponsive.NAVBARWIDTH : 0);
    _w = _w < 300 ? 300.0 : _w;
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            ListTile(
              title: Text(
                "Station Count : ${_stations.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.arrow_forward_ios),
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