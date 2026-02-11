import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Pegar a rota atual da forma correta
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Center(
                      child: Text(
                        'SM',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STUDIO MANAGER',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Administração',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    route: '/dashboard',
                    currentRoute: currentRoute,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.people_outline,
                    label: 'Tatuadores',
                    route: '/artists',
                    currentRoute: currentRoute,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.event_outlined,
                    label: 'Agendamentos',
                    route: '/appointments',
                    currentRoute: currentRoute,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.attach_money,
                    label: 'Financeiro',
                    route: '/transactions',
                    currentRoute: currentRoute,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.inventory_2_outlined,
                    label: 'Estoque',
                    route: '/inventory',
                    currentRoute: currentRoute,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.description_outlined,
                    label: 'Templates',
                    route: '/templates',
                    currentRoute: currentRoute,
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.analytics_outlined,
                    label: 'Relatórios',
                    route: '/reports',
                    currentRoute: currentRoute,
                  ),
                  const Divider(color: AppColors.border, height: 32),
                  _buildMenuItem(
                    context,
                    icon: Icons.settings_outlined,
                    label: 'Configurações',
                    route: '/settings',
                    currentRoute: currentRoute,
                  ),
                ],
              ),
            ),

            // User
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 20,
                    child: const Text(
                      'D',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dono',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'dono@studio.com',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required String currentRoute,
  }) {
    final isActive = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.textSecondary,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            color: isActive ? Colors.white : AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        onTap: () {
          context.go(route);
          Navigator.pop(context); // Fecha o drawer
        },
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
