import 'package:flutter/material.dart';
import 'package:inventory_manager/screens/menu_screen.dart';
import 'package:inventory_manager/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '在庫管理システム',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MenuScreen(),
    );
  }
}
