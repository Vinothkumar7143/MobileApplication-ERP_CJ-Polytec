import 'package:cj_polytec/Inward.dart';
import 'package:cj_polytec/LOCICHANGE.dart';
import 'package:cj_polytec/Out(FG).dart';
import 'package:cj_polytec/Out(RM/BOP).dart';
import 'package:flutter/material.dart';

import 'CJLogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CJLogin(),

    );
  }
}
