class Appointment {
  final String id;
  final String clientName;
  final String phone;
  final String service;
  final String date;
  final String time;
  final String status; // 'pendente', 'confirmado', 'concluido'
  final int artistId;
  final String? notes;
  final double? value;

  Appointment({
    required this.id,
    required this.clientName,
    required this.phone,
    required this.service,
    required this.date,
    required this.time,
    required this.status,
    required this.artistId,
    this.notes,
    this.value,
  });

  // Para converter de/para JSON (futuro backend)
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'].toString(),
      clientName: json['clientName'],
      phone: json['phone'],
      service: json['service'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      artistId: json['artistId'],
      notes: json['notes'],
      value: json['value']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'phone': phone,
      'service': service,
      'date': date,
      'time': time,
      'status': status,
      'artistId': artistId,
      'notes': notes,
      'value': value,
    };
  }

  Appointment copyWith({
    String? id,
    String? clientName,
    String? phone,
    String? service,
    String? date,
    String? time,
    String? status,
    int? artistId,
    String? notes,
    double? value,
  }) {
    return Appointment(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      phone: phone ?? this.phone,
      service: service ?? this.service,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      artistId: artistId ?? this.artistId,
      notes: notes ?? this.notes,
      value: value ?? this.value,
    );
  }
}
