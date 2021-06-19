import 'package:call_log/call_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/models/todos.dart';
import 'package:flutter_contacts/screens/nav_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

final boxA = Provider<List<Todo>>((ref) => throw UnimplementedError());


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  final openHive  = await Hive.openBox<Todo>('todo');
  runApp(ProviderScope(
      overrides: [
        boxA.overrideWithValue(openHive.values.toList().cast<Todo>()),
      ],
      child: Home()));
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white
        )
      ),
      debugShowCheckedModeBanner: false,
      home: NavScreen(),
    );
  }
}


