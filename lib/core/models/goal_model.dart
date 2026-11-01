/// Modelo de cálculo da Meta Reversa Diária e Semanal do FINDRIVE.
class GoalModel {
  const GoalModel({
    required this.targetMonthlyNetIncome,
    required this.householdFixedCosts,
    required this.vehicleFixedCosts,
    required this.workingDaysPerMonth,
    required this.maintenanceRetentionRate,
    required this.fuelExpenseRate,
    this.daysOffWeeklyCount = 2,
    this.ridesAverageTicket = 28.50,
  });

  /// Lucro Líquido almejado no mês (para guardar ou despesas livres).
  final double targetMonthlyNetIncome;

  /// Custos fixos da casa (aluguel, contas de luz/água, mercado).
  final double householdFixedCosts;

  /// Custos fixos do veículo (aluguel semanal mensalizado ou parcela/seguro/IPVA).
  final double vehicleFixedCosts;

  /// Quantidade de dias úteis trabalhados no mês.
  final int workingDaysPerMonth;

  /// Retenção automática para a Carteira de Manutenção (ex: 0.10 para 10%).
  final double maintenanceRetentionRate;

  /// Custo médio percentual estimado de combustível (ex: 0.24 para 24%).
  final double fuelExpenseRate;

  /// Número de dias de folga programados por semana (ex: 2 para Modo Folga Garantida).
  final int daysOffWeeklyCount;

  /// Ticket médio líquido por corrida para estimativas.
  final double ridesAverageTicket;

  double get totalMonthlyFixedCosts => householdFixedCosts + vehicleFixedCosts;

  double get dailyFixedCost =>
      workingDaysPerMonth > 0 ? totalMonthlyFixedCosts / workingDaysPerMonth : 0.0;

  double get dailyNetIncomeTarget =>
      workingDaysPerMonth > 0 ? targetMonthlyNetIncome / workingDaysPerMonth : 0.0;

  double get dailyNetRequired => dailyFixedCost + dailyNetIncomeTarget;

  /// Meta Bruta Diária Reversa:
  /// Faturamento necessário para pagar custos fixos do dia, lucro desejado,
  /// retenção de manutenção e combustível.
  double get dailyGrossTarget {
    final marginDivider = 1.0 - maintenanceRetentionRate - fuelExpenseRate;
    if (marginDivider <= 0.1) return dailyNetRequired * 1.5;
    return dailyNetRequired / marginDivider;
  }

  /// Valor diário destinado à Carteira de Manutenção.
  double get dailyMaintenanceAllocation => dailyGrossTarget * maintenanceRetentionRate;

  /// Valor diário estimado para abastecimento.
  double get dailyFuelAllocation => dailyGrossTarget * fuelExpenseRate;

  /// Corridas médias necessárias por dia.
  int get estimatedRidesPerDay {
    if (ridesAverageTicket <= 0) return 15;
    return (dailyGrossTarget / ridesAverageTicket).ceil();
  }

  /// Horas estimadas necessárias por dia assumindo ritmo médio de R$ 55/h bruto.
  double get estimatedHoursNeededPerDay {
    const estimatedGrossPerHour = 55.0;
    return dailyGrossTarget / estimatedGrossPerHour;
  }

  GoalModel copyWith({
    double? targetMonthlyNetIncome,
    double? householdFixedCosts,
    double? vehicleFixedCosts,
    int? workingDaysPerMonth,
    double? maintenanceRetentionRate,
    double? fuelExpenseRate,
    int? daysOffWeeklyCount,
    double? ridesAverageTicket,
  }) {
    return GoalModel(
      targetMonthlyNetIncome:
          targetMonthlyNetIncome ?? this.targetMonthlyNetIncome,
      householdFixedCosts: householdFixedCosts ?? this.householdFixedCosts,
      vehicleFixedCosts: vehicleFixedCosts ?? this.vehicleFixedCosts,
      workingDaysPerMonth: workingDaysPerMonth ?? this.workingDaysPerMonth,
      maintenanceRetentionRate:
          maintenanceRetentionRate ?? this.maintenanceRetentionRate,
      fuelExpenseRate: fuelExpenseRate ?? this.fuelExpenseRate,
      daysOffWeeklyCount: daysOffWeeklyCount ?? this.daysOffWeeklyCount,
      ridesAverageTicket: ridesAverageTicket ?? this.ridesAverageTicket,
    );
  }
}
