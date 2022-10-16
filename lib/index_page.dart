import 'dart:io';

import 'package:eltraingraph/login_page.dart';
import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/myresponsive.dart';
import 'package:eltraingraph/content_widget.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:eltraingraph/schedule_widget.dart';
import 'package:eltraingraph/stationlist_widget.dart';
import 'package:eltraingraph/traingraph_widget.dart';
import 'package:eltraingraph/trainlist_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with TickerProviderStateMixin {
  TabController? tabController;
  double appBarWidth = MyResponsive.PHONEWIDTHMAX;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<GlobalKey<ContentPageState>> _myContentKeys = [
    GlobalKey<ContentPageState>(),
    GlobalKey<ContentPageState>(),
    GlobalKey<ContentPageState>(),
    GlobalKey<ContentPageState>()
  ];
  var trListKey = GlobalKey<TrainListState>();
  var stListKey = GlobalKey<StationListState>();
  var schdleKey = GlobalKey<SchedulesState>();
  var graphKey = GlobalKey<TrainGraphsState>();

  @override
  Widget build(BuildContext context) {
    List<Widget> myTabcontents = createTabsContent();
    TabBar myTabBar = createTabsBar();

    return DefaultTabController(
      initialIndex: MyStaDat.selectedIndex,
      length: myTabcontents.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        tabController = DefaultTabController.of(context)!;
        tabController?.addListener(() {
          if (!tabController!.indexIsChanging) {
            setState(() {
              MyStaDat.selectedIndex = tabController!.index;
            });
          }
        });

        return createScaffold(context, myTabcontents, appBarWidth, myTabBar);
      }),
    );
  }

  Scaffold createScaffold(BuildContext context, List<Widget> myTabcontents,
      double appBarWidth, TabBar myTabBar) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyAppColors.BG_COLOR,
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        // mini: true,
        onPressed: () {
          setState(() {
            MyStaDat.scrollState[MyStaDat.selectedIndex] = 0.0;
            // myTabcontents[MyStaDat.selectedIndex]
            _myContentKeys[MyStaDat.selectedIndex]
                .currentState!
                .scrollToPosition(true);
          });
        },
        child: Icon(Icons.arrow_upward),
      ),
      drawer: Drawer(
        backgroundColor: MyAppColors.ACCENT_COLOR,
        child: Stack(
          children: [
            createSidebarContent(context),
            Align(
              alignment: Alignment.topRight,
              child: MediaQuery.of(context).size.width >
                      MyResponsive.PHONEWIDTHMAX + MyResponsive.NAVBARWIDTH
                  ? IconButton(
                      icon: const Icon(Icons.push_pin_outlined),
                      color: MyAppColors.PRIMARY_COLORDRK,
                      onPressed: () {
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 250), () {
                          setState(() {
                            MyStaDat.showSideNavBar = !MyStaDat.showSideNavBar;
                          });
                        });
                      },
                    )
                  : Container(),
            ),
          ],
        ),
      ),
      body: (MediaQuery.of(context).size.width >
                  MyResponsive.PHONEWIDTHMAX + MyResponsive.NAVBARWIDTH) &&
              MyStaDat.showSideNavBar
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MyResponsive.NAVBARWIDTH,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: MyAppColors.ACCENT_COLOR,
                      boxShadow: [
                        BoxShadow(
                          color: MyAppColors.SHADOW_COLOR,
                          blurRadius: 4,
                          offset: Offset(4, 0), // Shadow position
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        createSidebarContent(context),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            color: MyAppColors.PRIMARY_COLORDRK,
                            onPressed: () => setState(() {
                              MyStaDat.showSideNavBar =
                                  !MyStaDat.showSideNavBar;
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width -
                      MyResponsive.NAVBARWIDTH,
                  child: createMainPage(
                      context, myTabcontents, appBarWidth, myTabBar),
                )
              ],
            )
          : createMainPage(context, myTabcontents, appBarWidth, myTabBar),
    );
  }

  TabBar createTabsBar() {
    return TabBar(
        // indicatorColor: Colors.red,
        indicator: const BoxDecoration(
            // backgroundBlendMode: BlendMode.colorDodge,
            //color: Color.fromARGB(110, 250, 133, 0),
            border: Border(
                bottom:
                    BorderSide(color: MyAppColors.SELECTEDTABLINE, width: 4))),
        splashFactory: InkRipple.splashFactory,
        // overlayColor: MaterialStateProperty.resolveWith<Color?>(
        //   (Set<MaterialState> states) {
        //     return states.contains(MaterialState.focused) ? null : Colors.amber;
        //   },
        // ),
        splashBorderRadius: MyStaDat.selectedIndex != 1
            ? const BorderRadius.all(Radius.circular(0))
            : const BorderRadius.all(Radius.circular(10)),
        tabs: const <Widget>[
          Tab(
            icon: Icon(Icons.flag_outlined),
            text: "STATIONS",
          ),
          Tab(
            icon: Icon(Icons.train),
            text: "TRAINS",
          ),
          Tab(
            icon: Icon(Icons.schedule),
            text: "SCHEDULE",
          ),
          Tab(
            icon: Icon(Icons.auto_graph),
            text: "GRAPH",
          )
        ]);
  }

  List<Widget> createTabsContent() {
    return <Widget>[
      ContentPage(
        title: "Station List",
        iconData: Icons.flag,
        index: 0,
        key: _myContentKeys[0],
        child: StationList(key: stListKey),
      ),
      ContentPage(
        title: "Train List",
        iconData: Icons.train,
        panelButtons: createPanelDirBtns(),
        index: 1,
        key: _myContentKeys[1],
        child: TrainList(key: trListKey),
      ),
      ContentPage(
        title: "Train Schedule",
        iconData: Icons.table_chart_outlined,
        panelButtons: createPanelDirBtns(),
        index: 2,
        key: _myContentKeys[2],
        child: Schedules(key: schdleKey),
      ),
      ContentPage(
        title: "Train Graph",
        iconData: Icons.add_chart,
        index: 3,
        key: _myContentKeys[3],
        child: TrainGraphs(key: graphKey),
      )
    ];
  }

  List<Widget> createPanelDirBtns() {
    return [
      ElevatedButton(
        onPressed: () {
          if (MyStaDat.selectedIndexTrain != 0) {
            setState(() {
              MyStaDat.selectedIndexTrain = 0;
              reloadDataPage();
            });
          }
        },
        style: MyStaDat.selectedIndexTrain == 0
            ? MyStaDat.styleBtnPanelAct
            : MyStaDat.styleBtnPanelInAct,
        child: MediaQuery.of(context).size.width < MyResponsive.PHONEWIDTHMAX
            ? Text('to RIGHT')
            : Text('Direction to RIGHT'),
      ),
      const SizedBox(
        width: 5,
      ),
      ElevatedButton(
        onPressed: () {
          if (MyStaDat.selectedIndexTrain != 1) {
            setState(() {
              MyStaDat.selectedIndexTrain = 1;
              reloadDataPage();
            });
          }
        },
        style: MyStaDat.selectedIndexTrain == 1
            ? MyStaDat.styleBtnPanelAct
            : MyStaDat.styleBtnPanelInAct,
        child: MediaQuery.of(context).size.width < MyResponsive.PHONEWIDTHMAX
            ? Text('to LEFT')
            : Text('Direction to LEFT'),
      ),
      SizedBox(
        width: 40,
      ),
    ];
  }

  void reloadDataPage() {
    if (MyStaDat.selectedIndex == 0) {
      stListKey.currentState!.loadData();
    } else if (MyStaDat.selectedIndex == 1) {
      trListKey.currentState!.loadData();
    } else if (MyStaDat.selectedIndex == 2) {
      schdleKey.currentState!.loadData();
    } else if (MyStaDat.selectedIndex == 3) {
      graphKey.currentState!.loadData();
    }
  }

  Stack createSidebarContent(BuildContext context) {
    const textStyleLight =
        TextStyle(color: MyAppColors.FONT_LIGHT_COLOR, fontSize: 14);
    return Stack(
      children: [
        ListView(
          children: [
            Material(
              elevation: 2,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    // bottomLeft: Radius.circular(11),
                    bottomRight: Radius.circular(11)),
                // side: const BorderSide(color: Colors.red, width: 1),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: MyAppColors.PRIMARY_COLOR,
                  borderRadius: BorderRadius.only(
                      // bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                // color: MyAppColors.PRIMARY_COLOR,
                height: 200,
                child: Stack(
                  children: [
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoginCard.createLogo(),
                        const SizedBox(height: 15),
                        Text(
                          "EltrainGraph",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              letterSpacing: 4,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: MyAppColors.ACCENT_COLOR),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: const TextSpan(
                        style: textStyleLight,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Information \n',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: 'EltrainGraph ',
                              style:
                                  TextStyle(color: MyAppColors.PRIMARY_COLOR)),
                          TextSpan(
                              text:
                                  'is  is an application, that enables operator to create train graphs in convenient way to display the graphs both in a planning mode, as well as in a live mode according to the specific delays of trains. '),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: MyAppColors.PRIMARY_COLOR,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 1,
                  ),
                  Card(
                    elevation: 0,
                    color: MyAppColors.ACCENT_COLOR,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.file_open,
                            color: MyAppColors.FONT_LIGHT_COLOR,
                          ),
                          title: const Text(
                            'Open File',
                            style: textStyleLight,
                          ),
                          onTap: () async {
                            closeSideNavBar(context);
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['xml', 'fpl'],
                            );

                            if (result != null) {
                              if (kIsWeb) {
                                Uint8List fileBytes = result.files.first.bytes!;
                                String contents =
                                    String.fromCharCodes(fileBytes);
                                MyStaDat.A?.updateData(contents);
                                reloadDataPage();
                              } else {
                                File file = File(result.files.single.path!);
                                file.readAsString().then((String contents) {
                                  MyStaDat.A?.updateData(contents);
                                  reloadDataPage();
                                });
                              }
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.filter_center_focus,
                            color: MyAppColors.FONT_LIGHT_COLOR,
                          ),
                          title: const Text(
                            'Expand',
                            style: textStyleLight,
                          ),
                          onTap: () {
                            closeSideNavBar(context);
                            expandWidget(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.refresh,
                            color: MyAppColors.FONT_LIGHT_COLOR,
                          ),
                          title: const Text(
                            'Reload',
                            style: textStyleLight,
                          ),
                          onTap: () {
                            closeSideNavBar(context);
                            reloadDataPage();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                elevation: 0,
                color: MyAppColors.ACCENT_COLOR,
                child: Column(
                  children: [
                    Container(
                      color: MyAppColors.PRIMARY_COLOR,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      height: 1,
                    ),
                    const AboutListTile(
                      icon: Icon(
                        Icons.info,
                      ),
                      applicationIcon: Icon(
                        Icons.auto_graph,
                      ),
                      applicationName: MyStaDat.APPTITLE,
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2022 Royyan',
                      aboutBoxChildren: [
                        SizedBox(height: 30),
                        Text(
                          "e-mail: developerroyyan@gmail.com",
                          style: TextStyle(
                              color: MyAppColors.FONT_DARK_COLOR,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                      child: Text('About app'),
                    ),
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.logout,
                    //   ),
                    //   title: const Text('Sign Out'),
                    //   onTap: () {
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const LoginPage()));
                    //   },
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void expandWidget(BuildContext context) {
    if (MyStaDat.selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const StationList(
            isExpand: true,
          ),
          // builder: (context) => const SliverIndexPage(),
        ),
      );
    } else if (MyStaDat.selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TrainList(
            isExpand: true,
          ),
          // builder: (context) => const SliverIndexPage(),
        ),
      );
    } else if (MyStaDat.selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Schedules(
            isExpand: true,
          ),
          // builder: (context) => const SliverIndexPage(),
        ),
      );
    } else if (MyStaDat.selectedIndex == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TrainGraphs(
            isExpand: true,
          ),
          // builder: (context) => const SliverIndexPage(),
        ),
      );
    }
  }

  void closeSideNavBar(BuildContext context) {
    if (!MyStaDat.showSideNavBar ||
        MediaQuery.of(context).size.width <=
            (MyResponsive.PHONEWIDTHMAX + MyResponsive.NAVBARWIDTH)) {
      Navigator.pop(context);
    }
  }

  Stack createMainPage(BuildContext context, List<Widget> myTabcontents,
      double appBarWidth, TabBar myTabBar) {
    return Stack(
      children: [
        TabBarView(children: myTabcontents),
        Positioned(
          left: MediaQuery.of(context).size.width > MyResponsive.PHONEWIDTHMAX
              ? ((MediaQuery.of(context).size.width -
                      ((MediaQuery.of(context).size.width >
                                  MyResponsive.PHONEWIDTHMAX +
                                      MyResponsive.NAVBARWIDTH) &&
                              MyStaDat.showSideNavBar
                          ? MyResponsive.NAVBARWIDTH
                          : 0) -
                      appBarWidth) /
                  2)
              : 0,
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width > MyResponsive.PHONEWIDTHMAX
                    ? appBarWidth
                    : MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.width >
                    MyResponsive.PHONEWIDTHMAX + MyResponsive.NAVBARWIDTH)
                ? myTabBar.preferredSize.height * 1.0
                : myTabBar.preferredSize.height * 1.7,
            child: AppBar(
              // title: const Text('TITLE'),
              actions: [
                IconButton(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const LoginPage()));
                  },
                ),
              ],
              // toolbarHeight: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(myTabBar.preferredSize.height),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: myTabBar,
                ),
              ),
            ),
          ),
        ),
        Container(
          child: (MediaQuery.of(context).size.width >
                      MyResponsive.PHONEWIDTHMAX + MyResponsive.NAVBARWIDTH) &&
                  !MyStaDat.showSideNavBar
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: IconButton(
                          icon: const Icon(Icons.menu),
                          color: MyAppColors.ACCENT_COLOR,
                          onPressed: () {
                            _scaffoldKey.currentState!.openDrawer();
                          }),
                    ),
                    SizedBox(
                      child: IconButton(
                        icon: const Icon(Icons.logout),
                        color: MyAppColors.ACCENT_COLOR,
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const LoginPage()));
                        },
                      ),
                    )
                  ],
                )
              : Container(),
        )
      ],
    );
  }
}
