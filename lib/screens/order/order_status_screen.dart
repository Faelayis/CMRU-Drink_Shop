import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9D9),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Text(
                "ORDER",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                  color: Color(0xFF4E342E),
                ),
              ),
            ),

            // Empty state (ไม่มีรายการสั่งซื้อให้แสดง)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  100,
                ), // เว้นที่ด้านล่างให้ Nav Bar
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 72,
                            color: Colors.brown.withOpacity(0.2),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No orders yet",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
