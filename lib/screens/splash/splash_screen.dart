import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/login/login_screen.dart';
import '../main_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _routeNext();
  }

  Future<void> _routeNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;
    final next = session == null ? const LoginScreen() : const MainWrapper();

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => next));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9D9),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.brown.shade800,
                          image: const DecorationImage(
                            image: NetworkImage(''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC69C6D),
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.coffee, size: 60, color: Colors.white),
                            SizedBox(height: 5),
                            Text(
                              "Brewly",
                              style: TextStyle(
                                fontFamily: 'Cursive',
                                fontSize: 24,
                                color: Color(0xFF5D4037),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                _buildOutlinedText("Brewly", fontSize: 60),
                const SizedBox(height: 10),
                _buildOutlinedText("CoffeE", fontSize: 50),
              ],
            ),
          ),

          Positioned(
            left: 20,
            bottom: 40,
            child: Container(
              height: 180,
              width: 120,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: NetworkImage(''),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedText(String text, {required double fontSize}) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Serif',
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Serif',
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
