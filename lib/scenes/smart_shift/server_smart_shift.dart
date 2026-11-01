class SmartShiftData {
  const SmartShiftData({
    required this.dayOfWeek,
    required this.recommendedWindow,
    required this.reason,
    required this.averageRatePerHour,
    required this.blocks,
  });

  final String dayOfWeek;
  final String recommendedWindow;
  final String reason;
  final double averageRatePerHour;
  final List<SmartShiftBlock> blocks;
}

class SmartShiftBlock {
  const SmartShiftBlock({
    required this.timeRange,
    required this.demandLevel,
    required this.score,
    required this.expectedNetRate,
    this.isRecommended = false,
  });

  final String timeRange;
  final String demandLevel;
  final int score;
  final double expectedNetRate;
  final bool isRecommended;
}

abstract interface class ServerSmartShift {
  Future<SmartShiftData> fetchHeatmap(String dayOfWeek);
}

class DefaultServerSmartShift implements ServerSmartShift {
  const DefaultServerSmartShift();

  @override
  Future<SmartShiftData> fetchHeatmap(String dayOfWeek) async {
    return const SmartShiftData(
      dayOfWeek: 'Sexta-feira',
      recommendedWindow: '17:00 às 23:00',
      reason:
          'Alta concentração de saídas corporativas e eventos noturnos com tarifa dinâmica intensa nas plataformas.',
      averageRatePerHour: 48.50,
      blocks: [
        SmartShiftBlock(
          timeRange: '06:00 - 09:00',
          demandLevel: 'Pico Manhã (Trabalho)',
          score: 92,
          expectedNetRate: 42.00,
        ),
        SmartShiftBlock(
          timeRange: '09:00 - 12:00',
          demandLevel: 'Baixa Demanda',
          score: 45,
          expectedNetRate: 24.00,
        ),
        SmartShiftBlock(
          timeRange: '12:00 - 14:00',
          demandLevel: 'Almoço Corporativo',
          score: 72,
          expectedNetRate: 34.50,
        ),
        SmartShiftBlock(
          timeRange: '14:00 - 17:00',
          demandLevel: 'Baixa Demanda',
          score: 52,
          expectedNetRate: 25.00,
        ),
        SmartShiftBlock(
          timeRange: '17:00 - 20:30',
          demandLevel: 'Super Pico (Volta e Lazer)',
          score: 98,
          expectedNetRate: 51.20,
          isRecommended: true,
        ),
        SmartShiftBlock(
          timeRange: '20:30 - 23:30',
          demandLevel: 'Pico Noturno',
          score: 88,
          expectedNetRate: 44.00,
        ),
      ],
    );
  }
}
