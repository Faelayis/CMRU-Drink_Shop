class Profile {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final bool isAdmin;

  const Profile({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.isAdmin = false,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    final rawId = map['id'];
    return Profile(
      id: rawId == null ? '' : rawId.toString(),
      fullName: map['full_name']?.toString(),
      avatarUrl: map['avatar_url']?.toString(),
      phone: map['phone']?.toString(),
      isAdmin: map['is_admin'] == true,
    );
  }
}
