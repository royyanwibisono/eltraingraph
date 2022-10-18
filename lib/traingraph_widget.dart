import 'package:day_picker/day_picker.dart';
import 'package:eltraingraph/expanded_widget.dart';
import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/myresponsive.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:eltraingraph/mystaticfunction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_range_picker/time_range_picker.dart';

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

class MyDayInWeek extends DayInWeek {
  int index;
  MyDayInWeek(super.dayName, this.index);
}

class TrainGraphsState extends ExpandedSTFState {
  var data = <List<TrTimeTable>>[];
  TooltipBehavior? _tooltip;
  ZoomPanBehavior? _zoomPanBehavior;
  String _timerange = "-";

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
      _timerange = getTimeRange();
    });
  }

  String getTimeRange() {
    var ret = "-";
    if (MyStaDat.A != null && MyStaDat.A!.graphProperties != null) {
      if (MyStaDat.A!.graphProperties!['tMin']!.isNotEmpty &&
          MyStaDat.A!.graphProperties!['tMax']!.isNotEmpty) {
        ret =
            '${MyStaDat.A!.graphProperties!['tMin']!} - ${MyStaDat.A!.graphProperties!['tMax']!}';
      }
    }
    return ret;
  }

  dynamic createData() {
    var ret = <List<TrTimeTable>>[];

    if (MyStaDat.A != null && MyStaDat.A!.graphProperties != null) {
      var mod = MyStFunc.getCountValidDay(MyStaDat.A!.graphProperties!['d']!);
      var tmin = MyStFunc.timeOfDayParse(MyStaDat.A!.graphProperties!['tMin']!);
      var tmax = MyStFunc.timeOfDayParse(MyStaDat.A!.graphProperties!['tMax']!);
      bool isRangeDisabled = MyStaDat.A!.graphProperties!['tMax']!.isEmpty ||
          MyStaDat.A!.graphProperties!['tMin']!.isEmpty;
      for (var x = 0; x < mod[0]; x++) {
        if (!mod[2][x]) continue;
        if (MyStaDat.A!.trainlistA != null && MyStaDat.A!.stationlist != null) {
          final ta = MyStaDat.A!.trainlistA!;
          DateTime now = DateTime.now().add(Duration(days: x));
          DateTime ntmin =
              DateTime(now.year, now.month, now.day, tmin.hour, tmin.minute);
          DateTime ntmax = tmax == TimeOfDay(hour: 0, minute: 0)
              ? DateTime(now.year, now.month, now.day, 23, 59, 59, 9999)
              : DateTime(now.year, now.month, now.day, tmax.hour, tmax.minute);
          final stations = MyStaDat.A!.stationlist!.reversed.toList();
          for (var i = 0; i < ta.length; i++) {
            //check op day
            if (ta[i]['d'][mod[3][x]] != '1') continue;
            if (ta[i]['sh'] == 'false') continue;

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

                if (isRangeDisabled ||
                    ((ntmin.isBefore(dtplot) ||
                            dtplot.isAtSameMomentAs(ntmin)) &&
                        (ntmax.isAfter(dtplot) ||
                            dtplot.isAtSameMomentAs(ntmax)))) {
                  res.add(TrTimeTable(
                      trname, double.parse(stations[j]['kmr']), dtplot));
                }
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

                if (isRangeDisabled ||
                    ((ntmin.isBefore(dtplot) ||
                            dtplot.isAtSameMomentAs(ntmin)) &&
                        (ntmax.isAfter(dtplot) ||
                            dtplot.isAtSameMomentAs(ntmax)))) {
                  res.add(TrTimeTable(
                      trname, double.parse(stations[j]['kmr']), dtplot));
                }
              }
            }
            ret.add(res);
          }
        }
        if (MyStaDat.A!.trainlistI != null && MyStaDat.A!.stationlist != null) {
          final ti = MyStaDat.A!.trainlistI!;
          DateTime now = DateTime.now().add(Duration(days: x));
          DateTime ntmin =
              DateTime(now.year, now.month, now.day, tmin.hour, tmin.minute);
          DateTime ntmax = tmax == TimeOfDay(hour: 0, minute: 0)
              ? DateTime(now.year, now.month, now.day, 23, 59, 59, 9999)
              : DateTime(now.year, now.month, now.day, tmax.hour, tmax.minute);
          final stations = MyStaDat.A!.stationlist!;
          for (var i = 0; i < ti.length; i++) {
            //check op day
            if (ti[i]['d'][mod[3][x]] != '1') continue;
            if (ti[i]['sh'] == 'false') continue;

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

                if (isRangeDisabled ||
                    ((ntmin.isBefore(dtplot) ||
                            dtplot.isAtSameMomentAs(ntmin)) &&
                        (ntmax.isAfter(dtplot) ||
                            dtplot.isAtSameMomentAs(ntmax)))) {
                  res.add(TrTimeTable(
                      trname, double.parse(stations[j]['kml']), dtplot));
                }
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

                if (isRangeDisabled ||
                    ((ntmin.isBefore(dtplot) ||
                            dtplot.isAtSameMomentAs(ntmin)) &&
                        (ntmax.isAfter(dtplot) ||
                            dtplot.isAtSameMomentAs(ntmax)))) {
                  res.add(TrTimeTable(
                      trname, double.parse(stations[j]['kml']), dtplot));
                }
              }
            }
            ret.add(res);
          }
        }
      }
    }
    return ret;
  }

  @override
  getTitle() {
    TextStyle style = TextStyle(fontWeight: FontWeight.bold);
    var text = Text(
      "Train Graph Resut",
      style: style,
    );

    if (widget.isExpand) {
      return text;
    } else {
      bool isMobile = MediaQuery.of(context).size.width -
              (MyStaDat.showSideNavBar ? 0 : MyResponsive.NAVBARWIDTH) <
          MyResponsive.PHONEWIDTHMAX;
      List<DayInWeek> _days = [
        DayInWeek("Mon0"),
        DayInWeek("Tue1"),
        DayInWeek("Wed2"),
        DayInWeek("Thu3"),
        DayInWeek("Fri4"),
        DayInWeek("Sat5"),
        DayInWeek("Sun6"),
      ];
      if (MyStaDat.A!.graphProperties != null) {
        var d = MyStaDat.A!.graphProperties!['d']!;
        for (var x = 0; x < 7; x++) {
          _days[x].isSelected = d[x] == '1';
        }
      }
      return [
        const SizedBox(height: 15),
        ListTile(
          title: Text(
            "Operation days : ",
            style: style,
          ),
          leading: isMobile ? null : const Icon(Icons.arrow_forward_ios),
          subtitle: SelectWeekDays(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            days: _days,
            border: false,
            daysFillColor: MyAppColors.PRIMARY_COLOR,
            selectedDayTextColor: MyAppColors.FONT_LIGHT_COLOR,
            unSelectedDayTextColor: MyAppColors.FONT_DARK_COLOR,
            // daysBorderColor: Colors.black,
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: const Color.fromARGB(10, 0, 0, 0),
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   colors: [const Color(0xFFE55CE4), const Color(0xFFBB75FB)],
              //   tileMode:
              //       TileMode.repeated, // repeats the gradient over the canvas
              // ),
            ),
            onSelect: (values) {
              if (MyStaDat.A != null && MyStaDat.A!.graphProperties != null) {
                var setdays = List.filled(7, '0', growable: true);
                for (String d in values) {
                  int index = int.parse(d[3]);
                  setdays[index] = '1';
                }

                MyStaDat.A!.graphProperties!['d'] = setdays.join();
                loadData();
              }
            },
          ),
        ),
        ListTile(
          title: Text(
            "Time Range : ",
            style: style,
          ),
          leading: isMobile ? null : const Icon(Icons.arrow_forward_ios),
          subtitle: CheckboxListTile(
            title: isMobile
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Full 24 H"),
                      SizedBox(
                        width: 20,
                        height: 50,
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(_timerange),
                          const SizedBox(
                            height: 4,
                          ),
                          createBtnSetTimeRange(),
                        ],
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Full 24 Hours"),
                      SizedBox(
                        width: 40,
                        height: 50,
                        child: Center(
                          child: Container(
                            height: 50,
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Text(_timerange),
                      const SizedBox(
                        width: 20,
                      ),
                      createBtnSetTimeRange(),
                    ],
                  ),
            value: _timerange == "-",
            onChanged: (newValue) {
              if (newValue!) {
                if (MyStaDat.A?.graphProperties != null) {
                  MyStaDat.A?.graphProperties!['tMin'] = "";
                  MyStaDat.A?.graphProperties!['tMax'] = "";
                  loadData();
                }
              } else {
                if (MyStaDat.A?.graphProperties != null) {
                  MyStaDat.A?.graphProperties!['tMin'] = "00:00";
                  MyStaDat.A?.graphProperties!['tMax'] = "00:00";
                  loadData();
                }
              }
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     TimeRange result = await showTimeRangePicker(
          //       context: context,
          //     );
          //     print("result " + result.toString());
          //   },
          //   child: Text("Pure"),
          // ),
        ),
      ];
    }
  }

  ElevatedButton createBtnSetTimeRange() {
    return ElevatedButton(
      onPressed: () async {
        TimeOfDay start = const TimeOfDay(hour: 0, minute: 0);
        TimeOfDay end = const TimeOfDay(hour: 18, minute: 0);
        if (_timerange != "-") {
          var s = _timerange.split(' - ');
          start = MyStFunc.timeOfDayParse(s[0]);
          end = MyStFunc.timeOfDayParse(s[1]);
        }
        TimeRange result = await showTimeRangePicker(
          context: context,
          start: start,
          end: end,
        );
        if (result != null && MyStaDat.A?.graphProperties != null) {
          MyStaDat.A?.graphProperties!['tMin'] =
              MyStFunc.TODtoStr(result.startTime);
          MyStaDat.A?.graphProperties!['tMax'] =
              MyStFunc.TODtoStr(result.endTime);
          loadData();
        }
      },
      child: Text("SET RANGE"),
    );
  }

  @override
  getChild() {
    var container = Container(
      height: (MediaQuery.of(context).size.height * 0.8) < 600
          ? 600
          : MediaQuery.of(context).size.height * 0.8,
      child: data.isNotEmpty
          ? SfCartesianChart(
              backgroundColor:
                  MyStFunc.hexToColor(MyStaDat.A!.graphProperties!['bgC']!)
                      .withAlpha(25),
              // legend: Legend(
              //     isVisible: true,
              //     position: LegendPosition.top,
              //     shouldAlwaysShowScrollbar: true,
              //     isResponsive: true),
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

          //// ***bugs! throw error when uncheck operation day***
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
