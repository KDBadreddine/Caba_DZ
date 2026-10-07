class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String type;
  final String role;
  final bool isVerified;
  final String? idDocumentUrl;
  final double rating;
  final int reviewCount;
  final String? country;
  final String? city;
  final String status;
  final String? avatarUrl;
  final DateTime? lastSeenAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    this.type = 'client',
    this.role = 'both',
    this.isVerified = false,
    this.idDocumentUrl,
    this.rating = 0,
    this.reviewCount = 0,
    this.country,
    this.city,
    this.status = 'active',
    this.avatarUrl,
    this.lastSeenAt,
  });

  bool get isOnline {
    final seen = lastSeenAt;
    if (seen == null) return false;
    return DateTime.now().difference(seen).inMinutes < 5;
  }

  String get firstName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? fullName : parts.first;
  }

  String get lastName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.length < 2 ? '' : parts.sublist(1).join(' ');
  }

  String get username => email.isNotEmpty ? email.split('@').first : phone;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final name = '${map['full_name'] ?? map['name'] ?? ''}'.trim();
    return UserModel(
      id: '${map['id'] ?? ''}',
      fullName: name.isEmpty ? 'مستخدم' : name,
      phone: '${map['phone'] ?? ''}',
      email: '${map['email'] ?? ''}',
      type: '${map['type'] ?? 'client'}',
      role: '${map['role'] ?? 'both'}',
      isVerified: _isTrue(map['id_verified']),
      idDocumentUrl: map['id_document_url']?.toString(),
      rating: double.tryParse('${map['rating_avg'] ?? 0}') ?? 0,
      reviewCount: int.tryParse('${map['rating_count'] ?? 0}') ?? 0,
      country: map['country']?.toString(),
      city: map['city']?.toString(),
      status: '${map['status'] ?? 'active'}',
      avatarUrl: (map['avatar_url'] ?? map['id_document_url'])?.toString(),
      lastSeenAt: DateTime.tryParse('${map['last_seen_at'] ?? ''}'),
    );
  }

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? role,
    String? country,
    String? city,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      type: type,
      role: role ?? this.role,
      isVerified: isVerified,
      idDocumentUrl: idDocumentUrl,
      rating: rating,
      reviewCount: reviewCount,
      country: country ?? this.country,
      city: city ?? this.city,
      status: status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastSeenAt: lastSeenAt,
    );
  }

  static UserModel empty() => const UserModel(
        id: '',
        fullName: '',
        phone: '',
        email: '',
      );

  static bool _isTrue(dynamic v) => v == true || v == 1 || v == '1';
}
