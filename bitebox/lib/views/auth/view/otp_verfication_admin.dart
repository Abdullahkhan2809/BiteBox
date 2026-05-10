import 'package:bitebox/core/routes.dart';
import 'package:bitebox/core/toast.dart';
import 'package:bitebox/services/auth_services.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpVerficationAdmin extends StatefulWidget {
  final String email;
  const OtpVerficationAdmin({super.key, required this.email});

  @override
  State<OtpVerficationAdmin> createState() => _OtpVerficationAdminState();
}

class _OtpVerficationAdminState extends State<OtpVerficationAdmin> {
  String _otp = '';
  bool _isloading = false;

  Future<void> _verifyOtp() async {
    if (_otp.length < 5) {
      BBToast.showToast(context, 'Please enter the full code');
      return;
    }

    setState(() => _isloading = true);

    final result = await AuthServices().verifyOTP(email: widget.email, otp: _otp);

    if (mounted) {
      if (result['success']) {
        Navigator.pushNamed(
          context,
          BiteBoxRoutes.resetPassword,
          arguments: result['reset_token'],
        );
      } else {
        BBToast.showToast(context, result['message'] ?? 'Verification failed');
      }
    }

    setState(() => _isloading = false);
  }

  @override
  Widget build(BuildContext context) {
    //define the style for pinput
    final DefaultPintheme = PinTheme(
      width: 50,
      height: 60,
      textStyle:  GoogleFonts.poppins(
        fontSize: 22,
        color: Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Color(0xff990000),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      //appBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: "Enter OTP"),
      ),

      //ENTER THE OTP
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
               Text(
                'Enter code',
                style:GoogleFonts.poppins(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Enter the 5-digit code we sent to ${widget.email}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),

              // otp input
              Pinput(
                length: 5,
                defaultPinTheme: DefaultPintheme,
                focusedPinTheme: DefaultPintheme.copyWith(
                  decoration: DefaultPintheme.decoration!.copyWith(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                separatorBuilder: (index) => const SizedBox(width: 10),
                onChanged: (value) => _otp = value,
                onCompleted: (pin) => _verifyOtp(),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isloading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 250, 0, 0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: _isloading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Confirm',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
