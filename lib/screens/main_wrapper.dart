import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'setting/settings_screen.dart';
import 'menu/menu_screen.dart';
import 'order/order_status_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const MenuScreen(),
    const HomeScreen(),
    const OrderScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],

          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF965A28),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
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
