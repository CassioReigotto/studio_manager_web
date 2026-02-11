import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/template_model.dart';

class TemplateCard extends StatelessWidget {
  final ServiceTemplate template;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;

  const TemplateCard({
    super.key,
    required this.template,
    this.onEdit,
    this.onToggleStatus,
    this.onDelete,
  });

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tatuagem':
        return '🎨';
      case 'piercing':
        return '💎';
      case 'remoção':
        return '🔥';
      case 'retoque':
        return '✨';
      case 'cover up':
        return '🖌️';
      default:
        return '📝';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: template.isActive ? AppColors.border : AppColors.error,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMobileContent(),
              ],
            )
          : _buildDesktopContent(),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon/Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: template.isActive
                    ? AppColors.background
                    : AppColors.backgroundTertiary,
                border: Border.all(color: AppColors.border, width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Center(
                child: Text(
                  _getCategoryIcon(template.category),
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: template.isActive
                            ? AppColors.success
                            : AppColors.error,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      template.isActive ? 'ATIVO' : 'INATIVO',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: template.isActive
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Name
        Text(
          template.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 8),

        // Description
        Text(
          template.description,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 12),

        // Price & Duration
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'R\$ ${template.basePrice.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  template.durationFormatted,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),

        if (template.includedItems.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: template.includedItems.take(5).map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.backgroundTertiary,
                  border: Border.all(color: AppColors.border, width: 1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  '${item.quantity.toInt()}x ${item.itemName}',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 16),

        // Actions
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: onEdit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(0, 44),
              ),
              child: const Text('EDITAR',
                  style: TextStyle(fontSize: 11, letterSpacing: 1.5)),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: onToggleStatus,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(0, 44),
                side: BorderSide(
                  color:
                      template.isActive ? AppColors.error : AppColors.success,
                ),
                foregroundColor:
                    template.isActive ? AppColors.error : AppColors.success,
              ),
              child: Text(
                template.isActive ? 'DESATIVAR' : 'ATIVAR',
                style: const TextStyle(fontSize: 10, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon/Image
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: template.isActive
                ? AppColors.background
                : AppColors.backgroundTertiary,
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text(
              _getCategoryIcon(template.category),
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    template.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: template.isActive
                            ? AppColors.success
                            : AppColors.error,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      template.isActive ? 'ATIVO' : 'INATIVO',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: template.isActive
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                template.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                template.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (template.includedItems.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: template.includedItems.take(5).map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundTertiary,
                        border: Border.all(color: AppColors.border, width: 1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '${item.quantity.toInt()}x ${item.itemName}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: 24),

        // Price & Duration
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'R\$ ${template.basePrice.toStringAsFixed(2).replaceAll('.', ',')}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 12,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  template.durationFormatted,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(width: 24),

        // Actions
        SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  minimumSize: const Size(0, 44),
                ),
                child: const Text(
                  'EDITAR',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onToggleStatus,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        minimumSize: const Size(0, 44),
                        side: BorderSide(
                          color: template.isActive
                              ? AppColors.error
                              : AppColors.success,
                        ),
                        foregroundColor: template.isActive
                            ? AppColors.error
                            : AppColors.success,
                      ),
                      child: Text(
                        template.isActive ? 'DESATIVAR' : 'ATIVAR',
                        style: const TextStyle(
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
    );
  }
}
