import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/inventory_item_model.dart';

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback? onEdit;
  final VoidCallback? onAddStock;
  final VoidCallback? onDelete;

  const InventoryCard({
    super.key,
    required this.item,
    this.onEdit,
    this.onAddStock,
    this.onDelete,
  });

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tinta':
        return '🎨';
      case 'agulha':
        return '💉';
      case 'luva':
        return '🧤';
      case 'filme':
        return '📦';
      case 'higiene':
        return '🧼';
      case 'equipamento':
        return '🔧';
      default:
        return '📦';
    }
  }

  Color _getStatusColor() {
    if (item.isOutOfStock) return AppColors.error;
    if (item.isLowStock) return AppColors.warning;
    return AppColors.success;
  }

  String _getStatusText() {
    if (item.isOutOfStock) return 'ESGOTADO';
    if (item.isLowStock) return 'ESTOQUE BAIXO';
    return 'OK';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: item.isLowStock ? statusColor : AppColors.border,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMobileContent(statusColor),
              ],
            )
          : _buildDesktopContent(statusColor),
    );
  }

  Widget _buildMobileContent(Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.border, width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Center(
                child: Text(_getCategoryIcon(item.category),
                    style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: statusColor, width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                _getStatusText(),
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

        const SizedBox(height: 12),

        // Details
        if (item.supplier != null) ...[
          Row(
            children: [
              const Icon(Icons.business,
                  size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                item.supplier!,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],

        if (item.price != null) ...[
          Row(
            children: [
              const Icon(Icons.attach_money,
                  size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'R\$ ${item.price!.toStringAsFixed(2).replaceAll('.', ',')}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        // Stock
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundTertiary,
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ESTOQUE ATUAL',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.quantity} ${item.unit}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'MÍNIMO',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.minQuantity} ${item.unit}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Actions
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onAddStock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(0, 44),
                ),
                child: const Text('ADICIONAR',
                    style: TextStyle(fontSize: 11, letterSpacing: 1)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: onEdit,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(0, 44),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: const Text('EDITAR',
                    style: TextStyle(fontSize: 11, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopContent(Color statusColor) {
    return Row(
      children: [
        // Icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text(_getCategoryIcon(item.category),
                style: const TextStyle(fontSize: 24)),
          ),
        ),

        const SizedBox(width: 20),

        // Info
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: statusColor, width: 1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      _getStatusText(),
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
              const SizedBox(height: 6),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (item.supplier != null) ...[
                    const Icon(Icons.business,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      item.supplier!,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (item.price != null) ...[
                    const Icon(Icons.attach_money,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'R\$ ${item.price!.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Stock
        Container(
          width: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.backgroundTertiary,
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ATUAL',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    item.unit,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'MÍNIMO',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.minQuantity}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Actions
        SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: onAddStock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  minimumSize: const Size(0, 40),
                ),
                child: const Text('ADICIONAR',
                    style: TextStyle(fontSize: 11, letterSpacing: 1)),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onEdit,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        minimumSize: const Size(0, 40),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: const Text('EDITAR',
                          style: TextStyle(fontSize: 10, letterSpacing: 1)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDelete,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        minimumSize: const Size(0, 40),
                        side: const BorderSide(color: AppColors.error),
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text('EXCLUIR',
                          style: TextStyle(fontSize: 10, letterSpacing: 1)),
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
