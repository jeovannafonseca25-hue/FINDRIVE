import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:carteira_digital/core/models/maintenance_model.dart';
import 'package:carteira_digital/scenes/maintenance_vault/maintenance_vault_coordinator.dart';
import 'package:carteira_digital/scenes/maintenance_vault/maintenance_vault_factory.dart';
import 'package:carteira_digital/scenes/maintenance_vault/maintenance_vault_view.dart';
import 'package:carteira_digital/scenes/maintenance_vault/server_maintenance_vault.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeServerVault implements ServerMaintenanceVault {
  @override
  Future<MaintenanceModel> fetchVault() async {
    return const MaintenanceModel(
      vaultBalance: 1500.0,
      retentionPercent: 10.0,
      cpkAmount: 0.16,
      items: [
        MaintenanceItemStatus(
          name: 'Troca de Óleo',
          remainingKm: 2000,
          estimatedCost: 190.0,
          isWarning: true,
        ),
      ],
    );
  }

  @override
  Future<void> updateRetention(double percent) async {}
}

class _FakeVaultCoordinator implements MaintenanceVaultCoordinator {
  @override
  void pop(BuildContext context) {}
}

Widget _app(Widget home) => MaterialApp(theme: AppTheme.dark(), home: home);

void main() {
  testWidgets('MaintenanceVaultFactory.make builds MaintenanceVaultView', (tester) async {
    await tester.pumpWidget(_app(MaintenanceVaultFactory.make(
      server: _FakeServerVault(),
      coordinator: _FakeVaultCoordinator(),
    )));
    await tester.pumpAndSettle();

    expect(find.byType(MaintenanceVaultView), findsOneWidget);
    expect(find.text('SALDO PROTEGIDO (EMERGÊNCIAS)'), findsOneWidget);
    expect(find.text('Troca de Óleo'), findsOneWidget);
  });
}
