import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final String? artistName;
  final VoidCallback? onEdit;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.artistName,
    this.onEdit,
    this.onComplete,
    this.onDelete,
  });

  Color _getStatusColor() {
    switch (appointment.status) {
      case 'concluido':
        return AppColors.textSecondary;
      case 'confirmado':
        return AppColors.success;
      default:
        return const Color(0xFFf59e0b);
    }
  }

  String _getStatusLabel() {
    switch (appointment.status) {
      case 'concluido':
        return 'Concluído';
      case 'confirmado':
        return 'Confirmado';
      default:
        return 'Pendente';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              border: Border.all(color: AppColors.primary, width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              appointment.time,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (artistName != null) ...[
                      Text(
                        artistName!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: statusColor, width: 1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        _getStatusLabel().toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  appointment.clientName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  appointment.phone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  appointment.service,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                  ),
                ),
                
                if (appointment.notes != null &&
                    appointment.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    appointment.notes!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Actions - CORRIGIDO COM LARGURA FIXA
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Botão Concluir
                if (appointment.status != 'concluido' && onComplete != null)
                  ElevatedButton(
                    onPressed: onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      minimumSize: const Size(200, 44),
                    ),
                    child: const Text(
                      'CONCLUIR',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // Botões Editar e Excluir lado a lado
                Row(
                  children: [
                    if (appointment.status != 'concluido' && onEdit != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onEdit,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            minimumSize: const Size(0, 44),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          child: const Text(
                            'EDITAR',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),

                    if (appointment.status != 'concluido' && onEdit != null)
                      const SizedBox(width: 8),

                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDelete,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          minimumSize: const Size(0, 44),
                          side: const BorderSide(color: AppColors.error),
                          foregroundColor: AppColors.error,
                        ),
                        child: const Text(
                          'EXCLUIR',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}