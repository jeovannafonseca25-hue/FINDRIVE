import 'package:carteira_design_system/carteira_design_system.dart';

/// Modelo de Alerta Inteligente que converte despesas a vencer em esforço de trabalho.
class SmartAlertModel {
  const SmartAlertModel({
    required this.id,
    required this.title,
    required this.message,
    required this.billAmount,
    required this.ridesEquivalent,
    this.priority = SmartNotificationPriority.high,
  });

  final String id;
  final String title;
  final String message;
  final double billAmount;
  final int ridesEquivalent;
  final SmartNotificationPriority priority;
}
