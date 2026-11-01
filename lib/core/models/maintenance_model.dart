import 'package:carteira_design_system/carteira_design_system.dart';

/// Modelo de Fundo Preventivo e Desgaste de Peças (CPK).
class MaintenanceModel {
  const MaintenanceModel({
    required this.vaultBalance,
    required this.retentionPercent,
    required this.cpkAmount,
    required this.items,
  });

  final double vaultBalance;
  final double retentionPercent;
  final double cpkAmount;
  final List<MaintenanceItemStatus> items;

  MaintenanceModel copyWith({
    double? vaultBalance,
    double? retentionPercent,
    double? cpkAmount,
    List<MaintenanceItemStatus>? items,
  }) {
    return MaintenanceModel(
      vaultBalance: vaultBalance ?? this.vaultBalance,
      retentionPercent: retentionPercent ?? this.retentionPercent,
      cpkAmount: cpkAmount ?? this.cpkAmount,
      items: items ?? this.items,
    );
  }
}
