import 'package:eltraingraph/expanded_widget.dart';
import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:eltraingraph/mystaticfunction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrainGraphs extends ExpandedSTF {
  const TrainGraphs({
    Key? key,
    bool isExpand = false,
  }) : super(key: key, isExpand: isExpand);

  @override
  State<ExpandedSTF> createState() => TrainGraphsState();
}

class TrTimeTable {
  TrTimeTable(this.name, this.KM, this.time);
  final String name;
  final double KM;
  final DateTime time;
}

class TrainGraphsState extends ExpandedSTFState {
  var data = <List<TrTimeTable>>[];
  TooltipBehavior? _tooltip;
  ZoomPanBehavior? _zoomPanBehavior;

  @override
  void loadData() {
    var _data = createData();
    _tooltip = TooltipBehavior(
      enable: true,
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enableDoubleTapZooming: true,
      enablePanning: true,
      enableSelectionZooming: true,
      enableMouseWheelZooming: true,
    );
    setState(() {
      data = _data;
    });
  }

  dynamic createData() {
    var ret = <List<TrTimeTable>>[];

    var mod = MyStFunc.getCountValidDay(MyStaDat.A!.graphProperties!['d']!);
    for (var x = 0; x < mod[0]; x++) {
      if (!mod[2][x]) continue;
      if (MyStaDat.A != null &&
          MyStaDat.A!.trainlistA != null &&
          MyStaDat.A!.stationlist != null) {
        final ta = MyStaDat.A!.trainlistA!;
        DateTime now = DateTime.now().add(Duration(days: x));
        final stations = MyStaDat.A!.stationlist!.reversed.toList();
        for (var i = 0; i < ta.length; i++) {
          //check op day
          var smod = MyStFunc.getCountValidDay(ta[i]['d']);
          if (!smod[2][x]) continue;

          var res = <TrTimeTable>[];
          var trname = ta[i]['name'];
          //reverse timetable
          var tt = (ta[i]['t'] as List).reversed.toList();
          for (var j = 0; j < tt.length; j++) {
            var mapdata = Map<String, String>.from(tt[j]);
            if (mapdata['a']!.isNotEmpty) {
              var time = mapdata['a']!.isNotEmpty
                  ? mapdata['a']!.split(':')
                  : ["00", "00"].toList();

              var dtplot = DateTime(now.year, now.month, now.day,
                  int.parse(time[0]), int.parse(time[1]), 0);

              if (res.isNotEmpty && res.last.time.isAfter(dtplot)) {
                dtplot = dtplot.add(const Duration(days: 1));
              }

              res.add(TrTimeTable(
                  trname, double.parse(stations[j]['kmr']), dtplot));
            }
            if (mapdata['d']!.isNotEmpty) {
              var time = mapdata['d']!.isNotEmpty
                  ? mapdata['d']!.split(':')
                  : ["00", "00"].toList();
              var dtplot = DateTime(now.year, now.month, now.day,
                  int.parse(time[0]), int.parse(time[1]), 0);

              if (res.isNotEmpty && res.last.time.isAfter(dtplot)) {
                dtplot = dtplot.add(const Duration(days: 1));
              }

              res.add(TrTimeTable(
                  trname, double.parse(stations[j]['kmr']), dtplot));
            }
          }
          ret.add(res);
        }
      }
      if (MyStaDat.A != null &&
          MyStaDat.A!.trainlistI != null &&
          MyStaDat.A!.stationlist != null) {
        final ti = MyStaDat.A!.trainlistI!;
        DateTime now = DateTime.now().add(Duration(days: x));
        final stations = MyStaDat.A!.stationlist!;
        for (var i = 0; i < ti.length; i++) {
          //check op day
          var smod = MyStFunc.getCountValidDay(ti[i]['d']);
          if (!smod[2][x]) continue;

          var res = <TrTimeTable>[];
          var trname = ti[i]['name'];
          //reverse timetable
          var tt = (ti[i]['t'] as List);
          for (var j = 0; j < tt.length; j++) {
            var mapdata = Map<String, String>.from(tt[j]);
            if (mapdata['a']!.isNotEmpty) {
              var time = mapdata['a']!.isNotEmpty
                  ? mapdata['a']!.split(':')
                  : ["00", "00"].toList();
              var dtplot = DateTime(now.year, now.month, now.day,
                  int.parse(time[0]), int.parse(time[1]), 0);

              if (res.isNotEmpty && res.last.time.isAfter(dtplot)) {
                dtplot = dtplot.add(const Duration(days: 1));
              }

              res.add(TrTimeTable(
                  trname, double.parse(stations[j]['kml']), dtplot));
            }

            if (mapdata['d']!.isNotEmpty) {
              var time = mapdata['d']!.isNotEmpty
                  ? mapdata['d']!.split(':')
                  : ["00", "00"].toList();
              var dtplot = DateTime(now.year, now.month, now.day,
                  int.parse(time[0]), int.parse(time[1]), 0);

              if (res.isNotEmpty && res.last.time.isAfter(dtplot)) {
                dtplot = dtplot.add(const Duration(days: 1));
              }

              res.add(TrTimeTable(
                  trname, double.parse(stations[j]['kml']), dtplot));
            }
          }
          ret.add(res);
        }
      }
    }
    return ret;
  }

