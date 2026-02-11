import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_colors.dart';
import 'core/widgets/app_sidebar.dart';
import 'core/widgets/app_drawer.dart';
import 'core/widgets/responsive_layout.dart';
import 'core/services/settings_service.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/appointments_page.dart';
import 'pages/artists_page.dart';
import 'pages/transactions_page.dart';
import 'pages/inventory_page.dart';
import 'pages/templates_page.dart';
import 'pages/reports_page.dart';
import 'pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Settings Service
  await SettingsService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Studio Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          labelStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            letterSpacing: 1,
          ),
          hintStyle: const TextStyle(
            color: AppColors.textTertiary,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ResponsiveScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/appointments',
          builder: (context, state) => const AppointmentsPage(),
        ),
        GoRoute(
          path: '/artists',
          builder: (context, state) => const ArtistsPage(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (context, state) => const TransactionsPage(),
        ),
        GoRoute(
          path: '/inventory',
          builder: (context, state) => const InventoryPage(),
        ),
        GoRoute(
          path: '/templates',
          builder: (context, state) => const TemplatesPage(),
        ),
        GoRoute(
          path: '/reports',
          builder: (context, state) => const ReportsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);

// Widget que gerencia layout responsivo + sidebar colapsável
class ResponsiveScaffold extends StatefulWidget {
  final Widget child;

  const ResponsiveScaffold({super.key, required this.child});

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  bool _isSidebarCollapsed = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      // AppBar só aparece no mobile
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.surface,
              elevation: 0,
              title: const Text(
                'STUDIO MANAGER',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
            )
          : null,

      // Drawer só no mobile
      drawer: isMobile ? const AppDrawer() : null,

      body: Row(
        children: [
          // Sidebar só no desktop/tablet - COLAPSÁVEL
          if (!isMobile)
            AppSidebar(
              isCollapsed: _isSidebarCollapsed,
              onToggle: _toggleSidebar,
            ),

          // Conteúdo principal
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
