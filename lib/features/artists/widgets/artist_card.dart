import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/artist_model.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onDelete;

  const ArtistCard({
    super.key,
    required this.artist,
    this.onEdit,
    this.onToggleStatus,
    this.onDelete,
  });

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
    final color = _getArtistColor(artist.id);

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: artist.isActive ? AppColors.border : AppColors.error,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: artist.isActive ? color : AppColors.textSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Text(
                artist.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
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
                      artist.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
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
                          color: artist.isActive
                              ? AppColors.success
                              : AppColors.error,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        artist.isActive ? 'ATIVO' : 'INATIVO',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          color: artist.isActive
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      artist.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      artist.phone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                if (artist.specialty != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.palette_outlined,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        artist.specialty!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],

                if (artist.bio != null && artist.bio!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    artist.bio!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              border: Border.all(color: color, width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Column(
              children: [
                Text(
                  'SPLIT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: color.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${artist.split}%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    color: color,
                  ),
                ),
              ],
            ),
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
                            color: artist.isActive
                                ? AppColors.error
                                : AppColors.success,
                          ),
                          foregroundColor: artist.isActive
                              ? AppColors.error
                              : AppColors.success,
                        ),
                        child: Text(
                          artist.isActive ? 'DESATIVAR' : 'ATIVAR',
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
      ),
    );
  }
}