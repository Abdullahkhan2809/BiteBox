import 'package:bitebox/views/admin/profile/admin_profile.dart';
import 'package:bitebox/views/admin/profile/editprofile.dart';

import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';



void main() async {
  // Ensure Flutter is ready before doing anything else
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
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
          secondary: Color.fromARGB(255, 255, 0, 0), 
          onSecondary: Colors.white, 
          tertiary: Color.fromARGB(255, 191, 49, 49),
          onTertiary: Colors.white,
          error: Colors.red,
          onError: Colors.white, 
          surface: Color(0xFF0A0A0F), 
          onSurface: Colors.white,
        ),
      ),
      // Ensure this matches your actual class name in dashboardscreen.dart
      home: const ProfileScreen(),
    );
  }
}