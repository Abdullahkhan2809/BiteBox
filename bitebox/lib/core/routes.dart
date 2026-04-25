import 'package:bitebox/views/admin/add_menu_items.dart';
import 'package:bitebox/views/admin/admin_live_order.dart';
import 'package:bitebox/views/admin/dashboardscreen.dart';
import 'package:bitebox/views/admin/menu.dart';
import 'package:bitebox/views/admin/profile/admin_profile.dart';
import 'package:bitebox/views/admin/profile/editprofile.dart';
import 'package:bitebox/views/auth/view/forgetpassword_admin.dart';
import 'package:bitebox/views/auth/view/login_admin.dart';
import 'package:bitebox/views/auth/view/otp_verfication_admin.dart';
import 'package:bitebox/views/auth/view/resetpassword_admin.dart';
import 'package:bitebox/views/auth/view/signup_admin.dart';
import 'package:bitebox/views/user/aboutus.dart';
import 'package:bitebox/views/user/adduserdetails.dart';
import 'package:bitebox/views/user/cart_screen.dart';
import 'package:bitebox/views/user/checkout.dart';
import 'package:bitebox/views/user/home_screen.dart';
import 'package:bitebox/views/user/popup.dart';
import 'package:flutter/material.dart';

class BiteBoxRoutes{
    //  Auth
  static const String login           = '/login';
  static const String forgotPassword  = '/forgot-password';
  static const String resetPassword   = '/reset-password';
  static const String otpVerify       = '/otp-verify';
  static const String signup          = '/signup';

  //  Admin / Staff 
  static const String adminDashboard  = '/admin/dashboard';
  static const String adminLiveOrders = '/admin/live-orders';
  static const String adminAddItem    = '/admin/add-item';
  static const String adminMenu       = '/admin/menu';
  static const String adminProfile    = '/admin/profile';
  static const String adminEditProfile= '/admin/edit-profile';

  //  Student 
  static const String home            = '/student/home';
  static const String menu            = '/student/menu';
  static const String UserDetails      = '/student/UserDetails';
  static const String cart            = '/student/cart';
  static const String checkout        = '/student/checkout';
  static const String feedback        = '/student/feedback';
  static const String aboutUs         = '/student/about-us';
  static const String popup           = '/student/popup';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //authentications routes
      login: (_) => const LoginAdmin(),
      signup:(_)=> const SignupAdmin(),
      forgotPassword: (_)=> const ForgetpasswordAdmin(),
      resetPassword:(_)=> const ResetpasswordAdmin(),
      otpVerify: (_)=> const OtpVerficationAdmin(),

      //admin routes
      adminDashboard:(_)=> const DashboardScreen(),
      adminLiveOrders:(_)=>const AdminLiveOrder(),
      adminAddItem: (_)=> const AddmenuItems(),
      adminMenu: (_)=> const Menu(),
      adminProfile: (_)=> const ProfileScreen(),
      adminEditProfile: (_)=>  const Editprofile(),

      //user side routes
      home:(_)=>const UserHome(),
      // menu:(_)=>const 
      cart:(_)=>const CartScreen(),
      UserDetails:(_)=>const Adduserdetails(),
      feedback:(_)=>const Checkout(),
      aboutUs:(_)=>const Aboutus(),
      popup:(_)=>const Popup(),

    };
  }

  //pop to login as the login button clicked
  static void logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false);
  }
}