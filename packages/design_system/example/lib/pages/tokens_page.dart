import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class TokensPage extends StatelessWidget {
  const TokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = context.semanticColors;
    final swatches = <(String, Color)>[
      ('primary (99 Yellow)', scheme.primary),
      ('primaryContainer', scheme.primaryContainer),
      ('surface (Uber Dark)', scheme.surface),
      ('surfaceVariant', scheme.surfaceContainerHighest),
      ('outline', scheme.outline),
      ('income (Lucro)', semantic.income),
      ('expense (Custos)', semantic.expense),
      ('vault (Manutenção)', semantic.vault),
      ('warning (Alerta)', semantic.warning),
      ('transfer', semantic.transfer),
      ('muted', semantic.muted),
      ('brandYellow', semantic.brandYellow),
      ('uberBlack', semantic.uberBlack),
    ];
    final text = Theme.of(context).textTheme;
    final styles = <(String, TextStyle?)>[
      ('displayLarge', text.displayLarge),
      ('headlineMedium', text.headlineMedium),
      ('titleLarge', text.titleLarge),
      ('titleMedium', text.titleMedium),
      ('bodyLarge', text.bodyLarge),
      ('bodyMedium', text.bodyMedium),
      ('bodySmall', text.bodySmall),
      ('labelSmall', text.labelSmall),
    ];

    return AppScaffold(
      title: 'Tokens',
      actions: const [ThemeModeButton()],
      body: ListView(
        children: [
          const SectionHeader(title: 'Cores FINDRIVE (99 + Uber Minimalist)'),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (name, color) in swatches)
                SizedBox(
                  width: 104,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: AppRadius.mdAll,
                          border: Border.all(color: scheme.outline),
                        ),
                      ),
                      const Gap.xxs(),
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelSmall.copyWith(
                          color: scheme.onSurface,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const Gap.lg(),
          const SectionHeader(title: 'Tipografia Geométrica'),
          for (final (name, style) in styles)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      name,
                      style: AppTypography.labelSmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'R\$ 450,00 Meta',
                      style: style,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const Gap.lg(),
          const SectionHeader(title: 'Espaçamentos'),
          Wrap(
            spacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final (name, size) in const [
                ('xxs', AppSpacing.xxs),
                ('xs', AppSpacing.xs),
                ('sm', AppSpacing.sm),
                ('md', AppSpacing.md),
                ('lg', AppSpacing.lg),
                ('xl', AppSpacing.xl),
              ])
                Column(
                  children: [
                    Container(
                      width: size,
                      height: size,
                      color: scheme.primary,
                    ),
                    const Gap.xxs(),
                    Text(name, style: AppTypography.labelSmall),
                  ],
                ),
            ],
          ),
          const Gap.lg(),
          const SectionHeader(title: 'Raios de Borda'),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final (name, radius) in const [
                ('sm (6px)', AppRadius.smAll),
                ('md (12px)', AppRadius.mdAll),
                ('lg (16px)', AppRadius.lgAll),
                ('xl (24px)', AppRadius.xlAll),
                ('pill (999px)', AppRadius.pillAll),
              ])
                Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: scheme.primary, width: 2),
                        borderRadius: radius,
                      ),
                    ),
                    const Gap.xxs(),
                    Text(name, style: AppTypography.labelSmall),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
