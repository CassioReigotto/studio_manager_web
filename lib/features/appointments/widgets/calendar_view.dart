import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../models/appointment_model.dart';

class CalendarView extends StatefulWidget {
  final List<Appointment> appointments;
  final Function(DateTime) onDaySelected;
  final int? selectedArtistId;
  final CalendarFormat calendarFormat;
  final Function(CalendarFormat)? onFormatChanged;

  const CalendarView({
    super.key,
    required this.appointments,
    required this.onDaySelected,
    this.selectedArtistId,
    this.calendarFormat = CalendarFormat.month,
    this.onFormatChanged,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Appointment> _getEventsForDay(DateTime day) {
    final dateStr = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    
    var events = widget.appointments.where((apt) => apt.date == dateStr).toList();
    
    // Filtrar por artista se selecionado
    if (widget.selectedArtistId != null) {
      events = events.where((apt) => apt.artistId == widget.selectedArtistId).toList();
    }
    
    return events;
  }

  Color _getArtistColor(int artistId) {
    switch (artistId) {
      case 2:
        return AppColors.primary;
      case 3:
        return AppColors.success;
      default:
        return const Color(0xFF3b82f6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      padding: const EdgeInsets.all(16),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: widget.calendarFormat,
        
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onDaySelected(selectedDay);
        },
        
        onFormatChanged: (format) {
          if (widget.onFormatChanged != null) {
            widget.onFormatChanged!(format);
          }
        },
        
        eventLoader: _getEventsForDay,
        
        calendarStyle: CalendarStyle(
          defaultDecoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
          weekendDecoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
          todayDecoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            border: Border.all(color: AppColors.primary, width: 2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.success,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: AppColors.textPrimary),
          weekendTextStyle: const TextStyle(color: AppColors.textPrimary),
          todayTextStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          selectedTextStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          outsideTextStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.3)),
        ),
        
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(2),
          ),
          formatButtonTextStyle: const TextStyle(
            fontSize: 10,
            color: AppColors.textPrimary,
            letterSpacing: 1,
          ),
          formatButtonPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            color: AppColors.textPrimary,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
          rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
        ),
        
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: AppColors.textSecondary,
          ),
          weekendStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: AppColors.textSecondary,
          ),
        ),
        
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return null;
            
            final appointments = events.cast<Appointment>();
            final visible = appointments.take(2).toList();
            final remaining = appointments.length - 2;
            
            return Positioned(
              bottom: 2,
              left: 2,
              right: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...visible.map((apt) {
                    final color = _getArtistColor(apt.artistId);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        border: Border(
                          left: BorderSide(color: color, width: 2),
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: Text(
                        apt.time,
                        style: TextStyle(
                          fontSize: 7,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }),
                  if (remaining > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        '+$remaining',
                        style: const TextStyle(
                          fontSize: 7,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}