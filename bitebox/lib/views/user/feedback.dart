import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class Feedback extends StatefulWidget {
  const Feedback({super.key});

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  final _keyform=GlobalKey<FormState>();
  final _emailController=TextEditingController();
  final _nameController=TextEditingController();
  final _feedbackmsgController=TextEditingController();

  @override
  void disposal(){
    _emailController.dispose();
    _emailController.dispose();
    _feedbackmsgController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: BBColors.darkRed,
        toolbarHeight: 74,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom:Radius.circular(35) ),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:Image.asset('assets/images/logo.jpg', height: 74, fit: BoxFit.cover,),
            ),
            SizedBox(width: 20,),
           
            Text('Feedback', style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: 550,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: BBColors.surface2,
        ),
        child: Padding(

          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Feedback Form', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 16,),
              _buildTextField(controller: _emailController, label: 'Email', validator:(v) => (v == null || v.isEmpty) ? 'Name is required' : null ,),
              const SizedBox(height: 16,),
            _buildTextField(controller: _nameController, label: 'Name', validator: (v) {
               if (v == null || v.isEmpty) return 'Enter email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                    return 'Enter a valid email';
                  }
                  return null;
            } ,),
            const SizedBox(height: 16,),
            _buildTextField(controller: _feedbackmsgController, label: 'Message' ,maxLines: 7 , validator: (v) =>  (v == null || v.isEmpty) ? 'Enter Feedback!' : null,),
           const SizedBox(height: 16,),

            Align(
              alignment: AlignmentGeometry.bottomRight,
              child: ElevatedButton(
                onPressed: (){
                  //send msg or email me 
              }, 
              
              style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(BBColors.red),),
              child: Text('Send',style:TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(255, 255, 255, 255),
              
              ) ,),
                ),
            )
            ],
          ),
        ),
      ),
    );
  }
}


 Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter ${label.toLowerCase()}...',
            hintStyle: const TextStyle(color: BBColors.muted),
            filled: true,
            fillColor: BBColors.border,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }
