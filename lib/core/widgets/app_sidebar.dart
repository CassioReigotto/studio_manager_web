import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AppSidebar extends StatefulWidget {
  final bool isCollapsed;
  final VoidCallback onToggle;

  const AppSidebar({
    super.key,
    required this.isCollapsed,
    required this.onToggle,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.isCollapsed ? 70 : 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
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
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Center(
                    child: Text(
                      'SM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (!widget.isCollapsed) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STUDIO MANAGER',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Administrador',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  height: 1,
                  color: AppColors.border,
                ),
                const SizedBox(height: 8),
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

          // Toggle Button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: IconButton(
              onPressed: widget.onToggle,
              icon: Icon(
                widget.isCollapsed
                    ? Icons.chevron_right
                    : Icons.chevron_left,
                color: AppColors.textSecondary,
              ),
              tooltip: widget.isCollapsed ? 'Expandir' : 'Recolher',
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
                  radius: widget.isCollapsed ? 16 : 20,
                  child: const Text(
                    'D',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!widget.isCollapsed) ...[
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
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
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

    return Tooltip(
      message: widget.isCollapsed ? label : '',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
        child: InkWell(
          onTap: () => context.go(route),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.isCollapsed ? 0 : 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                if (widget.isCollapsed)
                  Expanded(
                    child: Icon(
                      icon,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                      size: 20,
                    ),
                  )
                else ...[
                  Icon(
                    icon,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                        color: isActive ? Colors.white : AppColors.textSecondary,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}