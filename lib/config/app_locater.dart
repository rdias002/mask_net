import 'package:get_it/get_it.dart';

import '../data/app_repo.dart';
import '../data/auth_repo.dart';
import '../data/post_repo.dart';
import 'auth_guard.dart';

final locator = GetIt.instance;

Future<void> initializeDependencies() async {
  locator.registerSingleton<AppRepo>(AppRepo());

  locator.registerSingleton<AuthRepo>(AuthRepo());

  locator.registerSingleton<PostRepo>(PostRepo());

  locator.registerSingleton<AuthGuard>(AuthGuard());
}
