import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  // สมมติว่าเก็บค่าภาษาปัจจุบันไว้ (ในแอปจริงอาจจะดึงจาก Provider/SharedPref)
  String _selectedLanguageCode = 'en'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9D9), // สีพื้นหลังครีม
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3E9D9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4E342E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- ส่วนหัวข้อ ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Text(
              "Language",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif', // ฟอนต์มีเชิงตามสไตล์แอป
                color: Color(0xFF4E342E),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- ส่วนรายการเมนู (Card สีเข้มกว่า) ---
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFEADCC6), // สีพื้นหลังของ Card (เข้มกว่า Background นิดหน่อย)
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32), // มุมโค้งด้านบน
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
                child: Column(
                  children: [
                    _buildLanguageItem(
                      label: "English",
                      code: "en",
                      isSelected: _selectedLanguageCode == 'en',
                    ),
                    _buildDivider(),
                    _buildLanguageItem(
                      label: "Thai",
                      code: "th",
                      isSelected: _selectedLanguageCode == 'th',
                    ),
                    _buildDivider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget สร้างรายการภาษาแต่ละบรรทัด
  Widget _buildLanguageItem({
    required String label, 
    required String code, 
    required bool isSelected
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguageCode = code;
        });
        // ตรงนี้ใส่ Logic เปลี่ยนภาษาของแอปจริงๆ ได้เลย
        // context.setLocale(...) 
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: const Color(0xFF4E342E),
              ),
            ),
            Icon(
              Icons.chevron_right, // ไอคอนลูกศรชี้ขวาตามภาพ
              color: const Color(0xFF4E342E).withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Widget เส้นขีดคั่นบางๆ
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: const Color(0xFF4E342E).withOpacity(0.2),
      ),
    );
  }
}
