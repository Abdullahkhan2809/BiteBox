import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
    //controller declaration
  final _keyform=GlobalKey<FormState>();
  final _nameController=TextEditingController();
  final _emailController=TextEditingController();
  final _phoneController=TextEditingController();
  final _restaurantnameController=TextEditingController();
  final _locationController=TextEditingController();
  final _biodescriptionController=TextEditingController();

  bool _isLoading=false;

   //desposal function when controllers are saved or cancel then destroyed
  void disposal(){
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _restaurantnameController.dispose();
    _locationController.dispose();
    _biodescriptionController.dispose();
  }

    Future<void> _saveChanges() async {
    if (_keyform.currentState!.validate()) {
      setState(() => _isLoading = true);

      // TODO: Replace with your actual save logic (Hive / backend)
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(preferredSize: const Size.fromHeight(74), child: AppbarWidget(title: 'Edit Profile')),
      //body
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _keyform,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BBColors.surface2,
              borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //avatar for the picture
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: BBColors.red,
                          width: 3,
                        )
                      ),
                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: BBColors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
            
                        child: IconButton(onPressed: (){}, 
                        icon: Icon(Icons.edit_outlined)),
                      )
                      )
                  ],
                ),
                const SizedBox(height: 8,),
                TextButton(onPressed: (){
                  //open image picker
                },
                child: Text('Change Photo', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: BBColors.darkRed,
                ),)),
                const SizedBox(height: 14,),
               //name text field
              _buildTextField(controller:_nameController , label:'Full Name', validator:(v) => (v == null || v.isEmpty) ? 'Enter name' : null,),
              const SizedBox(height:12,),

              _buildTextField(controller:_emailController , 
                label:'Email', 
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter email';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                ),

              const SizedBox(height:12,),
              _buildTextField(controller:_phoneController , label:'Phone Number',
              keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter phone';
                  if (v.length < 10) return 'Enter at least 10 digits';
                  return null;
                },
                ),
              const SizedBox(height:12,),
              _buildTextField(controller:_restaurantnameController , label:'Restaurant Name',
                validator: (v) => (v == null || v.isEmpty) ? 'Enter restaurant name' : null,
              ),
              const SizedBox(height:12,),
              _buildTextField(controller:_locationController , label:'Location',
               validator: (v) => (v == null || v.isEmpty) ? 'Enter location' : null,
              ),
              const SizedBox(height:12,),
               _buildTextField(controller:_biodescriptionController , label:'Bio / Description',maxLines:4,
               validator:null),
              const SizedBox(height:24,),
              //ElevatedButton to save
                  SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BBColors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
          
              const SizedBox(height: 12,),
              //Cacnel Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: BBColors.red,
                  side: BorderSide(color: BBColors.red,),
                  padding: const EdgeInsets.symmetric(vertical: 20)
                ),
                 child:const Text('Cancel',
                 style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                 ),) ,
              )
              )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//text field

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
            hintStyle: const TextStyle(color: Color(0xFF737373)),
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
