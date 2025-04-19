import 'package:flutter_tmdb_app/core/service/remote/api_service.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // Service Locator

Future<void> initializeDependencies() async {
  // Repository
/*   sl.registerLazySingleton(() => AuthRepository(sl()));
  sl.registerLazySingleton(() => InvoiceRepository(sl()));

  // Controller
  sl.registerFactory(() => AuthController(authRepository: sl()));
  sl.registerFactory(
      () => InvoiceController(invoiceRepository: sl(), turmobRepository: sl())); */
  // Service
  sl.registerLazySingleton(() => ApiService(sl()));
}
