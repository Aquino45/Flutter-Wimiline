class UserProfile {
  final String fullName;
  final String? photoUrl;
  final String email;

  UserProfile({
    required this.fullName,
    this.photoUrl,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      // Backend envía "fullName", "photoUrl", "email"
      fullName: json['fullName'] ?? 'Usuario',
      photoUrl: json['photoUrl'],
      email: json['email'] ?? '',
    );
  }
}