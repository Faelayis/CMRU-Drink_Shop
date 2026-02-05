import 'package:flutter/material.dart';
import '../main_wrapper.dart'; // import หน้า MainWrapper (ตรวจสอบ path ให้ตรงกับโปรเจกต์จริง)

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ตั้งเวลา 3 วินาที แล้วเปลี่ยนไปหน้า MainWrapper
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // ใช้ pushReplacement เพื่อไม่ให้กด Back กลับมาหน้านี้ได้
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9D9), // สีพื้นหลังครีม
      body: Stack(
        children: [
          // ส่วนเนื้อหาตรงกลาง (โลโก้ + ข้อความ)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. โลโก้ (จำลองเมล็ดกาแฟ + กล่อง 3D)
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // พื้นหลังเมล็ดกาแฟ (Placeholder)
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.brown.shade800, // แทนกลุ่มเมล็ดกาแฟ
                          image: const DecorationImage(
                            // ในโปรเจกต์จริง ใช้ Image.asset('assets/images/coffee_beans_bg.png')
                            image: NetworkImage(
                              'https://via.placeholder.com/260/3e2723/FFFFFF?text=Coffee+Beans',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // โลโก้ Brewly ตรงกลาง
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFC69C6D,
                          ), // สีน้ำตาลอ่อนของโลโก้
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
                            Icon(
                              Icons.coffee,
                              size: 60,
                              color: Colors.white,
                            ), // แทนรูปแก้วยิ้ม
                            SizedBox(height: 5),
                            Text(
                              "Brewly",
                              style: TextStyle(
                                fontFamily: 'Cursive', // หรือฟอนต์ลายมืออื่นๆ
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

                // 2. ข้อความ "Brewly CoffeE" แบบมีขอบ (Outlined Text Style)
                _buildOutlinedText("Brewly", fontSize: 60),
                const SizedBox(height: 10),
                _buildOutlinedText("CoffeE", fontSize: 50),
              ],
            ),
          ),

          // 3. รูปแก้วเครื่องดื่มมุมซ้ายล่าง
          Positioned(
            left: 20,
            bottom: 40,
            child: Container(
              height: 180,
              width: 120,
              // ในโปรเจกต์จริง ใช้ Image.asset('assets/images/caramel_drink.png')
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://via.placeholder.com/150x200/transparent/brown?text=Drink',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้างข้อความแบบมีขอบ (Outline Text Effect)
  Widget _buildOutlinedText(String text, {required double fontSize}) {
    return Stack(
      children: [
        // ขอบสีดำ (วาดข้อความซ้อนกันโดยใช้ Stroke)
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Serif', // ใช้ฟอนต์หลักของแอป
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..color = Colors.black,
          ),
        ),
        // สีเนื้อใน (สีขาว)
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
