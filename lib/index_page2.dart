import 'package:eltraingraph/content_widget.dart';
import 'package:eltraingraph/index_page.dart';
import 'package:eltraingraph/login_page.dart';
import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/myresponsive.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:eltraingraph/schedule_widget.dart';
import 'package:eltraingraph/stationlist_widget.dart';
import 'package:eltraingraph/traingraph_widget.dart';
import 'package:eltraingraph/trainlist_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IndexPage2 extends StatefulWidget {
  const IndexPage2({super.key});

  @override
  State<IndexPage2> createState() => _IndexPage2State();
}

class _IndexPage2State extends State<IndexPage2> {
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
    return Scaffold(
      // appBar: AppBar(title: Text("Title")),
      key: _scaffoldKey,
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
                  child: cretaeMainPage(),
                )
              ],
            )
          : cretaeMainPage(),
      backgroundColor: MyAppColors.BG_COLOR,
    );
  }

  Widget cretaeMainPage() {
    return Stack(children: [
      (MyStaDat.selectedIndex == 0
          ? ContentPage(
              title: "Station List",
              iconData: Icons.flag,
              index: 0,
              key: _myContentKeys[0],
              child: StationList(key: stListKey),
            )
          : MyStaDat.selectedIndex == 1
              ? ContentPage(
                  title: "Train List",
                  iconData: Icons.train,
                  panelButtons: createPanelDirBtns(),
                  index: 1,
                  key: _myContentKeys[1],
                  child: TrainList(key: trListKey),
                )
              : MyStaDat.selectedIndex == 2
                  ? ContentPage(
                      title: "Train Schedule",
                      iconData: Icons.table_chart_outlined,
                      panelButtons: createPanelDirBtns(),
                      index: 2,
                      key: _myContentKeys[2],
                      child: Schedules(key: schdleKey),
                    )
                  : ContentPage(
                      title: "Train Graph",
                      iconData: Icons.add_chart,
                      index: 3,
                      key: _myContentKeys[3],
                      child: TrainGraphs(key: graphKey),
                    )),
      !((MediaQuery.of(context).size.width >
                  MyResponsive.PHONEWIDTHMAX + MyResponsive.NAVBARWIDTH) &&
              MyStaDat.showSideNavBar)
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
    ]);
  }

  List<Widget> createPanelDirBtns() {
    bool isMobile = MediaQuery.of(context).size.width -
            (MyStaDat.showSideNavBar ? 0 : MyResponsive.NAVBARWIDTH) <
        MyResponsive.PHONEWIDTHMAX;

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
      // const SizedBox(
      //   width: 5,
      // ),
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
        width: isMobile ? 10 : 40,
      ),
    ];
  }

  void closeSideNavBar(BuildContext context) {
    if (!MyStaDat.showSideNavBar ||
        MediaQuery.of(context).size.width <=
            (MyResponsive.PHONEWIDTHMAX + MyResponsive.NAVBARWIDTH)) {
      Navigator.pop(context);
    }
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
      ).then((value) => reloadDataPage());
    } else if (MyStaDat.selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TrainList(
            isExpand: true,
          ),
          // builder: (context) => const SliverIndexPage(),
        ),
      ).then((value) => reloadDataPage());
    } else if (MyStaDat.selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Schedules(
            isExpand: true,
          ),
          // builder: (context) => const SliverIndexPage(),
        ),
      ).then((value) => reloadDataPage());
    } else if (MyStaDat.selectedIndex == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TrainGraphs(
            isExpand: true,
          ),
          // builder: (context) => const SliverIndexPage(),
        ),
      ).then((value) => reloadDataPage());
    }
  }

  Widget createSidebarContent(BuildContext context) {
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
                          enabled: MyStaDat.selectedIndex != 0,
                          selected: MyStaDat.selectedIndex == 0,
                          iconColor: MyAppColors.FONT_LIGHT_COLOR,
                          textColor: MyAppColors.FONT_LIGHT_COLOR,
                          leading: const Icon(
                            Icons.flag,
                          ),
                          title: const Text(
                            'Stations',
                          ),
                          onTap: () {
                            setState(() {
                              MyStaDat.selectedIndex = 0;
                            });
                          },
                        ),
                        ListTile(
                          enabled: MyStaDat.selectedIndex != 1,
                          selected: MyStaDat.selectedIndex == 1,
                          iconColor: MyAppColors.FONT_LIGHT_COLOR,
                          textColor: MyAppColors.FONT_LIGHT_COLOR,
                          leading: const Icon(
                            Icons.train,
                          ),
                          title: const Text(
                            'Trains',
                          ),
                          onTap: () {
                            setState(() {
                              MyStaDat.selectedIndex = 1;
                            });
                          },
                        ),
                        ListTile(
                          enabled: MyStaDat.selectedIndex != 2,
                          selected: MyStaDat.selectedIndex == 2,
                          iconColor: MyAppColors.FONT_LIGHT_COLOR,
                          textColor: MyAppColors.FONT_LIGHT_COLOR,
                          leading: const Icon(
                            Icons.schedule,
                          ),
                          title: const Text(
                            'Schedule',
                            style: textStyleLight,
                          ),
                          onTap: () {
                            setState(() {
                              MyStaDat.selectedIndex = 2;
                            });
                          },
                        ),
                        ListTile(
                          enabled: MyStaDat.selectedIndex != 3,
                          selected: MyStaDat.selectedIndex == 3,
                          iconColor: MyAppColors.FONT_LIGHT_COLOR,
                          textColor: MyAppColors.FONT_LIGHT_COLOR,
                          leading: const Icon(
                            Icons.auto_graph,
                          ),
                          title: const Text(
                            'Train Graph',
                            style: textStyleLight,
                          ),
                          onTap: () {
                            setState(() {
                              MyStaDat.selectedIndex = 3;
                            });
                          },
                        ),
                        Container(
                          color: MyAppColors.PRIMARY_COLOR,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 1,
                        ),
                        // ListTile(
                        //   leading: const Icon(
                        //     Icons.file_open,
                        //     color: MyAppColors.FONT_LIGHT_COLOR,
                        //   ),
                        //   title: const Text(
                        //     'Open File',
                        //     style: textStyleLight,
                        //   ),
                        //   onTap: () async {
                        //     closeSideNavBar(context);
                        //     FilePickerResult? result =
                        //         await FilePicker.platform.pickFiles(
                        //       type: FileType.custom,
                        //       allowedExtensions: ['xml', 'fpl'],
                        //     );

                        //     if (result != null) {
                        //       if (kIsWeb) {
                        //         Uint8List fileBytes = result.files.first.bytes!;
                        //         String contents =
                        //             String.fromCharCodes(fileBytes);
                        //         MyStaDat.A?.updateData(contents);
                        //         reloadDataPage();
                        //       } else {
                        //         File file = File(result.files.single.path!);
                        //         file.readAsString().then((String contents) {
                        //           MyStaDat.A?.updateData(contents);
                        //           reloadDataPage();
                        //         });
                        //       }
                        //     }
                        //   },
                        // ),
                        // ListTile(
                        //   leading: const Icon(
                        //     Icons.save,
                        //     color: MyAppColors.FONT_LIGHT_COLOR,
                        //   ),
                        //   title: const Text(
                        //     'Save File',
                        //     style: textStyleLight,
                        //   ),
                        //   onTap: () {
                        //     closeSideNavBar(context);
                        //     MyStFunc.saveFile(context);
                        //   },
                        // ),
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
                        const SizedBox(height: 60)
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
                    AboutListTile(
                      icon: const Icon(
                        Icons.info,
                      ),
                      applicationIcon: const Icon(
                        Icons.auto_graph,
                      ),
                      applicationName: MyStaDat.APPTITLE,
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2022 Royyan',
                      aboutBoxChildren: [
                        const SizedBox(height: 30),
                        const Text(
                          "e-mail: developerroyyan@gmail.com",
                          style: TextStyle(
                              color: MyAppColors.FONT_DARK_COLOR,
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const IndexPage(),
                                    // builder: (context) => const SliverIndexPage(),
                                  ));
                            },
                            child: Text("swap layout")),
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
}
