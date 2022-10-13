// ignore_for_file: constant_identifier_names

import 'package:eltraingraph/fetchxmldata.dart';
import 'package:eltraingraph/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class MyStaDat {
  static const String APPTITLE = "EltrainGraph";
  static const String APPTITLE_LONG = "Elsicom Train Graph";
  // static const String SCHEDULE = "Schedule";
  // static const String STATION = "Station";
  // static const String TRAINS = "Trains";
  // static const String TGRAPH = "Graph";
  static var scrollState = List.filled(4, 0.0, growable: false);
  static bool showSideNavBar = true;
  static int selectedIndex = 0;
  static int selectedIndexTrain = 0;
  static FetchXmlData? A;
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

  static List<dynamic> loadStation(XmlDocument document) {
    final temporaryList = [];
    final traingraphNode = document
        .findElements('jTrainGraph_timetable')
        .first
        .findElements('stations')
        .first;
    final station = traingraphNode.findElements('sta');
    // loop through the document and extract values
    for (final sta in station) {
      final temporaryTracks = [];
      final tracks = sta.findElements('track');

      for (final track in tracks) {
        temporaryTracks.add({'name': track.getAttribute('name')});
      }
      temporaryList.add({
        'name': sta.getAttribute("name"),
        'kml': sta.getAttribute('kml'),
        'kmr': sta.getAttribute('kmr'),
        'cl': sta.getAttribute('cl'),
        'sh': sta.getAttribute('sh'),
        'sz': sta.getAttribute('sz'),
        'sy': sta.getAttribute('sy'),
        'sri': sta.getAttribute('sri'),
        'sra': sta.getAttribute('sra'),
        'tr': sta.getAttribute('tr'),
        'dTi': sta.getAttribute('dTi'),
        'dTa': sta.getAttribute('dTa'),
        'tracks': temporaryTracks
      });
    }

    temporaryList.sort(
        (a, b) => double.parse(a['kml']).compareTo(double.parse(b['kml'])));

    return temporaryList;
  }
}
