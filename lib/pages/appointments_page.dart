import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/theme/app_colors.dart';
import '../features/appointments/models/appointment_model.dart';
import '../features/appointments/widgets/calendar_view.dart';
import '../features/appointments/widgets/appointment_card.dart';
import '../features/appointments/widgets/artist_filter.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  bool _isCalendarView = true;
  int? _selectedArtistId;
  DateTime? _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  // Mock data - depois virá do backend
  final List<Appointment> _appointments = [
    Appointment(
      id: '1',
      clientName: 'Maria Silva',
      phone: '(11) 98765-4321',
      service: 'Tatuagem Colorida',
      date: '2026-02-10',
      time: '14:00',
      status: 'confirmado',
      artistId: 2,
      notes: 'Cliente quer flores no braço',
    ),
    Appointment(
      id: '2',
      clientName: 'João Santos',
      phone: '(11) 91234-5678',
      service: 'Tatuagem P&B',
      date: '2026-02-10',
      time: '16:30',
      status: 'confirmado',
      artistId: 3,
    ),
    Appointment(
      id: '3',
      clientName: 'Ana Costa',
      phone: '(11) 99876-5432',
      service: 'Cover Up',
      date: '2026-02-11',
      time: '10:00',
      status: 'pendente',
      artistId: 2,
      notes: 'Cobrir tatuagem antiga',
    ),
    Appointment(
      id: '4',
      clientName: 'Pedro Oliveira',
      phone: '(11) 97654-3210',
      service: 'Tatuagem Fina',
      date: '2026-02-11',
      time: '14:00',
      status: 'confirmado',
      artistId: 3,
    ),
    Appointment(
      id: '5',
      clientName: 'Carla Mendes',
      phone: '(11) 96543-2109',
      service: 'Retoque',
      date: '2026-02-09',
      time: '10:00',
      status: 'concluido',
      artistId: 2,
      value: 500.0,
    ),
  ];

  List<Appointment> get _filteredAppointments {
    var filtered = _appointments;
    
    // Filtrar por artista
    if (_selectedArtistId != null) {
      filtered = filtered.where((apt) => apt.artistId == _selectedArtistId).toList();
    }
    
    // Filtrar por data (para lista)
    if (!_isCalendarView && _selectedDate != null) {
      final dateStr = '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
      filtered = filtered.where((apt) => apt.date == dateStr).toList();
    }
    
    return filtered;
  }

  Map<String, List<Appointment>> get _groupedByDate {
    final Map<String, List<Appointment>> grouped = {};
    
    for (var apt in _filteredAppointments) {
      if (!grouped.containsKey(apt.date)) {
        grouped[apt.date] = [];
      }
      grouped[apt.date]!.add(apt);
    }
    
    // Ordenar por horário
    grouped.forEach((key, value) {
      value.sort((a, b) => a.time.compareTo(b.time));
    });
    
    return grouped;
  }

  String _getArtistName(int artistId) {
    switch (artistId) {
      case 2:
        return 'Maria Santos';
      case 3:
        return 'Pedro Costa';
      default:
        return 'Desconhecido';
    }
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final weekdays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    
    return '${weekdays[date.weekday % 7]}, ${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  void _handleComplete(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: AppColors.primary, width: 1),
        ),
        title: const Text(
          'CONCLUIR AGENDAMENTO',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cliente: ${appointment.clientName}',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Serviço: ${appointment.service}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'VALOR (R\$)',
                hintText: '500.00',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border),
            ),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agendamento concluído!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('CONCLUIR'),
          ),
        ],
      ),
    );
  }

  void _handleEdit(Appointment appointment) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Editar agendamento (em desenvolvimento)'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleDelete(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: AppColors.error, width: 1),
        ),
        title: const Text(
          'EXCLUIR AGENDAMENTO',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Deseja realmente excluir o agendamento de ${appointment.clientName}?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agendamento excluído!'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AGENDAMENTOS',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_filteredAppointments.length} agendamento(s)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                
                Row(
                  children: [
                    // View Toggle
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border, width: 1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Row(
                        children: [
                          _buildViewButton(
                            icon: Icons.calendar_month,
                            label: 'CALENDÁRIO',
                            isActive: _isCalendarView,
                            onTap: () => setState(() {
                              _isCalendarView = true;
                              _selectedDate = null;
                            }),
                          ),
                          _buildViewButton(
                            icon: Icons.list,
                            label: 'LISTA',
                            isActive: !_isCalendarView,
                            onTap: () => setState(() => _isCalendarView = false),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // New Appointment Button
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Novo agendamento (em desenvolvimento)'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('NOVO'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Artist Filter
            ArtistFilter(
              selectedArtistId: _selectedArtistId,
              onArtistSelected: (artistId) {
                setState(() => _selectedArtistId = artistId);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Content
            if (_isCalendarView)
              CalendarView(
                appointments: _filteredAppointments,
                selectedArtistId: _selectedArtistId,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (date) {
                  setState(() {
                    _selectedDate = date;
                    _isCalendarView = false;
                  });
                },
              )
            else
              _buildListView(),
          ],
        ),
      ),
    );
  }

  Widget _buildViewButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    final grouped = _groupedByDate;
    final sortedDates = grouped.keys.toList()..sort();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botão Voltar (se filtrado por data)
        if (_selectedDate != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                      _isCalendarView = true;
                    });
                  },
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('VOLTAR AO CALENDÁRIO'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  _selectedDate != null ? _formatDate(
                    '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                  ) : '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        
        // Lista de agendamentos
        if (sortedDates.isEmpty)
          Container(
            padding: const EdgeInsets.all(60),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum agendamento encontrado',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: sortedDates.map((dateStr) {
              final appointments = grouped[dateStr]!;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      _formatDate(dateStr),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  
                  // Appointments
                  ...appointments.map((apt) {
                    return AppointmentCard(
                      appointment: apt,
                      artistName: _getArtistName(apt.artistId),
                      onComplete: apt.status != 'concluido' ? () => _handleComplete(apt) : null,
                      onEdit: apt.status != 'concluido' ? () => _handleEdit(apt) : null,
                      onDelete: () => _handleDelete(apt),
                    );
                  }),
                  
                  const SizedBox(height: 24),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}