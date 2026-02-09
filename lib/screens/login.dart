import 'package:flutter/material.dart';
import 'signup.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
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
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Launch your social\nmedia journey!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'WixMadeforText',
                    fontWeight: FontWeight.bold,
                    color: darkText,
                    fontSize: 38,
                    height: 1.03,
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Email label + field
              Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.w500,
                  color: darkText,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: borderDark, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: borderDark, width: 3),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Password label + field
              Text(
                'Password',
                style: TextStyle(
                  fontFamily: 'WixMadeforText',
                  fontWeight: FontWeight.w500,
                  color: darkText,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: borderDark, width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: borderDark, width: 3),
                  ),
                ),
              ),

              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SignUpPage()),
                            );
                          },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'WixMadeforText',
                            fontWeight: FontWeight.w500,
                            color: accentGreen,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 16),
                  SizedBox(
                    width: 161,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please enter email and password')),
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
                          await auth.signIn(email, password);
                          Navigator.of(context).pop(); // remove progress
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Signed in successfully')),
                          );
                          Navigator.of(context).popUntil((r) => r.isFirst);
                        } on Exception catch (e) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sign in failed: ${e.toString()}')),
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
                        'Log In',
                        style: TextStyle(
                          fontFamily: 'WixMadeforText',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
