// ignore_for_file: constant_identifier_names

import 'package:eltraingraph/fetchxmldata.dart';
import 'package:eltraingraph/mycolors.dart';
import 'package:flutter/material.dart';

class MyStaDat {
  static const String APPTITLE = "EltrainGraph";
  static const String APPTITLE_LONG = "Elsicom Train Graph";
  static var scrollState = List.filled(4, 0.0, growable: false);
  static bool showSideNavBar = true;
  static int selectedIndex = 0;
  static int selectedIndexTrain = 0;
  static FetchXmlData? D;
  static var styleBtnPanelAct = ElevatedButton.styleFrom(
    backgroundColor: MyAppColors.PANEL_COLOR,
    minimumSize: const Size(40, 40),
    foregroundColor: MyAppColors.FONT_DARK_COLOR,
    elevation: 4,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5), topRight: Radius.circular(5)),
    ),
  );
  static var styleBtnPanelInAct = ElevatedButton.styleFrom(
    backgroundColor: MyAppColors.PANEL_COLOR_INACT,
    minimumSize: const Size(40, 40),
    foregroundColor: MyAppColors.FONT_DARK_COLOR,
    elevation: 4,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5), topRight: Radius.circular(5)),
    ),
  );
  static String dirRight = "Trains to RIGHT direction";
  static String dirLeft = "Trains to LEFT direction";
  static Size tableCellSize = const Size(100.0, 25.0);
}
