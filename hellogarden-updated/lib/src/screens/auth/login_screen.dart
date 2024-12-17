import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email and password are required');
      return;
    }

    try {
      // Sign in with Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        print('Login successful!');

        // Fetch the user's role from the profiles table
        final userId = response.user!.id;
        final profileResponse = await Supabase.instance.client
            .from('profiles')
            .select('role')
            .eq('id', userId)
            .maybeSingle(); // Fetch a single row if it exists

        if (profileResponse != null) {
          final role = profileResponse['role'] as String?;

          // Navigate based on the role
          if (role == 'admin') {
            Navigator.pushNamed(context, '/admin_dashboard');
          } else if (role == 'user') {
            Navigator.pushNamed(context, '/user_dashboard');
          } else {
            _showSnackBar('Unknown role: $role');
          }
        } else {
          _showSnackBar('Profile not found for this user');
        }
      } else {
        _showSnackBar('Invalid email or password');
      }
    } catch (error) {
      print('Login error: $error');
      _showSnackBar('An error occurred during login');
    }
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4DE165),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image.asset(
              'assets/images/logo.png',
              height: 150,
              width: 150,
            ),
            SizedBox(height: 40),
            Text(
              'LOGIN',
              style: GoogleFonts.irishGrover(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              onPressed: _login,
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Create new account?',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print('Forgot Password pressed');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            CustomButton2(
              text: 'Google',
              onPressed: _login,
            ),
            SizedBox(height: 10),
            CustomButton2(
              text: 'Facebook',
              onPressed: _login,
            ),
            SizedBox(height: 10),
            CustomButton2(
              text: 'Guest',
              onPressed: _login,
            ),
          ],
        ),
      ),
    );
  }
}
