import 'package:bitebox/views/widgets/appbar.dart';
import 'package:flutter/material.dart';

class ResetpasswordAdmin extends StatefulWidget {
  const ResetpasswordAdmin({super.key});

  @override
  State<ResetpasswordAdmin> createState() => _ResetpasswordAdminState();
}

class _ResetpasswordAdminState extends State<ResetpasswordAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
      //appBar
      appBar: PreferredSize(preferredSize: const Size.fromHeight(74), child: AppbarWidget(title: "Reset Password")),


      //reset password 
      body : Center(
       child: ConstrainedBox(
         constraints: const BoxConstraints(maxWidth: 450),
         child: Center(
           child: ListView(
            padding: EdgeInsets.all(16),
              children:[ 
               const Text('Enter New Password',
                style: TextStyle(
                  fontFamily:'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w500
                ),),
                SizedBox(height: 20,),
                //Password field
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Enter Password',
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
                  //confirm password field
                   SizedBox(height: 20,),
                  TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
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
                      //button
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
                      child: Text('Confirm', style: TextStyle(
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