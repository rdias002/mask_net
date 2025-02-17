import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_router.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard();

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final authUser = FirebaseAuth.instance.currentUser;
    // the navigation is paused until resolver.next() is called with either
    // true to resume/continue navigation or false to abort navigation
    if (authUser == null) {
      resolver.redirect(LoginRoute(
        isSuccess: (success) => resolver.next(success),
      ));
    } else if (authUser.displayName?.isNotEmpty != true) {
      resolver.redirect(ChooseUserNameRoute(
        isSuccess: (success) => resolver.next(success),
      ));
    } else {
      resolver.next(true);
    }
  }
}
