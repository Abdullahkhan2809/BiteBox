import 'package:flutter/material.dart';
import 'package:bitebox/views/widgets/floatingicons.dart';

class SignupAdmin extends StatefulWidget {
  const SignupAdmin({super.key});

  @override
  State<SignupAdmin> createState() => _SignupAdminState();
}

class _SignupAdminState extends State<SignupAdmin> {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!'), backgroundColor: Colors.red),
        );
        return;
      }
      setState(() => _isLoading = true);
      // Placeholder signup logic - prints data and shows success message
      // TODO: Integrate with Hive, Node.js backend, or auth service
      final data = {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
      };
      await Future.delayed(const Duration(seconds: 1)); // Simulate network
      print('Admin signup attempt: $data');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admin account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Clear fields
        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        // Navigate back or to dashboard
        Navigator.pop(context);
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
@override
  Widget build(BuildContext context) {
    final List<IconData> foodIcons = [
    Icons.fastfood,
    Icons.local_pizza,
    Icons.icecream,
    Icons.coffee,
    Icons.lunch_dining,
    Icons.bakery_dining,
    Icons.cake,
  ];
    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.primary, 

      
      body: Stack( 
children: [
          //floating icons
...List.generate(100, (index) {
            return FloatingFoodIcon(icon: foodIcons[index % foodIcons.length]);
          }),
          // safe area for the form
           SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Logo sits on the main background
                  Image.asset(
                    'assets/images/logo.jpg',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  Text('Fuel Campus life...!', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
        
                  ),),
                  const SizedBox(height: 20),
        
                  // 2. The White/Grey Auth Container
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 34, 31, 31),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Admin Signup',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255), // Dark text for the light box
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your admin account to get started',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 18),
                          
                          // The Form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _nameController,
                                  label: 'Full Name ',
                                  icon: Icons.person_outline,
                                  validator: (value) => (value == null || value.isEmpty) ? 'Enter name' : null,
                                ),
                                const SizedBox(height: 10),
_buildTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Enter email';
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter valid email';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
_buildTextField(
                                  controller: _phoneController,
                                  label: 'Phone',
                                  icon: Icons.phone_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Enter phone';
                                    if (value.length < 10 || !RegExp(r'^\d+$').hasMatch(value)) return 'Enter valid phone (10 digits)';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
_buildPasswordField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  obscure: _obscurePassword,
                                  onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Enter password';
                                    if (value.length < 8) return 'Password must be at least 8 characters';
                                    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(value)) {
                                      return 'Password must have upper, lower, number, symbol';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10),
_buildPasswordField(
                                  controller: _confirmPasswordController,
                                  label: 'Confirm Password',
                                  obscure: _obscureConfirmPassword,
                                  onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Confirm password';
                                    if (value != _passwordController.text) return 'Passwords do not match';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _signup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 240, 0, 0),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                              ),
                              child: _isLoading 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 14),
                  
                  // 3. Login Link (outside the box for better style)
                  TextButton(
                    onPressed: () => Navigator.maybePop(context),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                        children: [
                          TextSpan(text: 'Already have an account? '),
                          TextSpan(text: 'Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // The Label (White text above the field)
      Text(
        label,
        style: const TextStyle(
          color: Colors.white, // Label color
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        // Text the user types color
        style: const TextStyle(color: Colors.black87), 
        decoration: InputDecoration(
          hintText: 'Enter ${label.toLowerCase()}...',
          hintStyle: const TextStyle(color: Color(0xFF737373)), // Hint color
          prefixIcon: Icon(icon, color: const Color(0xFFE51A04)),
          filled: true,
          fillColor: const Color(0xFFE6E6E6), // Light grey background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none, // Removes the black outline
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    ],
  );
}

Widget _buildPasswordField({
  required TextEditingController controller,
  required String label,
  required bool obscure,
  required VoidCallback onToggle,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.white, // Label color
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: 'Password...',
          hintStyle: const TextStyle(color: Color(0xFF737373)),
          prefixIcon: const Icon(Icons.lock_outlined, color: Color(0xFFE51A04)),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: onToggle,
          ),
          filled: true,
          fillColor: const Color(0xFFE6E6E6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    ],
  );
}}