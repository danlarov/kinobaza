import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinobaza/core/resources/app_router.dart';
import 'package:kinobaza/core/resources/app_strings.dart';
import 'package:kinobaza/core/resources/app_routes.dart';
import 'package:kinobaza/core/resources/app_values.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.child});

  final Widget child;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          final String location = GoRouterState.of(context).uri.path;
          if (!location.startsWith(moviesPath)) {
            _onItemTapped(0, context);
          }
        },
        child: widget.child,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
        ),
        iconSize: 32,
        items: const [
          BottomNavigationBarItem(
            label: AppStrings.movies,
            icon: Icon(Icons.slow_motion_video_rounded),
          ),
          BottomNavigationBarItem(
            label: AppStrings.shows,
            icon: Icon(Icons.live_tv_rounded),
          ),
          BottomNavigationBarItem(
            label: AppStrings.search,
            icon: Icon(Icons.search_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Билеты',
            icon: Icon(Icons.local_activity_rounded),
          ),
          BottomNavigationBarItem(
            label: AppStrings.watchlist,
            icon: Icon(Icons.favorite_rounded),
          ),
        ],
        currentIndex: _getSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(moviesPath)) return 0;
    if (location.startsWith(tvShowsPath)) return 1;
    if (location.startsWith(searchPath)) return 2;
    if (location.startsWith(ticketsPath)) return 3;
    if (location.startsWith(watchlistPath)) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(AppRoutes.moviesRoute);
        break;
      case 1:
        context.goNamed(AppRoutes.tvShowsRoute);
        break;
      case 2:
        context.goNamed(AppRoutes.searchRoute);
        break;
      case 3:
        context.goNamed(AppRoutes.ticketsRoute);
        break;
      case 4:
        context.goNamed(AppRoutes.watchlistRoute);
        break;
    }
  }
}