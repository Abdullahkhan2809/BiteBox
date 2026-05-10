import 'package:bitebox/core/routes.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetpasswordAdmin extends StatefulWidget {
  const ForgetpasswordAdmin({super.key});

  @override
  State<ForgetpasswordAdmin> createState() => _ForgetpasswordAdminState();
}

class _ForgetpasswordAdminState extends State<ForgetpasswordAdmin> {
  final _emailcontroller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final email = _emailcontroller.text.trim();
    if (email.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      // Phase 6: replace with real API call
      // final result = await AuthServices().forgotPassword(email: email);

      await Future.delayed(Duration(seconds: 1));

      if (mounted) {
        //pass email to otp screen
        Navigator.pushNamed(context, BiteBoxRoutes.otpVerify, arguments: email);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //background color
      backgroundColor: Theme.of(context).colorScheme.primary,
      //appBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: "Verify Password"),
      ),

      // enter email for the OtpVerficationAdmin
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Center(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                 Text(
                  'Enter your email here and we`ll send you the instructions on how to solve',
                  style: GoogleFonts.poppins(
                    
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _emailcontroller,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter your Email...',
                          hintStyle: GoogleFonts.poppins(color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isLoading? null : _sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 250, 0, 0),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        child: _isLoading? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: BBColors.muted,
                          ),
                        ):
                        Text(
                          'Reset Password',
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
