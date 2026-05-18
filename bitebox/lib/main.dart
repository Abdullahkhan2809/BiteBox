import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bitebox/core/routes.dart';
import 'package:bitebox/models/menu_item_model.dart';
import 'package:bitebox/models/retaurant_model.dart';
import 'package:bitebox/providers/auth_provider.dart';
import 'package:bitebox/providers/cart_provider.dart';
import 'package:bitebox/providers/order_provider.dart';
import 'package:bitebox/providers/restaurant_provider.dart';
import 'package:bitebox/views/admin/admin_nav.dart';
import 'package:bitebox/views/auth/view/login_admin.dart';
import 'package:bitebox/views/user/home_screen.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  try {
    await Hive.initFlutter(directory.path);
    Hive.registerAdapter(MenuItemAdapter());
    Hive.registerAdapter(RestaurantAdapter());
    await Hive.openBox<MenuItem>('menu_items');
    await Hive.openBox<Restaurant>('restaurants');
    await Hive.openBox('userdata');
  } catch (e) {
    print('Hive error $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..loadSession()),
        ChangeNotifierProvider(create: (context) => RestaurantProvider()..loadRestaurants()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
      routes: {
        '/': (_) => AnimatedSplashScreen(
          duration: 2000,
          splash: Image.asset('assets/images/logo.jpg'),
          splashIconSize: 200,
          splashTransition: SplashTransition.scaleTransition,
          pageTransitionType: PageTransitionType.bottomToTop,
          backgroundColor: BBColors.darkRed,
          nextScreen: Consumer<AuthProvider>(
            builder: (context, auth, _) {
              if (auth.isStaff) return const AdminNav(index: 0);
              if (auth.isStudent) return const UserHome();
              return const LoginAdmin();
            },
          ),
        ),
        ...BiteBoxRoutes.getRoutes(),
      },
    );
  }
}