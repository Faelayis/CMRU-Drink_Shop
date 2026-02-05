import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/env.dart';
import 'screens/splash/splash_screen.dart'; // เรียกใช้หน้า Splash Screen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env', isOptional: true);

  final supabaseUrl = Env.supabaseUrl;
  final supabaseAnonKey = Env.supabaseAnonKey;
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception('Missing Supabase environment values.');
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const BrewlyApp());
}

class BrewlyApp extends StatelessWidget {
  const BrewlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brewly Drink Shop',
      theme: ThemeData(
        fontFamily: 'Serif', // ตั้งค่าฟอนต์หลัก
        scaffoldBackgroundColor: const Color(0xFFF3E9D9), // สีพื้นหลังครีม
        primaryColor: const Color(0xFF965A28), // สีน้ำตาลหลัก
        useMaterial3: true,
      ),
      // กำหนดให้เริ่มทำงานที่หน้า SplashScreen เป็นหน้าแรก
      home: const SplashScreen(),
    );
  }
}
