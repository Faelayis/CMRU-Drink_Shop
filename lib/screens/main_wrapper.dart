import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'setting/settings_screen.dart';
import 'menu/menu_screen.dart'; // Import หน้า Menu
import 'order/order_status_screen.dart'; // Import หน้า Order

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 1; // เริ่มต้นที่หน้า Home (Index 1)

  // รายการหน้าจอครบทั้ง 4 หน้า
  final List<Widget> _pages = [
    const MenuScreen(), // Index 0: Menu
    const HomeScreen(), // Index 1: Home
    const OrderScreen(), // Index 2: Order
    const SettingScreen(), // Index 3: Setting
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ใช้ Stack เพื่อให้ Bottom Bar ลอยอยู่เหนือเนื้อหา (Overlay)
      body: Stack(
        children: [
          // Layer 1: เนื้อหาของแต่ละหน้า
          _pages[_selectedIndex],

          // Layer 2: Custom Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 20, // ระยะห่างจากขอบล่าง
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF965A28), // สีน้ำตาลเข้ม
                  borderRadius: BorderRadius.circular(35), // ความโค้งมน
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // เงา
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildNavItem(Icons.coffee, "Menu", 0)),
                    Expanded(
                      child: _buildNavItem(Icons.home_outlined, "Home", 1),
                    ),
                    Expanded(child: _buildNavItem(Icons.list_alt, "Order", 2)),
                    Expanded(
                      child: _buildNavItem(
                        Icons.settings_outlined,
                        "Setting",
                        3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget สำหรับสร้างปุ่มแต่ละอันใน Navigation Bar
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;

    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          borderRadius: BorderRadius.circular(35),
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  // เปลี่ยนสีตามสถานะการเลือก
                  color: isSelected ? Colors.white : Colors.white70,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
