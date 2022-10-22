// ignore_for_file: prefer_const_constructors

import 'package:eltraingraph/fetchxmldata.dart';
import 'package:eltraingraph/index_page.dart';
import 'package:eltraingraph/index_page2.dart';
// import 'package:eltraingraph/login_page.dart';
import 'package:eltraingraph/mystaticdata.dart';
// import 'package:eltraingraph/rwfile.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MyStaDat.D = FetchXmlData();
  MyStaDat.D?.data();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      home: IndexPage2(),
      // home: TestWidget(),
      title: 'EltrainGraph',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
    );
  }
}

// class TestWidget extends StatefulWidget {
//   const TestWidget({super.key});

//   @override
//   State<TestWidget> createState() => _TestWidgetState();
// }

// class _TestWidgetState extends State<TestWidget> {
//   var data = [
//     ["a0", "b", "c", "d", "e", "f"],
//     ["a1", "b", "c", "d", "e", "f"]
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Test")),
//       body: Container(
//         // width: data[0].length * 80,
//         // height: data.length * 25,
//         color: Colors.red,
//         child: MultiplicationTable(
//           data: data,
//           width: 80,
//           height: 25,
//         ),
//       ),
//     );
//   }
// }
