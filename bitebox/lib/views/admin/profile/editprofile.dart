import 'package:bitebox/core/routes.dart';
import 'package:bitebox/providers/auth_provider.dart';
import 'package:bitebox/services/storage_service.dart';
import 'package:bitebox/views/widgets/appbar.dart';
import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _restaurantnameController.dispose();
    _locationController.dispose();
    _biodescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.student != null) {
        setState(() {
          _nameController.text = auth.student?.name ?? '';
          _emailController.text = auth.student?.email ?? '';
          _phoneController.text = auth.student?.phone ?? '';
          _restaurantnameController.text = auth.student?.restaurantName ?? '';
          _locationController.text = auth.student?.location ?? '';
          _biodescriptionController.text = auth.student?.bio ?? '';
        });
      }
    });
  }

   Future<void> _saveChanges() async {
    if (_keyform.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final auth = context.read<AuthProvider>();
        final storage = StorageService();

        // 1. UPDATE THE BACKEND FIRST
        // You must send these changes to your Node.js/Postgres API so it saves globally.
        // Example: await ApiService().updateAdminProfile(name: _nameController.text, ...);

        // 2. IF BACKEND SUCCEEDS, UPDATE LOCAL HIVE CACHE
        await storage.updateUser(
          name: _nameController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          location: _locationController.text,
          restaurantName: _restaurantnameController.text,
          bio: _biodescriptionController.text,
        );

        // 3. REFRESH STATE
        await auth.loadUser();

        // 4. CHECK IF WIDGET IS STILL ALIVE
        if (!mounted) return;

        // 5. SHOW SUCCESS AND CLOSE SCREEN
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);

      } catch (e) {
        // Handle API errors gracefully
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        // Only stop the loading spinner if the user hasn't popped the screen
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:PreferredSize(preferredSize: const Size.fromHeight(74), child: AppbarWidget(title: 'Edit Profile',)),
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
                child: OutlinedButton(onPressed: (){
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: BBColors.red,
                  side: BorderSide(color: BBColors.red,),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
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
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          style: GoogleFonts.poppins(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter ${label.toLowerCase()}...',
            hintStyle: GoogleFonts.poppins(color: Color(0xFF737373)),
            filled: true,
            fillColor: BBColors.border,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),

            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }
