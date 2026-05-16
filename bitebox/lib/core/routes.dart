import 'package:bitebox/views/admin/add_menu_items.dart';
import 'package:bitebox/views/admin/admin_live_order.dart';
import 'package:bitebox/views/admin/admin_nav.dart';
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
import 'package:bitebox/views/user/feedback.dart' as bb_feedback;
import 'package:bitebox/views/user/home_screen.dart';
import 'package:bitebox/views/user/popup.dart';
import 'package:bitebox/views/user/restaurent_menu_screen.dart';
import 'package:bitebox/models/retaurant_model.dart';
import 'package:flutter/material.dart';

class BiteBoxRoutes {
  //  Auth
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String otpVerify = '/otp-verify';
  static const String signup = '/signup';

  //  Admin / Staff
  static const String adminRoot = '/admin';
  static const String adminAddItem = '/admin/add-item';
  static const String adminProfile = '/admin/profile';
  static const String adminEditProfile = '/admin/edit-profile';
  static const String adminLiveOrders = '/admin/adminLiveOrders';

  //  Student
  static const String home = '/student/home';
  static const String menu = '/student/menu';
  static const String UserDetails = '/student/UserDetails';
  static const String cart = '/student/cart';
  static const String checkout = '/student/checkout';
  static const String feedback = '/student/feedback';
  static const String aboutUs = '/student/about-us';
  static const String popup = '/student/popup';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      //authentications routes
      login: (_) => const LoginAdmin(),
      signup: (_) => const SignupAdmin(),
      forgotPassword: (_) => const ForgetpasswordAdmin(),
      
      otpVerify: (context){
        final email= ModalRoute.of(context)!.settings.arguments as String;
        return OtpVerficationAdmin(email:email);
      },

      resetPassword:(context){
        final resetToken=ModalRoute.of(context)!.settings.arguments as String;
        return ResetpasswordAdmin(resetToken:resetToken);
      },

      //admin routes

      adminAddItem: (_) => const AddmenuItems(),
      adminProfile: (_) => const ProfileScreen(),
      adminEditProfile: (_) => const Editprofile(),
      adminLiveOrders:(_)=> const AdminLiveOrder(),
      adminRoot: (context) {
        final index = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
        return AdminNav(index: index);
      },
      //user side routes
      home: (_) => const UserHome(),
      menu: (context) {
        final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
        return RestaurentMenuScreen(restaurant: restaurant);
      },
      cart: (_) => const CartScreen(),
      UserDetails: (_) => const Adduserdetails(),
      feedback: (_) => const bb_feedback.Feedback(),
      aboutUs: (_) => const Aboutus(),
      popup: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return OrderConfirmationPopup(
          customerName: args?['customerName'],
          cmsId: args?['cmsId'],
          items: args?['items'],
          totalAmount: args?['totalAmount'],
          paymentMethod: args?['paymentMethod'],
        );
      },
      checkout:(_)=> const Checkout(),
    };
  }

  //pop to login as the login button clicked
  static void logout(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false);
  }
}
