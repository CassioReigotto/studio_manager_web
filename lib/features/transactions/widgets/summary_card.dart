import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color; // Ainda recebe, mas não usa para borda
  final IconData icon;
  final String? trend;

  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.border,  // Borda cinza sempre
          width: 1,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(
                icon,
                size: 20,
                color: AppColors.textTertiary,  // Ícone cinza
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
              color: AppColors.textPrimary,  // Valor branco (sem cor)
            ),
          ),
          if (trend != null) ...[
            const SizedBox(height: 8),
            Text(
              trend!,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}