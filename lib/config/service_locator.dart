// service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register the persistent http.Client as a lazy singleton
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Register the ApiService, which depends on the http.Client
  getIt.registerLazySingleton<ApiService>(() => ApiService(client: getIt<http.Client>()));
}