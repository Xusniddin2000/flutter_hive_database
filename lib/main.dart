import 'package:flutter/material.dart';
import 'package:flutter_hive_database/core/router/router.dart';
import 'package:flutter_hive_database/service/client_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{

     await  Hive.initFlutter();



     runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.router.onGenerator,
       initialRoute: 'login',
      debugShowCheckedModeBanner: false,

    );
  }
}


