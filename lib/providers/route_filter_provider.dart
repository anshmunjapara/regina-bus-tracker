import 'package:flutter/cupertino.dart';

class RouteFilterProvider extends ChangeNotifier {
  late Set<String> _selectedRoutes = <String>{};

  Set<String> get selectedRoutes => _selectedRoutes;

  bool get isFilterActive => _selectedRoutes.isNotEmpty;

  void toggleRoute(String routeId) {
    if (_selectedRoutes.contains(routeId)) {
      _selectedRoutes.remove(routeId);
    } else {
      _selectedRoutes.add(routeId);
    }
    notifyListeners();
  }

  void clearFilters() {
    _selectedRoutes.clear();
    notifyListeners();
  }
}
