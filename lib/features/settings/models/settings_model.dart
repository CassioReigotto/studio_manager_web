class StudioSettings {
  final String studioName;
  final String? logoUrl;
  final List<String> serviceCategories;
  final List<String> inventoryCategories;
  final List<String> measurementUnits;
  final List<String> financialCategories;
  final List<String> paymentMethods;
  final String? address;
  final String? phone;
  final String? email;

  StudioSettings({
    required this.studioName,
    this.logoUrl,
    required this.serviceCategories,
    required this.inventoryCategories,
    required this.measurementUnits,
    required this.financialCategories,
    required this.paymentMethods,
    this.address,
    this.phone,
    this.email,
  });

  factory StudioSettings.defaults() {
    return StudioSettings(
      studioName: 'Meu Estúdio',
      serviceCategories: [
        'Tatuagem',
        'Piercing',
        'Remoção',
        'Retoque',
        'Cover Up',
      ],
      inventoryCategories: [
        'Tinta',
        'Agulha',
        'Luva',
        'Filme',
        'Higiene',
        'Equipamento',
      ],
      measurementUnits: [
        'unidades',
        'ml',
        'g',
        'litros',
        'rolos',
        'pares',
        'kg',
      ],
      financialCategories: [
        'Serviço',
        'Material',
        'Aluguel',
        'Equipamento',
        'Marketing',
        'Salário',
        'Outros',
      ],
      paymentMethods: [
        'Dinheiro',
        'PIX',
        'Cartão',
        'Débito',
        'Transferência',
      ],
    );
  }

  factory StudioSettings.fromJson(Map<String, dynamic> json) {
    return StudioSettings(
      studioName: json['studioName'],
      logoUrl: json['logoUrl'],
      serviceCategories: List<String>.from(json['serviceCategories'] ?? []),
      inventoryCategories: List<String>.from(json['inventoryCategories'] ?? []),
      measurementUnits: List<String>.from(json['measurementUnits'] ?? []),
      financialCategories: List<String>.from(json['financialCategories'] ?? []),
      paymentMethods: List<String>.from(json['paymentMethods'] ?? []),
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studioName': studioName,
      'logoUrl': logoUrl,
      'serviceCategories': serviceCategories,
      'inventoryCategories': inventoryCategories,
      'measurementUnits': measurementUnits,
      'financialCategories': financialCategories,
      'paymentMethods': paymentMethods,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }

  StudioSettings copyWith({
    String? studioName,
    String? logoUrl,
    List<String>? serviceCategories,
    List<String>? inventoryCategories,
    List<String>? measurementUnits,
    List<String>? financialCategories,
    List<String>? paymentMethods,
    String? address,
    String? phone,
    String? email,
  }) {
    return StudioSettings(
      studioName: studioName ?? this.studioName,
      logoUrl: logoUrl ?? this.logoUrl,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      inventoryCategories: inventoryCategories ?? this.inventoryCategories,
      measurementUnits: measurementUnits ?? this.measurementUnits,
      financialCategories: financialCategories ?? this.financialCategories,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}
