import 'package:eltraingraph/mycolors.dart';
import 'package:flutter/Material.dart';

class ExpandedSTF extends StatefulWidget {
  final bool isExpand;
  const ExpandedSTF({super.key, this.isExpand = false});

  @override
  State<ExpandedSTF> createState() => ExpandedSTFState();
}

class ExpandedSTFState extends State<ExpandedSTF> {
  @override
  Widget build(BuildContext context) {
    if (widget.isExpand) {
      return Scaffold(
        appBar: AppBar(title: getTitle()),
        body: getChild(),
        backgroundColor: MyAppColors.PANEL_COLOR,
      );
    } else {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [...getTitle(), ...getChild()],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
    //delay for smooth animation
    Future.delayed(const Duration(milliseconds: 305), () {
      loadData();
    });
  }

  void loadData() {
    ;
  }

  getTitle() {
    return const [Text("Expanded Title")];
  }

  getChild() {
    return const [Center(child: Text("Expanded Widget"))];
  }
}
