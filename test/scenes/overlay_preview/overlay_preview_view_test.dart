import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:carteira_digital/scenes/overlay_preview/overlay_preview_coordinator.dart';
import 'package:carteira_digital/scenes/overlay_preview/overlay_preview_factory.dart';
import 'package:carteira_digital/scenes/overlay_preview/overlay_preview_view.dart';
import 'package:carteira_digital/scenes/overlay_preview/server_overlay_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeServerOverlay implements ServerOverlayPreview {
  @override
  Future<bool> checkPermission() async => true;

  @override
  Future<void> requestPermission() async {}
}

class _FakeOverlayCoordinator implements OverlayPreviewCoordinator {
  @override
  void pop(BuildContext context) {}
}

Widget _app(Widget home) => MaterialApp(theme: AppTheme.dark(), home: home);

void main() {
  testWidgets('OverlayPreviewFactory.make builds OverlayPreviewView', (tester) async {
    await tester.pumpWidget(_app(OverlayPreviewFactory.make(
      server: _FakeServerOverlay(),
      coordinator: _FakeOverlayCoordinator(),
    )));
    await tester.pumpAndSettle();

    expect(find.byType(OverlayPreviewView), findsOneWidget);
    expect(find.text('Sobrepor a outros aplicativos'), findsOneWidget);
    expect(find.text('Checador de Corrida'), findsOneWidget);
  });
}
