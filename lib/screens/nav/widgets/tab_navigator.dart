import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../config/custom_router.dart';
import '../../../enums/bottom_nav_item.dart';
import '../../../repositories/repositories.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../screens.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({Key? key, required this.navigatorKey, required this.item})
      : super(key: key);

  static const String tabNavigatorRoot = '/';
  final GlobalKey<NavigatorState>? navigatorKey;
  final BottomNavItem item;

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute]!(context),
          )
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return FeedScreen();
      case BottomNavItem.search:
        return SearchScreen();
      case BottomNavItem.create:
        return CreatePostsScreen();
      case BottomNavItem.notifications:
        return NotificationsScreen();
      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(
              ProfileLoadUser(userId: context.read<AuthBloc>().state.user!.uid),
            ),
          child: ProfileScreen(),
        );
    }
  }
}
