import 'package:bitebox/views/user/feedback.dart' as user_feedback;
import 'package:bitebox/views/user/home_screen.dart';
import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive initialization
  await Hive.initFlutter();
  await Hive.openBox('userdata');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF7D0A0A),
          onPrimary: Colors.white,
          secondary: Color(0xFFFF0000),
          onSecondary: Colors.white,
          tertiary: Color(0xFFBF3131),
          onTertiary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Color(0xFF0A0A0F),
          onSurface: Colors.white,
        ),
      ),

      home: const user_feedback.Feedback(),
    );
  }
}