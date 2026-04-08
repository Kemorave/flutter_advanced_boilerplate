import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/utils/constants.dart';
import 'package:go_router/go_router.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> with WidgetsBindingObserver {
  final GlobalKey _key = GlobalKey();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepaintBoundary(key: _key, child: widget.navigationShell),
      bottomNavigationBar: BottomNavigationBar(
        items: $constants.navigation.bottomNavigationItems(context),
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) => widget.navigationShell.goBranch(
          index,
          initialLocation: index == widget.navigationShell.currentIndex,
        ),
      ),
    );
  }
}
