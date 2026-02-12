import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/admin/admin_screen.dart';
import '../../auth/login/login_screen.dart';
import '../../models/profile.dart';
import 'profile_screen.dart';
import 'language/language_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isNotificationEnabled = true;
  late Future<Profile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfile();
  }

  Future<Profile?> _fetchProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return null;
    }

    final response = await Supabase.instance.client
        .from('profiles')
        .select('id, full_name, avatar_url, phone, is_admin')
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      return Profile(id: user.id, fullName: user.email);
    }

    return Profile.fromMap(response);
  }

  Future<void> _resetPassword() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email associated with this account.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Text('A password reset link will be sent to ${user.email}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(user.email!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reset email: $error')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await Supabase.instance.client.rpc('delete_user');
      await Supabase.instance.client.auth.signOut();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully.')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (_) => false,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $error')),
      );
    }
  }

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E9D9),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 24,
                  ),
                  children: [
                    FutureBuilder<Profile?>(
                      future: _profileFuture,
                      builder: (context, snapshot) {
                        final user = Supabase.instance.client.auth.currentUser;
                        final profile = snapshot.data;
                        final avatarUrl = profile?.avatarUrl;
                        final displayName =
                            profile?.fullName?.isNotEmpty == true
                            ? profile!.fullName!
                            : user?.email ?? 'User';
                        if (user == null) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Guest',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Sign in to sync your profile.',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF965A28),
                                  ),
                                  child: const Text(
                                    'Sign in',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.brown.shade200,
                                backgroundImage:
                                    avatarUrl == null || avatarUrl.isEmpty
                                    ? null
                                    : NetworkImage(avatarUrl),
                                child: avatarUrl == null || avatarUrl.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.email ?? '',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.account_circle_outlined,
                      title: "Profile",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),

                    _buildMenuItem(
                      icon: Icons.lock_reset,
                      title: "Reset Password",
                      onTap: () {
                        _resetPassword();
                      },
                    ),
                    _buildDivider(),

                    _buildNotificationItem(),
                    _buildDivider(),

                    _buildMenuItem(
                      icon: Icons.delete_outline,
                      title: "Delete Account",
                      onTap: () {
                        _deleteAccount();
                      },
                    ),
                    _buildDivider(),

                    FutureBuilder<Profile?>(
                      future: _profileFuture,
                      builder: (context, snapshot) {
                        final profile = snapshot.data;
                        if (profile == null || !profile.isAdmin) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            _buildMenuItem(
                              icon: Icons.admin_panel_settings,
                              title: "Admin Panel",
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AdminScreen(),
                                  ),
                                );
                              },
                            ),
                            _buildDivider(),
                          ],
                        );
                      },
                    ),

                    _buildMenuItem(
                      icon: Icons.language,
                      title: "Language",
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LanguageScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),

                    _buildMenuItem(
                      icon: Icons.exit_to_app,
                      title: "Logout",
                      textColor: Colors.red,
                      showArrow: false,
                      onTap: () {
                        _signOut();
                      },
                    ),
                    _buildDivider(),

                    const SizedBox(height: 100),
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
      leading: const Icon(
        Icons.notifications_none_outlined,
        size: 28,
        color: Colors.black87,
      ),
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
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF8D6E63),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey[300],
          trackOutlineColor: WidgetStateProperty.resolveWith((
            final Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return null;
            }
            return Colors.transparent;
          }),
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
