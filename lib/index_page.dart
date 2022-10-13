import 'package:eltraingraph/login_page.dart';
import 'package:eltraingraph/mycolors.dart';
import 'package:eltraingraph/myresponsive.dart';
import 'package:eltraingraph/content_widget.dart';
import 'package:eltraingraph/mystaticdata.dart';
import 'package:eltraingraph/stationlist_widget.dart';
import 'package:eltraingraph/trainlist_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController? tabController = null;
  double appBarWidth = MyResponsive.PHONEWIDTHMAX;
  List<GlobalKey<ContentPageState>> _myContentKeys = [
    new GlobalKey<ContentPageState>(),
    new GlobalKey<ContentPageState>(),
    new GlobalKey<ContentPageState>(),
    new GlobalKey<ContentPageState>()
  ];
  GlobalKey<TrainListState> trListKey = GlobalKey<TrainListState>();
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) => postInitState());
  // }

  // void postInitState() {
  //   tabController!.index = MyStaDat.selectedIndex;
  // }

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
        child: StationList(),
        index: 0,
        key: _myContentKeys[0],
      ),
      ContentPage(
        title: "Train List",
        iconData: Icons.train,
        panelButtons: [
          ElevatedButton(
            onPressed: () {
              if (MyStaDat.selectedIndexTrain != 0) {
                setState(() {
                  MyStaDat.selectedIndexTrain = 0;
                  trListKey.currentState!.loadData();
                });
              }
            },
            style: MyStaDat.selectedIndexTrain == 0
                ? MyStaDat.styleBtnPanelAct
                : MyStaDat.styleBtnPanelInAct,
            child:
                MediaQuery.of(context).size.width < MyResponsive.PHONEWIDTHMAX
                    ? Text('to RIGHT')
                    : Text('Direction to RIGHT'),
          ),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
            child:
                MediaQuery.of(context).size.width < MyResponsive.PHONEWIDTHMAX
                    ? Text('to LEFT')
                    : Text('Direction to LEFT'),
            onPressed: () {
              if (MyStaDat.selectedIndexTrain != 1) {
                setState(() {
                  MyStaDat.selectedIndexTrain = 1;
                  trListKey.currentState!.loadData();
                });
              }
            },
            style: MyStaDat.selectedIndexTrain == 1
                ? MyStaDat.styleBtnPanelAct
                : MyStaDat.styleBtnPanelInAct,
          ),
          SizedBox(
            width: 40,
          ),
        ],
        index: 1,
        key: _myContentKeys[1],
        child: TrainList(key: trListKey),
      ),
      ContentPage(
        title: "Train Schedule",
        iconData: Icons.table_chart_outlined,
        child: Center(child: Text("Train Schedule")),
        index: 2,
        key: _myContentKeys[2],
      ),
      ContentPage(
        title: "Train Graph",
        iconData: Icons.add_chart,
        child: Container(),
        index: 3,
        key: _myContentKeys[3],
      )
    ];
  }

  Stack createSidebarContent(BuildContext context) {
    return Stack(
      children: [
        ListView(
          // Important: Remove any padding from the ListView.
          // padding: EdgeInsets.zero,
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
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Information",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyAppColors.FONT_LIGHT_COLOR),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                          color: MyAppColors.FONT_LIGHT_COLOR, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'The information is ',
                            style:
                                TextStyle(color: MyAppColors.FONT_LINK_COLOR)),
                        TextSpan(
                            text:
                                'from the output, you can see that the spacing is '),
                        TextSpan(
                            text:
                                'important to determine whether multiple texts '),
                        TextSpan(text: 'should be treated as one word or not.'),
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
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                      ),
                      title: const Text('Sign Out'),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
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
