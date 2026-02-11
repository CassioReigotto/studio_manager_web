class ServiceTemplate {
  final String id;
  final String name;
  final String category;
  final double basePrice;
  final int estimatedDuration; // em minutos
  final String description;
  final List<TemplateItem> includedItems; // ← MUDOU: agora com quantidade
  final bool isActive;
  final String? imageUrl;

  ServiceTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.basePrice,
    required this.estimatedDuration,
    required this.description,
    required this.includedItems,
    this.isActive = true,
    this.imageUrl,
  });

  factory ServiceTemplate.fromJson(Map<String, dynamic> json) {
    return ServiceTemplate(
      id: json['id'].toString(),
      name: json['name'],
      category: json['category'],
      basePrice: json['basePrice'].toDouble(),
      estimatedDuration: json['estimatedDuration'],
      description: json['description'],
      includedItems: (json['includedItems'] as List?)
              ?.map((item) => TemplateItem.fromJson(item))
              .toList() ??
          [],
      isActive: json['isActive'] ?? true,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'basePrice': basePrice,
      'estimatedDuration': estimatedDuration,
      'description': description,
      'includedItems': includedItems.map((item) => item.toJson()).toList(),
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }

  ServiceTemplate copyWith({
    String? id,
    String? name,
    String? category,
    double? basePrice,
    int? estimatedDuration,
    String? description,
    List<TemplateItem>? includedItems,
    bool? isActive,
    String? imageUrl,
  }) {
    return ServiceTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      basePrice: basePrice ?? this.basePrice,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      description: description ?? this.description,
      includedItems: includedItems ?? this.includedItems,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  String get durationFormatted {
    final hours = estimatedDuration ~/ 60;
    final minutes = estimatedDuration % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}min';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}min';
    }
  }
}

// Nova classe para itens com quantidade
class TemplateItem {
  final String inventoryItemId;
  final String itemName;
  final double quantity;

  TemplateItem({
    required this.inventoryItemId,
    required this.itemName,
    required this.quantity,
  });

  factory TemplateItem.fromJson(Map<String, dynamic> json) {
    return TemplateItem(
      inventoryItemId: json['inventoryItemId'],
      itemName: json['itemName'],
      quantity: json['quantity'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventoryItemId': inventoryItemId,
      'itemName': itemName,
      'quantity': quantity,
    };
  }
}
