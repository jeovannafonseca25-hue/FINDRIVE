import 'package:flutter/widgets.dart';

import 'home_coordinator.dart';
import 'home_view.dart';
import 'home_view_model.dart';
import 'server_home.dart';

/// Montador da cena do Dashboard Principal FINDRIVE.
abstract final class HomeFactory {
  static Widget make({HomeCoordinator? coordinator, ServerHome? server}) {
    final serverHome = server ?? const DefaultServerHome();
    final homeCoordinator = coordinator ?? DefaultHomeCoordinator();
    final viewModel = HomeViewModel(
      serverHome: serverHome,
      coordinator: homeCoordinator,
    );
    return HomeView(viewModel: viewModel);
  }
}
