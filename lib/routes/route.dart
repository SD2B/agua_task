import 'package:agua_task/core/common_enums.dart';
import 'package:agua_task/core/constants.dart';
import 'package:agua_task/onboarding.dart';
import 'package:agua_task/view/add_task/add_task.dart';
import 'package:agua_task/view/custom_scaffold.dart';
import 'package:agua_task/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter myRoute = GoRouter(
  initialLocation: "/",
  redirectLimit: 3,
  errorBuilder: (context, state) {
    return Scaffold(body: Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [const Text('Unknown pages'), ElevatedButton(onPressed: () => context.go("/"), child: const Text("Back"))])));
  },
  navigatorKey: ConstantData.navigatorKey,
  routes: _buildRoutes(),
);

final Future<bool?> isLoaded = splashLoad();
List<RouteBase> _buildRoutes() {
  return [
    GoRoute(
      path: '/',
      name: '/',
      parentNavigatorKey: ConstantData.navigatorKey,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOutSine).animate(animation),
            child: child,
          );
        },
        child: FutureBuilder<bool?>(
          future: isLoaded,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Onboarding();
            }
            return const CustomScaffold(isHome: true, child: Home());
          },
        ),
      ),
      routes: [
        ..._staticRoutes(),
      ],
    ),
  ];
}

List<GoRoute> _staticRoutes() {
  return [
    GoRoute(
      path: RouteEnum.home.name,
      name: RouteEnum.home.name,
      pageBuilder: (BuildContext context, GoRouterState state) => CustomTransitionPage(
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: CurveTween(curve: Curves.easeInOutSine).animate(animation), child: child);
        },
        child: const CustomScaffold(isHome: true, child: Home()),
      ),
    ),
    GoRoute(
      path: RouteEnum.addTask.name,
      name: RouteEnum.addTask.name,
      pageBuilder: (BuildContext context, GoRouterState state) => CustomTransitionPage(
        key: state.pageKey,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: CurveTween(curve: Curves.easeInOutSine).animate(animation), child: child);
        },
        child: const CustomScaffold(
          enableBack: true,
          appBarTitle: "Add Task",
          child: AddTask(),
        ),
      ),
    ),
  ];
}

Future<bool> splashLoad() async {
  await Future.delayed(const Duration(seconds: 3));
  return true;
}
