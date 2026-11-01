import 'package:flutter/widgets.dart';

import 'overlay_preview_coordinator.dart';
import 'overlay_preview_view.dart';
import 'overlay_preview_view_model.dart';
import 'server_overlay_preview.dart';

/// Montador da cena de Simulação do Widget Suspenso (Overlay Android).
abstract final class OverlayPreviewFactory {
  static Widget make({
    OverlayPreviewCoordinator? coordinator,
    ServerOverlayPreview? server,
  }) {
    final serverOverlay = server ?? const DefaultServerOverlayPreview();
    final overlayCoordinator = coordinator ?? DefaultOverlayPreviewCoordinator();
    final viewModel = OverlayPreviewViewModel(
      server: serverOverlay,
      coordinator: overlayCoordinator,
    );
    return OverlayPreviewView(viewModel: viewModel);
  }
}
