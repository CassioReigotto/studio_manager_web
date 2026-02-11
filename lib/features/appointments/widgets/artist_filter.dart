import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ArtistFilter extends StatelessWidget {
  final int? selectedArtistId;
  final Function(int?) onArtistSelected;

  const ArtistFilter({
    super.key,
    required this.selectedArtistId,
    required this.onArtistSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'FILTRAR POR:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          _buildFilterButton(
            label: 'Todos',
            isActive: selectedArtistId == null,
            onTap: () => onArtistSelected(null),
            color: AppColors.primary,
          ),
          _buildFilterButton(
            label: 'Maria Santos',
            isActive: selectedArtistId == 2,
            onTap: () => onArtistSelected(2),
            color: AppColors.primary,
          ),
          _buildFilterButton(
            label: 'Pedro Costa',
            isActive: selectedArtistId == 3,
            onTap: () => onArtistSelected(3),
            color: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.transparent,
          border: Border.all(
            color: isActive ? color : AppColors.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
