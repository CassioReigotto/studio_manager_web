import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final String? artistName;
  final VoidCallback? onDelete;
  final bool isAdmin;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.artistName,
    this.onDelete,
    this.isAdmin = true,
  });

  Color _getTypeColor() {
    return transaction.isRevenue ? AppColors.success : AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor();
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMobileContent(typeColor),
              ],
            )
          : _buildDesktopContent(typeColor),
    );
  }

  Widget _buildMobileContent(Color typeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Type Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.1),
            border: Border.all(color: typeColor, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            transaction.type.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              color: typeColor,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Description
        Text(
          transaction.description,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),

        // Category & Payment
        Row(
          children: [
            const Icon(Icons.folder_outlined,
                size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              transaction.category,
              style:
                  const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.payment, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              transaction.paymentMethod,
              style:
                  const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Date
        Text(
          _formatDate(transaction.date),
          style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
        ),

        if (artistName != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person, size: 12, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                artistName!,
                style: const TextStyle(fontSize: 11, color: AppColors.primary),
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),

        // Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'R\$ ${transaction.amount.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (transaction.hasArtist && isAdmin) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Estúdio: R\$ ${transaction.studioAmount?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                  Text(
                    'Tatuador: R\$ ${transaction.artistAmount?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopContent(Color typeColor) {
    return Row(
      children: [
        // Type Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.1),
            border: Border.all(color: typeColor, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            transaction.type.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
              color: typeColor,
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Info
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.description,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.folder_outlined,
                      size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    transaction.category,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.payment,
                      size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    transaction.paymentMethod,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Date
        Expanded(
          flex: 1,
          child: Text(
            _formatDate(transaction.date),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 20),

        // Artist
        if (artistName != null)
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Icon(Icons.person, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    artistName!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        else
          const Expanded(flex: 1, child: SizedBox()),

        const SizedBox(width: 20),

        // Amount
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${transaction.amount.toStringAsFixed(2).replaceAll('.', ',')}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (transaction.hasArtist && isAdmin) ...[
                const SizedBox(height: 4),
                Text(
                  'Estúdio: R\$ ${transaction.studioAmount?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Tatuador: R\$ ${transaction.artistAmount?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: 20),

        // Actions
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline,
                color: AppColors.error, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}
