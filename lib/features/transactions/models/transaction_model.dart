class Transaction {
  final String id;
  final String type; // 'receita' ou 'despesa'
  final double amount;
  final String description;
  final String category;
  final String paymentMethod;
  final String date;
  final int? artistId; // null = transação manual do estúdio
  final int? appointmentId; // referência ao agendamento
  final double? studioAmount; // valor que ficou para o estúdio
  final double? artistAmount; // valor que foi para o tatuador

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.category,
    required this.paymentMethod,
    required this.date,
    this.artistId,
    this.appointmentId,
    this.studioAmount,
    this.artistAmount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(),
      type: json['type'],
      amount: json['amount'].toDouble(),
      description: json['description'],
      category: json['category'],
      paymentMethod: json['paymentMethod'],
      date: json['date'],
      artistId: json['artistId'],
      appointmentId: json['appointmentId'],
      studioAmount: json['studioAmount']?.toDouble(),
      artistAmount: json['artistAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'category': category,
      'paymentMethod': paymentMethod,
      'date': date,
      'artistId': artistId,
      'appointmentId': appointmentId,
      'studioAmount': studioAmount,
      'artistAmount': artistAmount,
    };
  }

  Transaction copyWith({
    String? id,
    String? type,
    double? amount,
    String? description,
    String? category,
    String? paymentMethod,
    String? date,
    int? artistId,
    int? appointmentId,
    double? studioAmount,
    double? artistAmount,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      artistId: artistId ?? this.artistId,
      appointmentId: appointmentId ?? this.appointmentId,
      studioAmount: studioAmount ?? this.studioAmount,
      artistAmount: artistAmount ?? this.artistAmount,
    );
  }

  bool get isRevenue => type == 'receita';
  bool get isExpense => type == 'despesa';
  bool get hasArtist => artistId != null;
}