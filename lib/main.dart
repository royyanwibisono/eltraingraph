// ignore_for_file: prefer_const_constructors

import 'package:eltraingraph/fetchxmldata.dart';
import 'package:eltraingraph/index_page.dart';
// import 'package:eltraingraph/login_page.dart';
import 'package:eltraingraph/mystaticdata.dart';
// import 'package:eltraingraph/rwfile.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MyStaDat.A = FetchXmlData();
  MyStaDat.A?.data();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      home: IndexPage(),
      // home: WebDownload(),
      title: 'EltrainGraph',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
    );
  }
}
