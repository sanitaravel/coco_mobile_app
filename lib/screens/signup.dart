import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFDFE1D3);
    const accentGreen = Color(0xFF73AE50);
    const darkText = Color(0xFF3D402E);
    const borderDark = Color(0xFF364027);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: darkText),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.network(
                    'http://localhost:3845/assets/c58cc52c0025e23a7e617dcc04b221cd5bfeab88.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Create your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'WixMadeforText',
                    fontWeight: FontWeight.bold,
                    color: darkText,
                    fontSize: 34,
                    height: 1.05,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // First & Last Name
              Text(
                'First Name',
                style: TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.w500,
                  color: darkText,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Last Name',
                style: TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.w500,
                  color: darkText,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email
              Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.w500,
                  color: darkText,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              Text(
                'Password',
                style: TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.w500,
                  color: darkText,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm
              Text(
                'Confirm Password',
                style: TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.w500,
                  color: darkText,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: borderDark, width: 3),
                  ),
                ),
              ),

              const SizedBox(height: 28),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final first = _firstNameController.text.trim();
                    final last = _lastNameController.text.trim();
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final confirm = _confirmController.text.trim();
                    if (first.isEmpty || last.isEmpty || email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill in all fields')),
                      );
                      return;
                    }
                    if (password != confirm) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Passwords do not match')),
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => Center(child: CircularProgressIndicator()),
                    );
                    try {
                      final auth = AuthService();
                      await auth.signUp(
                        _firstNameController.text.trim(),
                        _lastNameController.text.trim(),
                        email,
                        password,
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Account created successfully')),
                      );
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    } on Exception catch (e) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sign up failed: ${e.toString()}')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'WixMadeforText',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Already have an account? Log In',
                    style: TextStyle(
                      fontFamily: 'WixMadeforText',
                      fontWeight: FontWeight.w500,
                      color: accentGreen,
                      fontSize: 16,
                    ),
                  ),
                ),
              
              ),
            ],
          ),
        ),
      ),
    );
  }
}
