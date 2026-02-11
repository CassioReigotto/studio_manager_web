class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final int minQuantity; // Alerta de estoque baixo
  final String unit; // 'unidade', 'ml', 'g', 'pacote'
  final double? price;
  final String? supplier;
  final String? lastRestockDate;
  final String? notes;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.minQuantity,
    required this.unit,
    this.price,
    this.supplier,
    this.lastRestockDate,
    this.notes,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'].toString(),
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      minQuantity: json['minQuantity'],
      unit: json['unit'],
      price: json['price']?.toDouble(),
      supplier: json['supplier'],
      lastRestockDate: json['lastRestockDate'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'minQuantity': minQuantity,
      'unit': unit,
      'price': price,
      'supplier': supplier,
      'lastRestockDate': lastRestockDate,
      'notes': notes,
    };
  }

  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    int? minQuantity,
    String? unit,
    double? price,
    String? supplier,
    String? lastRestockDate,
    String? notes,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      minQuantity: minQuantity ?? this.minQuantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      supplier: supplier ?? this.supplier,
      lastRestockDate: lastRestockDate ?? this.lastRestockDate,
      notes: notes ?? this.notes,
    );
  }

  bool get isLowStock => quantity <= minQuantity;
  bool get isOutOfStock => quantity == 0;

  String get stockStatus {
    if (isOutOfStock) return 'Esgotado';
    if (isLowStock) return 'Estoque baixo';
    return 'OK';
  }
}