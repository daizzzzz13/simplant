import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/screens/auth/login_screen.dart';
import 'src/screens/auth/register_screen.dart';
import 'src/screens/dashboard/user_dashboard.dart';
import 'src/screens/dashboard/admin_dashboard.dart';

Future<void> main() async {
  // Ensure Flutter widgets are properly initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with your project details
  await Supabase.initialize(
    url: 'https://drpexseszcoloyexklad.supabase.co', // Replace with your Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRycGV4c2VzemNvbG95ZXhrbGFkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI1MDE4MjksImV4cCI6MjA0ODA3NzgyOX0.NMjOzOfFScAoN0r6Ldre4t7VdFR6dc7J4u_WRPrVxjU', // Replace with your Supabase anon key
  );

  // Run the Flutter app
  runApp(MyApp());
}

// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Auth App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        // Add other routes here
        '/register': (context) => RegisterScreen(),
        '/user_dashboard': (context) => UserDashboard(),
        '/admin_dashboard': (context) => AdminDashboard(),
      },
    );
  }
}
