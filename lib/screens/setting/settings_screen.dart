import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isNotificationEnabled = true;

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
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 28),
                    onPressed: () {
                      // Handle back
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Setting",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),

            // --- Menu List Container ---
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEADCC6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                  children: [
                    _buildMenuItem(
                      icon: Icons.account_circle_outlined,
                      title: "Profile",
                      onTap: () {},
                    ),
                    _buildDivider(),
                    
                    _buildNotificationItem(),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.delete_outline,
                      title: "Delete Account",
                      onTap: () {},
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.language,
                      title: "Language",
                      onTap: () {},
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.exit_to_app,
                      title: "Logout",
                      textColor: Colors.red,
                      showArrow: false,
                      onTap: () {},
                    ),
                    _buildDivider(),

                    const SizedBox(height: 100), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color textColor = Colors.black87,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      leading: Icon(icon, size: 28, color: Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: showArrow
          ? const Icon(Icons.chevron_right, color: Colors.black54)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildNotificationItem() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      leading: const Icon(Icons.notifications_none_outlined, size: 28, color: Colors.black87),
      title: const Text(
        "Notification",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.9,
        child: Switch(
          value: _isNotificationEnabled,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF8D6E63),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey[300],
          trackOutlineColor: WidgetStateProperty.resolveWith(
            (final Set<WidgetState> states) {
               if (states.contains(WidgetState.selected)) {
                 return null;
               }
               return Colors.transparent;
            },
          ),
          onChanged: (bool value) {
            setState(() {
              _isNotificationEnabled = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Colors.black12,
      indent: 10,
      endIndent: 10,
    );
  }
}