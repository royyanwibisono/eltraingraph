import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:flutter/material.dart';

enum TrainDirectionType { I, A }

class TrainCard extends StatefulWidget {
  final int index;
  final TrainDirectionType trainDiretion;
  final String name;
  final String cm;
  const TrainCard(
      {super.key,
      required this.index,
      required this.trainDiretion,
      required this.name,
      required this.cm});

  @override
  State<TrainCard> createState() => _TrainCardState();
}

class _TrainCardState extends State<TrainCard> {
  var _isShowInGraph = true;
  var _opdays = '0000000';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Card(
      color: widget.trainDiretion == TrainDirectionType.I
          ? MyAppColors.CARD1_COLOR
          : MyAppColors.CARD2_COLOR,
      child: Container(
          constraints: BoxConstraints(minHeight: 100),
          child: Column(
            children: [
              ListTile(
                title: Text(widget.name),
                subtitle: Text("- ${widget.cm}"),
                trailing: const Icon(Icons.info),
              ),
              Container(
                height: 1.0,
                margin: const EdgeInsets.only(left: 10, right: 10),
                color: Colors.grey,
              ),
              CheckboxListTile(
                  title: const Text("Show in train graph."),
                  value: _isShowInGraph,
                  onChanged: (value) {
                    setState(() {
                      _isShowInGraph = value!;
                      updateDataToD();
                    });
                  }),
              ListTile(
                title: const Text("Operation Days: "),
                subtitle: Container(
                  margin: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                  child: createDayOp(widget.index),
                ),
              ),
            ],
          )),
    );
  }

  void loadData() {
    if (MyStaDat.D != null &&
        MyStaDat.D!.trainlistI != null &&
        widget.trainDiretion == TrainDirectionType.I &&
        MyStaDat.D!.trainlistI!.length > widget.index) {
      var ishig = MyStaDat.D!.trainlistI![widget.index]['sh'] == 'true';
      var od = MyStaDat.D!.trainlistI![widget.index]['d'];
      setState(() {
        _isShowInGraph = ishig;
        _opdays = od;
      });
    } else if (MyStaDat.D != null &&
        MyStaDat.D!.trainlistA != null &&
        widget.trainDiretion == TrainDirectionType.A &&
        MyStaDat.D!.trainlistA!.length > widget.index) {
      var ishig = MyStaDat.D!.trainlistA![widget.index]['sh'] == 'true';
      var od = MyStaDat.D!.trainlistA![widget.index]['d'];
      setState(() {
        _isShowInGraph = ishig;
        _opdays = od;
      });
    }
  }

  void updateDataToD() {
    if (MyStaDat.D != null) {
      if (widget.trainDiretion == TrainDirectionType.I) {
        if (MyStaDat.D!.trainlistI != null) {
          MyStaDat.D!.trainlistI![widget.index]['sh'] =
              _isShowInGraph ? 'true' : 'false';
          MyStaDat.D!.trainlistI![widget.index]['d'] = _opdays;
        }
      } else if (widget.trainDiretion == TrainDirectionType.A) {
        if (MyStaDat.D!.trainlistA != null) {
          MyStaDat.D!.trainlistA![widget.index]['sh'] =
              _isShowInGraph ? 'true' : 'false';
          MyStaDat.D!.trainlistA![widget.index]['d'] = _opdays;
        }
      }
    }
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
    // var _trains = TrainDirectionType.A != null &&
    //         widget.trainDiretion == TrainDirectionType.A
    //     ? MyStaDat.D!.trainlistA
    //     : MyStaDat.D!.trainlistI;
    var opd = _opdays;
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
                      var s =
                          _opdays.replaceRange(i, i + 1, value! ? '1' : '0');
                      setState(() {
                        _opdays = s;
                        updateDataToD();
                      });
                    }),
              ],
            )));
      }
    }
    return res;
  }
}
