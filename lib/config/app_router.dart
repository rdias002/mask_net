import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../data/model/companies.dart';
import '../presentation/screens/company_post_screen.dart';
import '../presentation/screens/create_post_screen.dart';
import '../presentation/screens/forgot_password.dart';

import '../presentation/screens/home_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/search_post_screen.dart';
import '../presentation/screens/sign_up_screen.dart';
import '../presentation/screens/username_screen.dart';
import '../presentation/screens/view_post_screen.dart';
import '../presentation/screens/image_viewer.dart';
import 'app_locater.dart';
import 'auth_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            page: HomeRoute.page,
            initial: true,
            guards: [locator<AuthGuard>()]),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: ChooseUserNameRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: CreatePostRoute.page),
        AutoRoute(page: ViewPostRoute.page),
        AutoRoute(page: ImageViewerRoute.page),
        AutoRoute(page: CompanyPostRoute.page),
        AutoRoute(page: SearchPostRoute.page),
      ];

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
}

final appRouter = AppRouter();
