import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/stat_card.dart';
import '../core/widgets/responsive_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveLayout.getHorizontalPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'DASHBOARD',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                letterSpacing: 4,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Visão geral do estúdio',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 32),

            // Stats Grid - RESPONSIVO
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: ResponsiveLayout.getGridCrossAxisCount(
                context,
                mobile: 2,
                tablet: 3,
                desktop: 4,
              ),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: ResponsiveLayout.isMobile(context) ? 1.3 : 1.5,
              children: const [
                StatCard(
                  title: 'Receita Mensal',
                  value: 'R\$ 12.450',
                  icon: Icons.attach_money,
                  color: AppColors.success,
                ),
                StatCard(
                  title: 'Agendamentos',
                  value: '24',
                  icon: Icons.event,
                  color: AppColors.primary,
                ),
                StatCard(
                  title: 'Tatuadores',
                  value: '3',
                  icon: Icons.people,
                  color: AppColors.info,
                ),
                StatCard(
                  title: 'Estoque Baixo',
                  value: '5',
                  icon: Icons.warning,
                  color: AppColors.warning,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Performance Section
            const Text(
              'DESEMPENHO DOS TATUADORES',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),

            // Artist Cards - RESPONSIVO
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: ResponsiveLayout.getGridCrossAxisCount(
                context,
                mobile: 1,
                tablet: 2,
                desktop: 3,
              ),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: ResponsiveLayout.isMobile(context) ? 2.5 : 2.0,
              children: [
                _buildArtistCard(
                  'Maria Santos',
                  '8 agendamentos',
                  'R\$ 4.200,00',
                  AppColors.primary,
                  'M',
                ),
                _buildArtistCard(
                  'Pedro Costa',
                  '12 agendamentos',
                  'R\$ 6.800,00',
                  AppColors.success,
                  'P',
                ),
                _buildArtistCard(
                  'Ana Silva',
                  '6 agendamentos',
                  'R\$ 2.450,00',
                  AppColors.info,
                  'A',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistCard(
    String name,
    String appointments,
    String revenue,
    Color color,
    String initial,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 24,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            // ← ADICIONADO para evitar overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  appointments,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  revenue,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
