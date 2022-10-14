import 'package:flutter/services.dart';
import 'package:xml/xml.dart' as xml;

class FetchXmlData {
  xml.XmlDocument? document;
  List<dynamic>? stationlist;
  List<dynamic>? trainlistA;
  List<dynamic>? trainlistI;

  // xml.XmlDocument? get document => _document;

  void updateData(String xmlDataString) {
    try {
      var tdocument = xml.XmlDocument.parse(xmlDataString);
      var validelemen = tdocument.findElements('jTrainGraph_timetable');
      if (validelemen.isNotEmpty) {
        document = tdocument;

        stationlist = [];
        final traingraphNode = document!
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
          stationlist!.add({
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

        stationlist!.sort(
            (a, b) => double.parse(a['kml']).compareTo(double.parse(b['kml'])));

        trainlistA = [];
        trainlistI = [];
        final trainsNode = document!
            .findElements('jTrainGraph_timetable')
            .first
            .findElements('trains')
            .first;

        final trainA = trainsNode.findElements('ta');
        final trainI = trainsNode.findElements('ti');
        // loop through the document and extract values
        for (final ta in trainA) {
          final temporaryTimeTable = [];
          final timetable = ta.findElements('t');

          for (final t in timetable) {
            temporaryTimeTable.add({
              'a': t.getAttribute('a'),
              'd': t.getAttribute('d'),
              'at': t.getAttribute('at'),
              'dt': t.getAttribute('dt'),
            });
          }
          trainlistA!.add({
            'name': ta.getAttribute("name"),
            "cm": ta.getAttribute("cm"),
            "cl": ta.getAttribute("cl"),
            "sh": ta.getAttribute("sh"),
            "sz": ta.getAttribute("sz"),
            "sy": ta.getAttribute("sy"),
            "d": ta.getAttribute("d"),
            "id": ta.getAttribute("d"),
            't': temporaryTimeTable
          });
        }

        trainlistA!
            .sort((a, b) => int.parse(a['id']).compareTo(int.parse(b['id'])));

        for (final ti in trainI) {
          final temporaryTimeTable = [];
          final timetable = ti.findElements('t');

          for (final t in timetable) {
            temporaryTimeTable.add({
              'a': t.getAttribute('a'),
              'd': t.getAttribute('d'),
              'at': t.getAttribute('at'),
              'dt': t.getAttribute('dt'),
            });
          }
          trainlistI!.add({
            'name': ti.getAttribute("name"),
            "cm": ti.getAttribute("cm"),
            "cl": ti.getAttribute("cl"),
            "sh": ti.getAttribute("sh"),
            "sz": ti.getAttribute("sz"),
            "sy": ti.getAttribute("sy"),
            "d": ti.getAttribute("d"),
            "id": ti.getAttribute("d"),
            't': temporaryTimeTable
          });
        }

        trainlistI!
            .sort((a, b) => int.parse(a['id']).compareTo(int.parse(b['id'])));
      }
    } catch (e) {
      print('There is an xml reading exception!');
    }
  }

  data() async {
    // max size 50KB!!
    var xmlDataString =
        (await rootBundle.loadString("assets/traingraphday.xml"));
    // (await rootBundle.loadString("assets/employee.xml"));

    updateData(xmlDataString);
  }
}
