// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ChooseUserNameRoute.name: (routeData) {
      final args = routeData.argsAs<ChooseUserNameRouteArgs>(
          orElse: () => const ChooseUserNameRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ChooseUserNameScreen(
          key: args.key,
          isSuccess: args.isSuccess,
        ),
      );
    },
    CompanyPostRoute.name: (routeData) {
      final args = routeData.argsAs<CompanyPostRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CompanyPostScreen(
          key: args.key,
          companyId: args.companyId,
        ),
      );
    },
    CreatePostRoute.name: (routeData) {
      final args = routeData.argsAs<CreatePostRouteArgs>(
          orElse: () => const CreatePostRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: CreatePostScreen(
          key: args.key,
          companyId: args.companyId,
        ),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ForgotPasswordScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    ImageViewerRoute.name: (routeData) {
      final args = routeData.argsAs<ImageViewerRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ImageViewerScreen(
          key: args.key,
          image: args.image,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      final args = routeData.argsAs<LoginRouteArgs>(
          orElse: () => const LoginRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: LoginScreen(
          key: args.key,
          isSuccess: args.isSuccess,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProfileScreen(),
      );
    },
    SearchPostRoute.name: (routeData) {
      final args = routeData.argsAs<SearchPostRouteArgs>(
          orElse: () => const SearchPostRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchPostScreen(
          key: args.key,
          companyId: args.companyId,
        ),
      );
    },
    SignUpRoute.name: (routeData) {
      final args = routeData.argsAs<SignUpRouteArgs>(
          orElse: () => const SignUpRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SignUpScreen(
          key: args.key,
          isSuccess: args.isSuccess,
        ),
      );
    },
    ViewPostRoute.name: (routeData) {
      final args = routeData.argsAs<ViewPostRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ViewPostScreen(
          args.postId,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [ChooseUserNameScreen]
class ChooseUserNameRoute extends PageRouteInfo<ChooseUserNameRouteArgs> {
  ChooseUserNameRoute({
    Key? key,
    dynamic Function(bool)? isSuccess,
    List<PageRouteInfo>? children,
  }) : super(
          ChooseUserNameRoute.name,
          args: ChooseUserNameRouteArgs(
            key: key,
            isSuccess: isSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'ChooseUserNameRoute';

  static const PageInfo<ChooseUserNameRouteArgs> page =
      PageInfo<ChooseUserNameRouteArgs>(name);
}

class ChooseUserNameRouteArgs {
  const ChooseUserNameRouteArgs({
    this.key,
    this.isSuccess,
  });

  final Key? key;

  final dynamic Function(bool)? isSuccess;

  @override
  String toString() {
    return 'ChooseUserNameRouteArgs{key: $key, isSuccess: $isSuccess}';
  }
}

/// generated route for
/// [CompanyPostScreen]
class CompanyPostRoute extends PageRouteInfo<CompanyPostRouteArgs> {
  CompanyPostRoute({
    Key? key,
    required String companyId,
    List<PageRouteInfo>? children,
  }) : super(
          CompanyPostRoute.name,
          args: CompanyPostRouteArgs(
            key: key,
            companyId: companyId,
          ),
          initialChildren: children,
        );

  static const String name = 'CompanyPostRoute';

  static const PageInfo<CompanyPostRouteArgs> page =
      PageInfo<CompanyPostRouteArgs>(name);
}

class CompanyPostRouteArgs {
  const CompanyPostRouteArgs({
    this.key,
    required this.companyId,
  });

  final Key? key;

  final String companyId;

  @override
  String toString() {
    return 'CompanyPostRouteArgs{key: $key, companyId: $companyId}';
  }
}

/// generated route for
/// [CreatePostScreen]
class CreatePostRoute extends PageRouteInfo<CreatePostRouteArgs> {
  CreatePostRoute({
    Key? key,
    String companyId = channelGeneral,
    List<PageRouteInfo>? children,
  }) : super(
          CreatePostRoute.name,
          args: CreatePostRouteArgs(
            key: key,
            companyId: companyId,
          ),
          initialChildren: children,
        );

  static const String name = 'CreatePostRoute';

  static const PageInfo<CreatePostRouteArgs> page =
      PageInfo<CreatePostRouteArgs>(name);
}

class CreatePostRouteArgs {
  const CreatePostRouteArgs({
    this.key,
    this.companyId = channelGeneral,
  });

  final Key? key;

  final String companyId;

  @override
  String toString() {
    return 'CreatePostRouteArgs{key: $key, companyId: $companyId}';
  }
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ImageViewerScreen]
class ImageViewerRoute extends PageRouteInfo<ImageViewerRouteArgs> {
  ImageViewerRoute({
    Key? key,
    required String image,
    List<PageRouteInfo>? children,
  }) : super(
          ImageViewerRoute.name,
          args: ImageViewerRouteArgs(
            key: key,
            image: image,
          ),
          initialChildren: children,
        );

  static const String name = 'ImageViewerRoute';

  static const PageInfo<ImageViewerRouteArgs> page =
      PageInfo<ImageViewerRouteArgs>(name);
}

class ImageViewerRouteArgs {
  const ImageViewerRouteArgs({
    this.key,
    required this.image,
  });

  final Key? key;

  final String image;

  @override
  String toString() {
    return 'ImageViewerRouteArgs{key: $key, image: $image}';
  }
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    dynamic Function(bool)? isSuccess,
    List<PageRouteInfo>? children,
  }) : super(
          LoginRoute.name,
          args: LoginRouteArgs(
            key: key,
            isSuccess: isSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<LoginRouteArgs> page = PageInfo<LoginRouteArgs>(name);
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.isSuccess,
  });

  final Key? key;

  final dynamic Function(bool)? isSuccess;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, isSuccess: $isSuccess}';
  }
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchPostScreen]
class SearchPostRoute extends PageRouteInfo<SearchPostRouteArgs> {
  SearchPostRoute({
    Key? key,
    String companyId = 'general',
    List<PageRouteInfo>? children,
  }) : super(
          SearchPostRoute.name,
          args: SearchPostRouteArgs(
            key: key,
            companyId: companyId,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchPostRoute';

  static const PageInfo<SearchPostRouteArgs> page =
      PageInfo<SearchPostRouteArgs>(name);
}

class SearchPostRouteArgs {
  const SearchPostRouteArgs({
    this.key,
    this.companyId = 'general',
  });

  final Key? key;

  final String companyId;

  @override
  String toString() {
    return 'SearchPostRouteArgs{key: $key, companyId: $companyId}';
  }
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<SignUpRouteArgs> {
  SignUpRoute({
    Key? key,
    dynamic Function(bool)? isSuccess,
    List<PageRouteInfo>? children,
  }) : super(
          SignUpRoute.name,
          args: SignUpRouteArgs(
            key: key,
            isSuccess: isSuccess,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const PageInfo<SignUpRouteArgs> page = PageInfo<SignUpRouteArgs>(name);
}

class SignUpRouteArgs {
  const SignUpRouteArgs({
    this.key,
    this.isSuccess,
  });

  final Key? key;

  final dynamic Function(bool)? isSuccess;

  @override
  String toString() {
    return 'SignUpRouteArgs{key: $key, isSuccess: $isSuccess}';
  }
}

/// generated route for
/// [ViewPostScreen]
class ViewPostRoute extends PageRouteInfo<ViewPostRouteArgs> {
  ViewPostRoute({
    required String postId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          ViewPostRoute.name,
          args: ViewPostRouteArgs(
            postId: postId,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewPostRoute';

  static const PageInfo<ViewPostRouteArgs> page =
      PageInfo<ViewPostRouteArgs>(name);
}

class ViewPostRouteArgs {
  const ViewPostRouteArgs({
    required this.postId,
    this.key,
  });

  final String postId;

  final Key? key;

  @override
  String toString() {
    return 'ViewPostRouteArgs{postId: $postId, key: $key}';
  }
}
