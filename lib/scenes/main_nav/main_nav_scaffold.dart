import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import '../goal_calculator/goal_calculator_factory.dart';
import '../home/home_coordinator.dart';
import '../home/home_factory.dart';
import '../maintenance_vault/maintenance_vault_factory.dart';
import '../overlay_preview/overlay_preview_factory.dart';
import '../smart_shift/smart_shift_factory.dart';
import '../vehicle_setup/vehicle_setup_factory.dart';

/// Scaffold principal com BottomNavigationBar conectando todas as cenas do FINDRIVE.
class MainNavScaffold extends StatefulWidget {
  const MainNavScaffold({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainNavScaffold> createState() => _MainNavScaffoldState();
}

class _MainNavScaffoldState extends State<MainNavScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onSelectTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Constrói coordenadores que permitem alternar tabs ou navegar
    final homeCoordinator = DefaultHomeCoordinator(
      onOpenGoalCalculator: (_) => _onSelectTab(1),
      onOpenSmartShift: (_) => _onSelectTab(2),
      onOpenMaintenanceVault: (_) => _onSelectTab(3),
      onOpenVehicleSetup: (_) => _onSelectTab(4),
      onOpenOverlay: (context) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => OverlayPreviewFactory.make(),
          ),
        );
      },
    );

    final pages = <Widget>[
      HomeFactory.make(coordinator: homeCoordinator),
      GoalCalculatorFactory.make(),
      SmartShiftFactory.make(),
      MaintenanceVaultFactory.make(),
      VehicleSetupFactory.make(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onSelectTab,
        indicatorColor: colorScheme.primary,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: colorScheme.onPrimary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate, color: colorScheme.onPrimary),
            label: 'Meta',
          ),
          NavigationDestination(
            icon: const Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.schedule, color: colorScheme.onPrimary),
            label: 'Turnos',
          ),
          NavigationDestination(
            icon: const Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield, color: colorScheme.onPrimary),
            label: 'CPK',
          ),
          NavigationDestination(
            icon: const Icon(Icons.directions_car_outlined),
            selectedIcon: Icon(Icons.directions_car, color: colorScheme.onPrimary),
            label: 'Veículo',
          ),
        ],
      ),
    );
  }
}
