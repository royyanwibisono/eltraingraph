import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/myresponsive.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  final String title;
  final IconData? iconData;
  final Widget? child;
  final List<Widget>? panelButtons;
  final int index;

  const ContentPage(
      {super.key,
      required this.title,
      this.iconData = Icons.crop_square,
      this.child,
      this.panelButtons,
      required this.index});

  @override
  State<ContentPage> createState() => ContentPageState();
}

class ContentPageState extends State<ContentPage> {
  final ScrollController _scrllcontroller = ScrollController();

  @override
  void initState() {
    // scrollToPosition();
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => scrollToPosition(false));
  }

  scrollToPosition(bool isAnimate) {
    int aniDuration = 300;
    if (_scrllcontroller != null && _scrllcontroller.hasClients) {
      if (!isAnimate) {
        return MyStaDat.scrollState[widget.index] < 0.0
            ? _scrllcontroller.jumpTo(0.0)
            : _scrllcontroller.position.maxScrollExtent >=
                    MyStaDat.scrollState[widget.index]
                ? _scrllcontroller.jumpTo(MyStaDat.scrollState[widget.index])
                : _scrllcontroller
                    .jumpTo(_scrllcontroller.position.maxScrollExtent);
      } else {
        return MyStaDat.scrollState[widget.index] < 0.0
            ? _scrllcontroller.animateTo(0.0,
                duration: Duration(milliseconds: aniDuration),
                curve: Curves.fastOutSlowIn)
            : _scrllcontroller.position.maxScrollExtent >=
                    MyStaDat.scrollState[widget.index]
                ? _scrllcontroller.animateTo(MyStaDat.scrollState[widget.index],
                    duration: Duration(milliseconds: aniDuration),
                    curve: Curves.fastOutSlowIn)
                : _scrllcontroller.animateTo(
                    _scrllcontroller.position.maxScrollExtent,
                    duration: Duration(milliseconds: aniDuration),
                    curve: Curves.fastOutSlowIn);
      }
    }
  }

  @override
  void dispose() {
    _scrllcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double panelHeight = 1000;
    const double panelWidth = MyResponsive.TABLETMAX;
    const double panelTitleHeight = 75;
    return Container(
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          MyStaDat.scrollState[widget.index] =
              scrollNotification.metrics.pixels; // <-- This is it.
          return false;
        },
        child: ListView(
          controller: _scrllcontroller,
          children: [
            Center(
              child: Padding(
                padding: MediaQuery.of(context).size.width >
                        MyResponsive.PHONEWIDTHMAX + MyResponsive.NAVBARWIDTH
                    ? const EdgeInsets.fromLTRB(36, panelTitleHeight, 36, 100)
                    : const EdgeInsets.fromLTRB(0, panelTitleHeight, 0, 100),
                child: Stack(
                  children: [
                    Card(
                      elevation: 4,
                      color: MyAppColors.ACCENT_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        width: panelWidth,
                        constraints: BoxConstraints(minHeight: panelHeight),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: panelTitleHeight - 20, left: 20),
                            child: ListTile(
                              textColor: MyAppColors.FONT_LIGHT_COLOR,
                              leading: Icon(
                                widget.iconData,
                                size: 36.0,
                                color: MyAppColors.FONT_LIGHT_COLOR,
                              ),
                              title: Text(
                                widget.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 78),
                      width: panelWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: widget.panelButtons == null
                            ? []
                            : widget.panelButtons!,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: panelTitleHeight + 30),
                      child: Card(
                        elevation: 4,
                        color: MyAppColors.PANEL_COLOR,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          width: panelWidth,
                          constraints: BoxConstraints(
                              minHeight: panelHeight - panelTitleHeight - 30),
                          // height: panelHeight - panelTitleHeight - 30,
                          child: widget.child ??
                              const Center(
                                child: Text("Content"),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
