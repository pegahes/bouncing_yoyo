import 'package:get_it/get_it.dart';

import '../page_manager.dart';

final getIt = GetIt.instance;

void setupInstance() {
  getIt.registerLazySingleton<PageManager>(
          () => PageManager());
}