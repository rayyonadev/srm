class ProfileModel {
  final int? id;
  final String? fullName;
  final String? phone;
  final String? role;
  final String? avatar;
  final bool? isActive;
  final bool? isStaff;
  final String? createdAt;
  final double? balance;

  ProfileModel({
    this.id,
    this.fullName,
    this.phone,
    this.role,
    this.avatar,
    this.isActive,
    this.isStaff,
    this.createdAt,
    this.balance,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      fullName: json['full_name'],
      phone: json['phone'],
      role: json['role'] ?? json['user_role'],
      avatar: json['avatar'],
      isActive: json['is_active'],
      isStaff: json['is_staff'],
      createdAt: json['created_at'],
      balance: (json['balance'] ?? json['user_balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'avatar': avatar,
      'is_active': isActive,
      'is_staff': isStaff,
      'created_at': createdAt,
      'balance': balance,
    };
  }

  // Helpers to get first and last name from full_name
  String get firstName {
    if (fullName == null || fullName!.isEmpty) return '';
    final parts = fullName!.trim().split(' ');
    return parts.length > 1 ? parts.last : fullName!;
  }

  String get lastName {
    if (fullName == null || fullName!.isEmpty) return '';
    final parts = fullName!.trim().split(' ');
    return parts.length > 1 ? parts.first : '';
  }
}