  @override
  getTitle() {
    var text = const Text(
      "Lorem Ipsum sir dolor amet",
      style: TextStyle(fontWeight: FontWeight.bold),
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
    var container = Container(
      height: MediaQuery.of(context).size.height < 1000
          ? 1000
          : MediaQuery.of(context).size.height,
      child: data.isNotEmpty
          ? SfCartesianChart(
              backgroundColor:
                  MyStFunc.hexToColor(MyStaDat.A!.graphProperties!['bgC']!)
                      .withAlpha(25),
              legend: Legend(isVisible: true, position: LegendPosition.top),
              tooltipBehavior: _tooltip,
              zoomPanBehavior: _zoomPanBehavior,
              primaryXAxis: DateTimeAxis(
                opposedPosition: true,
                intervalType: DateTimeIntervalType.minutes,
                interval: 60,
                multiLevelLabelStyle: const MultiLevelLabelStyle(
                  // borderColor: Colors.blue,
                  // borderWidth: 0.001,
                  borderType: MultiLevelBorderType.curlyBrace,
                ),
                multiLevelLabels: createDayLabel,
              ),
              primaryYAxis: NumericAxis(
                isInversed: true,
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 0),
                // labelFormat: '{value}Km',
                title: AxisTitle(text: "Station"),
                isVisible: true,
                labelRotation: 315,
                minimum: MyStaDat.A!.stationlist != null
                    ? double.parse(MyStaDat.A!.stationlist![0]['kml']) - 2
                    : 0,
                multiLevelLabelStyle: const MultiLevelLabelStyle(
                  // borderColor: Colors.blue,
                  borderWidth: 0.01,
                  borderType: MultiLevelBorderType.withoutTopAndBottom,
                ),
                multiLevelLabels: createStationLabel,
              ),
              series: <ChartSeries<TrTimeTable, DateTime>>[
                ...createStation(),
                ...createChart(data),
              ],
            )
          : const Center(
              child: Text("loading data..."),
            ),
    );
    if (widget.isExpand) {
      return container;
    } else {
      return [
        container,
      ];
    }
  }

  List<DateTimeMultiLevelLabel> get createDayLabel {
    if (MyStaDat.A != null && MyStaDat.A!.graphProperties != null) {
      var mod = MyStFunc.getCountValidDay(MyStaDat.A!.graphProperties!['d']!);
      var ret = <DateTimeMultiLevelLabel>[];
      for (var x = 0; x < mod[0]; x++) {
        var dt = DateTime.now().add(Duration(days: x));
        ret.add(DateTimeMultiLevelLabel(
          start: DateTime(dt.year, dt.month, dt.day, 0, 0, 0),
          end: DateTime(dt.year, dt.month, dt.day, 23, 59, 59, 9999),
          text: mod[1][x],
        ));
      }

      return ret;
    }

    return [];
  }

  List<NumericMultiLevelLabel> get createStationLabel {
    if (MyStaDat.A != null && MyStaDat.A!.stationlist != null) {
      var ret = <NumericMultiLevelLabel>[];
      for (var st in MyStaDat.A!.stationlist!) {
        var km = double.parse(st['kml']);
        ret.add(NumericMultiLevelLabel(
            start: km - 0.5, end: km + 0.5, text: st['name']));
      }
      return ret;
    } else {
      return [];
    }
    // return const <NumericMultiLevelLabel>[
    //               NumericMultiLevelLabel(start: 84, end: 85, text: 'First'),
    //             ];
  }

  List<FastLineSeries<TrTimeTable, DateTime>> createChart(
      List<List<TrTimeTable>> data) {
    var ret = <FastLineSeries<TrTimeTable, DateTime>>[];
    for (var tr in data) {
      if (tr.isEmpty) continue;
      ret.add(
        FastLineSeries<TrTimeTable, DateTime>(
          dataSource: tr,
          name: tr.first.name,
          xValueMapper: (TrTimeTable ttt, _) => ttt.time,
          yValueMapper: (TrTimeTable ttt, _) => ttt.KM,
          animationDuration: 0,
          width: 3.0,
          // dataLabelMapper: (TrTimeTable ttt, _) => (tr[0] as TrTimeTable).name,
          // '${ttt.time.hour.toString().padLeft(2, '0')}:${ttt.time.minute.toString().padLeft(2, '0')}',
          // dataLabelSettings: const DataLabelSettings(
          //   isVisible: true,
          // ),
        ),
      );
    }

    return ret;
  }

  List<FastLineSeries<TrTimeTable, DateTime>> createStation() {
    var ret = <FastLineSeries<TrTimeTable, DateTime>>[];
    // var now = DateTime.now();
    if (MyStaDat.A != null &&
        MyStaDat.A!.stationlist != null &&
        MyStaDat.A!.graphProperties != null) {
      var mod = MyStFunc.getCountValidDay(MyStaDat.A!.graphProperties!['d']!);
      for (var x = 0; x < mod[0]; x++) {
        var now = DateTime.now().add(Duration(days: x));
        for (var st in MyStaDat.A!.stationlist!) {
          var dsc = [
            TrTimeTable(st['name'], double.parse(st['kml']),
                DateTime(now.year, now.month, now.day, 0, 0, 0)),
            TrTimeTable(st['name'], double.parse(st['kmr']),
                DateTime(now.year, now.month, now.day, 23, 59, 59, 9999)),
          ];
          ret.add(
            FastLineSeries<TrTimeTable, DateTime>(
              dataSource: dsc,
              name: st['name'],
              color: MyStFunc.hexToColor(st['cl']),
              isVisibleInLegend: false,
              xValueMapper: (TrTimeTable ttt, _) => ttt.time,
              yValueMapper: (TrTimeTable ttt, _) => ttt.KM,
              animationDuration: 0,
              width: 0.5,
              dataLabelMapper: (TrTimeTable ttt, _) => st['name'],
              // '${ttt.time.hour.toString().padLeft(2, '0')}:${ttt.time.minute.toString().padLeft(2, '0')}',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                alignment: ChartAlignment.near,
              ),
            ),
          );
        }
      }
    }
    return ret;
  }
}
