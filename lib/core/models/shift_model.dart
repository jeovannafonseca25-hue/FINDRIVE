import 'package:carteira_design_system/carteira_design_system.dart';

/// Modelo de Turno de Trabalho e Monitoramento de Horas em Tempo Real.
class ShiftModel {
  const ShiftModel({
    required this.shiftId,
    required this.isOnline,
    required this.startedAt,
    required this.onlineDurationSeconds,
    required this.grossEarned,
    required this.fuelSpent,
    required this.kmDriven,
    required this.ridesCompleted,
    this.cpkRate = 0.16,
  });

  final String shiftId;
  final bool isOnline;
  final DateTime startedAt;
  final int onlineDurationSeconds;
  final double grossEarned;
  final double fuelSpent;
  final int kmDriven;
  final int ridesCompleted;
  final double cpkRate;

  double get onlineHours =>
      onlineDurationSeconds > 0 ? onlineDurationSeconds / 3600.0 : 0.0;

  String get onlineDurationFormatted {
    final hours = onlineDurationSeconds ~/ 3600;
    final minutes = (onlineDurationSeconds % 3600) ~/ 60;
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  /// Custo de desgaste veicular acumulado neste turno (CPK x KM rodados).
  double get wearMaintenanceCost => kmDriven * cpkRate;

  /// Lucro Líquido Real do Turno:
  /// Faturamento Bruto - Combustível - Desgaste Veicular (CPK).
  double get netProfit {
    final net = grossEarned - fuelSpent - wearMaintenanceCost;
    return net > 0 ? net : 0.0;
  }

  /// Taxa Líquida Real por Hora ($/hora limpo).
  double get netHourlyRate {
    if (onlineHours <= 0.05) return 0.0;
    return netProfit / onlineHours;
  }

  NetRatePerformance get performance {
    if (netHourlyRate >= 35.0) return NetRatePerformance.high;
    if (netHourlyRate >= 22.0) return NetRatePerformance.normal;
    return NetRatePerformance.low;
  }

  ShiftModel copyWith({
    String? shiftId,
    bool? isOnline,
    DateTime? startedAt,
    int? onlineDurationSeconds,
    double? grossEarned,
    double? fuelSpent,
    int? kmDriven,
    int? ridesCompleted,
    double? cpkRate,
  }) {
    return ShiftModel(
      shiftId: shiftId ?? this.shiftId,
      isOnline: isOnline ?? this.isOnline,
      startedAt: startedAt ?? this.startedAt,
      onlineDurationSeconds:
          onlineDurationSeconds ?? this.onlineDurationSeconds,
      grossEarned: grossEarned ?? this.grossEarned,
      fuelSpent: fuelSpent ?? this.fuelSpent,
      kmDriven: kmDriven ?? this.kmDriven,
      ridesCompleted: ridesCompleted ?? this.ridesCompleted,
      cpkRate: cpkRate ?? this.cpkRate,
    );
  }
}
