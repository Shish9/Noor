import 'package:flutter/foundation.dart';

import '../services/storage_service.dart';

/// Top-level app lifecycle state — first launch, current bottom-nav tab.
class AppState extends ChangeNotifier {
  AppState() {
    // Prefs box is opened synchronously in main() before runApp,
    // so we can read the flag during construction without flicker.
    final bool seen = StorageService.instance
            .getPref<bool>('onboarding_complete', fallback: false) ??
        false;
    _isFirstLaunch = !seen;
    _bootstrapped = true;
  }

  late bool _isFirstLaunch;
  bool get isFirstLaunch => _isFirstLaunch;

  int _currentTab = 0;
  int get currentTab => _currentTab;

  late bool _bootstrapped;
  bool get bootstrapped => _bootstrapped;

  /// Kept for compatibility with main() which calls `..bootstrap()`.
  /// Construction already loaded state, so this is a no-op.
  Future<void> bootstrap() async {}

  Future<void> completeOnboarding() async {
    await StorageService.instance.setPref('onboarding_complete', true);
    _isFirstLaunch = false;
    notifyListeners();
  }

  void setTab(int index) {
    if (_currentTab == index) return;
    _currentTab = index;
    notifyListeners();
  }
}
