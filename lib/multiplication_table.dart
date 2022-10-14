import 'package:eltraingraph/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class MultiplicationTableCell extends StatelessWidget {
  final String value;
  final Color color;
  final double width;
  final double height;

  const MultiplicationTableCell(
      {super.key,
      required this.value,
      required this.color,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: const TextStyle(fontSize: 14.0),
      ),
    );
  }
}

class TableHead extends StatelessWidget {
  final ScrollController scrollController;
  final double height;
  final double width;
  final List<List<String>> data;
  const TableHead({
    super.key,
    required this.scrollController,
    required this.height,
    required this.width,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          MultiplicationTableCell(
            color: MyAppColors.TABLEHEADER,
            value: data[0][0],
            width: width,
            height: height,
          ),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              scrollbarOrientation: ScrollbarOrientation.top,
              child: ListView(
                controller: scrollController,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(data[0].length - 1, (index) {
                  return MultiplicationTableCell(
                    color: MyAppColors.TABLEHEADER,
                    value: data[0][index + 1],
                    width: width,
                    height: height,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TableBody extends StatefulWidget {
  final ScrollController scrollController;
  final double width;
  final double height;
  final List<List<String>> data;
  TableBody({
    super.key,
    required this.scrollController,
    required this.width,
    required this.data,
    required this.height,
  });
  @override
  _TableBodyState createState() => _TableBodyState();
}

class _TableBodyState extends State<TableBody> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.width,
          child: Scrollbar(
            scrollbarOrientation: ScrollbarOrientation.right,
            thumbVisibility: true,
            controller: _firstColumnController,
            child: ListView(
              controller: _firstColumnController,
              physics: ClampingScrollPhysics(),
              children: List.generate(widget.data.length - 1, (index) {
                return MultiplicationTableCell(
                  color: MyAppColors.TABLEHEADER,
                  value: widget.data[index + 1][0],
                  width: widget.width,
                  height: widget.height,
                );
              }),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: (widget.data[0].length - 1) * widget.width,
              child: ListView(
                controller: _restColumnsController,
                physics: const ClampingScrollPhysics(),
                children: List.generate(widget.data.length - 1, (y) {
                  return Row(
                    children: List.generate(widget.data[y + 1].length - 1, (x) {
                      return MultiplicationTableCell(
                        value: widget.data[y + 1][x + 1],
                        color: MyAppColors.TABLECONTENT,
                        width: widget.width,
                        height: widget.height,
                      );
                    }),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MultiplicationTable extends StatefulWidget {
  final List<List<String>> data;
  final double width;
  final double height;
  const MultiplicationTable(
      {super.key,
      required this.data,
      required this.width,
      required this.height});

  @override
  _MultiplicationTableState createState() => _MultiplicationTableState();
}

class _MultiplicationTableState extends State<MultiplicationTable> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _headController;
  late ScrollController _bodyController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHead(
          scrollController: _headController,
          width: widget.width,
          height: widget.height,
          data: widget.data,
        ),
        Expanded(
          child: TableBody(
            scrollController: _bodyController,
            width: widget.width,
            height: widget.height,
            data: widget.data,
          ),
        ),
      ],
    );
  }
}
