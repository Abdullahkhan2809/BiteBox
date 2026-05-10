import 'package:bitebox/core/routes.dart';
import 'package:bitebox/core/toast.dart';
import 'package:bitebox/services/auth_services.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetpasswordAdmin extends StatefulWidget {
  final String resetToken;
  const ResetpasswordAdmin({super.key, required this.resetToken});

  @override
  State<ResetpasswordAdmin> createState() => _ResetpasswordAdminState();
}

class _ResetpasswordAdminState extends State<ResetpasswordAdmin> {
  final _newpasswordController = TextEditingController();
  final _confirmpasswordContorller = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    _newpasswordController.dispose();
    _confirmpasswordContorller.dispose();
    super.dispose();
  }

  Future<void> _resetpassword() async {
    if (_newpasswordController.text != _confirmpasswordContorller.text) {
      BBToast.showToast(context, 'Passwords do not Match');
      return;
    }
    if (_newpasswordController.text.isEmpty) {
      BBToast.showToast(context, 'Please enter a password');
      return;
    }

    setState(() => _isloading = true);

    final result = await AuthServices().resetpassword(
      resetToken: widget.resetToken,
      newPassword: _newpasswordController.text,
    );

    if (mounted) {
      BBToast.showToast(context, result['message'] ?? 'Password reset successfully!');
      // go back to login and clear all routes
      Navigator.pushNamedAndRemoveUntil(
        context,
        BiteBoxRoutes.login,
        (route) => false,
      );
    }
    setState(() => _isloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      //appBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: AppbarWidget(title: "Reset Password"),
      ),

      //reset password
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Center(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                const Text(
                  'Enter New Password',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                //Password field
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _newpasswordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(color: Colors.white),
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
                      //confirm password field
                      SizedBox(height: 20),
                      TextField(
                        controller: _confirmpasswordContorller,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: const TextStyle(color: Colors.white),
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
                      //button
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isloading ? null : _resetpassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 250, 0, 0),
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
                            : Text('Confirm',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
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
