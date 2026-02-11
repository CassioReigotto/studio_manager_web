class Artist {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int split; // Porcentagem que o artista recebe (ex: 70)
  final String? bio;
  final String? specialty;
  final bool isActive;
  final DateTime createdAt;

  Artist({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.split,
    this.bio,
    this.specialty,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Para converter de/para JSON (futuro backend)
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      split: json['split'],
      bio: json['bio'],
      specialty: json['specialty'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'split': split,
      'bio': bio,
      'specialty': specialty,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Artist copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? split,
    String? bio,
    String? specialty,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      split: split ?? this.split,
      bio: bio ?? this.bio,
      specialty: specialty ?? this.specialty,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}