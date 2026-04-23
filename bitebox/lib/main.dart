import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bitebox/models/menu_item_model.dart';
import 'package:bitebox/models/retaurant_model.dart';
import 'package:bitebox/views/admin/add_menu_items.dart';
import 'package:bitebox/views/user/aboutus.dart';

import 'package:bitebox/views/user/home_screen.dart';
import 'package:bitebox/views/user/restaurent_menu_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:bitebox/views/widgets/colors.dart';
import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bitebox/views/admin/dashboardscreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive initialization
    try{
    await Hive.initFlutter();
    await Hive.openBox('userdata');
} catch(e){
  print('Hive error $e');
}

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

      home:AnimatedSplashScreen(
      duration: 2000,
      splash:  Image.asset('assets/images/logo.jpg',),
      splashIconSize: 200,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      nextScreen: const Aboutus(),
      backgroundColor: BBColors.darkRed,
      ));
  }
}