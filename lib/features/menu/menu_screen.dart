import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/navigation/pages.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';

import 'package:kepleomax/features/menu/menu_navigator.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KlmAppBar(context, 'Menu'),
      body: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        children: [
          _MenuItem(
            title: 'People',
            icon: Icons.people,
            backgroundColor: Colors.red,
            onTap: () {
              AppNavigator.push(context, const PeoplePage());
            },
            key: const Key('people_menu_item'),
          ),
          _MenuItem(
            title: 'Communities',
            icon: Icons.people_alt_outlined,
            backgroundColor: Colors.orange,
            onTap: () {
              Fluttertoast.showToast(msg: 'Not working');
            },
            key: const Key('communities_menu_item'),
          ),
          _MenuItem(
            title: 'Channels',
            icon: Icons.chat_bubble,
            backgroundColor: Colors.pinkAccent.shade200,
            onTap: () {
              Fluttertoast.showToast(msg: 'Not working');
            },
            key: const Key('music_menu_item'),
          ),
          _MenuItem(
            title: 'Videos',
            icon: Icons.play_arrow,
            backgroundColor: Colors.blue.shade700,
            onTap: () {
              Fluttertoast.showToast(msg: 'Not working');
            },
            key: const Key('videos_menu_item'),
          ),
          _MenuItem(
            title: 'Games',
            icon: Icons.gamepad,
            backgroundColor: Colors.green,
            onTap: () {
              Fluttertoast.showToast(msg: 'Not working');
            },
            key: const Key('games_menu_item'),
          ),
          _MenuItem(
            title: 'Settings',
            icon: Icons.settings,
            backgroundColor: Colors.grey,
            onTap: () {
              AppNavigator.push(context, const SettingsPage());
            },
            key: const Key('settings_menu_item'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 65,
              width: 65,
              child: Icon(icon, size: 46, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(title, style: context.textTheme.bodyLarge?.copyWith(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
