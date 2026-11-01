import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'pages/buttons_page.dart';
import 'pages/findrive_cards_page.dart';
import 'pages/inputs_page.dart';
import 'pages/lists_page.dart';
import 'pages/states_page.dart';
import 'pages/tokens_page.dart';

void main() => runApp(const GalleryApp());

/// Theme mode chosen in the gallery. A [ValueNotifier] is enough: one value,
/// one listener, no package.
final themeMode = ValueNotifier<ThemeMode>(ThemeMode.dark);

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'FINDRIVE Design System Gallery',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: mode,
        home: const GalleryHome(),
      ),
    );
  }
}

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  static final _pages = <({String title, String subtitle, IconData icon, Widget page})>[
    (
      title: 'FINDRIVE Components',
      subtitle: 'Meta Reversa, Hora Líquida, Manutenção, Break-Even & Overlay',
      icon: Icons.electric_car_rounded,
      page: const FindriveCardsPage(),
    ),
    (
      title: 'Tokens de Design',
      subtitle: '99 Yellow, Uber Jet Black, Tipografia e Espaçamentos',
      icon: Icons.palette_outlined,
      page: const TokensPage(),
    ),
    (
      title: 'Botões',
      subtitle: 'Ações primárias 99, secundárias e texto minimalista',
      icon: Icons.smart_button,
      page: const ButtonsPage(),
    ),
    (
      title: 'Campos de Entrada',
      subtitle: 'Inputs limpos com ícones e máscaras de moeda',
      icon: Icons.edit_outlined,
      page: const InputsPage(),
    ),
    (
      title: 'Listas e Cards',
      subtitle: 'Extratos, transações e saldo com micro-bordas',
      icon: Icons.list_alt,
      page: const ListsPage(),
    ),
    (
      title: 'Estados de Tela',
      subtitle: 'Carregamento, vazio e erro com feedback háptico',
      icon: Icons.hourglass_empty,
      page: const StatesPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'FINDRIVE Gallery',
      actions: const [ThemeModeButton()],
      padded: false,
      body: ListView.separated(
        itemCount: _pages.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _pages[index];
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 22,
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              item.subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, size: 20),
            onTap: () =>
                Navigator.of(context)
                    .push(MaterialPageRoute<void>(builder: (_) => item.page)),
          );
        },
      ),
    );
  }
}

/// Cycles dark -> light -> system.
class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        final icon = switch (mode) {
          ThemeMode.system => Icons.brightness_auto,
          ThemeMode.light => Icons.light_mode,
          ThemeMode.dark => Icons.dark_mode,
        };
        return IconButton(
          tooltip: 'Tema: ${mode.name}',
          icon: Icon(icon),
          onPressed: () {
            themeMode.value = switch (mode) {
              ThemeMode.dark => ThemeMode.light,
              ThemeMode.light => ThemeMode.system,
              ThemeMode.system => ThemeMode.dark,
            };
          },
        );
      },
    );
  }
}
