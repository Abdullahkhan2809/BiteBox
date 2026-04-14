import 'package:bitebox/views/widgets/appbar.dart';
import 'package:flutter/material.dart';

class ForgetpasswordAdmin extends StatefulWidget {
  const ForgetpasswordAdmin({super.key});

  @override
  State<ForgetpasswordAdmin> createState() => _ForgetpasswordAdminState();
}

class _ForgetpasswordAdminState extends State<ForgetpasswordAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //background color
      backgroundColor: Theme.of(context).colorScheme.primary,
      //appBar
      appBar: PreferredSize(preferredSize: const Size.fromHeight(74), child: AppbarWidget(title: "Verify Password")),

      // enter email for the OtpVerficationAdmin
     body : Center(
       child: ConstrainedBox(
         constraints: const BoxConstraints(maxWidth: 450),
         child: Center(
           child: ListView(
            padding: EdgeInsets.all(16),
              children:[ 
               const Text('Enter your email here and we`ll send you the instructions on how to solve',
                style: TextStyle(
                  fontFamily:'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w400
                ),),
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Enter your Email...',
                            hintStyle: const TextStyle(color: Colors.white),
                            floatingLabelBehavior:FloatingLabelBehavior.always,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2),
                            )
                        ),
                        
                      ),
                      SizedBox(height: 30,),
                      ElevatedButton(onPressed: (){}, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 250, 0, 0),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)
                     
                        )
                      ),
                      child: Text('Reset Password', style: TextStyle(
                        fontSize: 18,
                      ),), ),
                    ],
                  ),
                ),
            ]
            ),
         ),
       ),
     ),
    );
  }
}