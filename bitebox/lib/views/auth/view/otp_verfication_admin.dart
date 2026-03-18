import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
class OtpVerficationAdmin extends StatefulWidget {
  const OtpVerficationAdmin({super.key});

  @override
  State<OtpVerficationAdmin> createState() => _OtpVerficationAdminState();
}

class _OtpVerficationAdminState extends State<OtpVerficationAdmin> {
  @override
  Widget build(BuildContext context) {
    //define the style for pinput
    final DefaultPintheme = PinTheme(
        width: 50,
        height: 60,
        textStyle: const TextStyle(
          fontSize: 22,
          color: Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
        ),
        decoration:BoxDecoration(
          color: Color(0xff990000),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red,width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3)
            ), 
          ],
        ), 
    );
    return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
      //appBar
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(),
        clipBehavior: Clip.antiAlias,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              child: Image.asset('assets/images/logo.jpg', 
              height: 60,
              width: 60,
              fit: BoxFit.fill,
              )
            ),
             const SizedBox(width: 10),
            const Text(
              'ENTER OTP',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      //ENTER THE OTP
      body : Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Enter code',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Enter the 5-digit code we sent you at your Gmail.',
                style: TextStyle(
                  fontFamily: 'Poppins',
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
                onCompleted: (pin) => print(pin),
              ),
              
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: () {
                  // Logic to verify OTP
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 250, 0, 0),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: const Text(
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
