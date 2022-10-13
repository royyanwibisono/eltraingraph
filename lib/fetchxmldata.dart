import 'package:flutter/services.dart';

class FetchXmlData {
  String _traingraphxml = "";

  String get traingraphxml => _traingraphxml;

  set traingraphxml(String traingraphxml) {
    _traingraphxml = traingraphxml;
  }

  data() async {
    // max size 50KB!!
    _traingraphxml = (await rootBundle.loadString("assets/traingraphday.xml"));
    // (await rootBundle.loadString("assets/employee.xml"));
  }
}
