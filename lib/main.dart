import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'networks/dio/dio.dart';
import 'provider/data_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioSingleton.instance.create();
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Issue App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black54),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter issues'),
    );
  }
}
