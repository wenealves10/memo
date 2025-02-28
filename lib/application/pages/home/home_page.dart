import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:memo/application/constants/images.dart' as images;
import 'package:memo/application/constants/strings.dart' as strings;
import 'package:memo/application/coordinator/routes_coordinator.dart';
import 'package:memo/application/pages/home/collections/collections_page.dart';
import 'package:memo/application/pages/home/progress/progress_page.dart';
import 'package:memo/application/widgets/theme/themed_container.dart';
import 'package:memo/application/widgets/material/asset_icon_button.dart';

enum HomeBottomTab { collections, progress }

class HomePage extends StatelessWidget {
  const HomePage({required this.bottomTab, Key? key}) : super(key: key);

  final HomeBottomTab bottomTab;

  @override
  Widget build(BuildContext context) {
    final tabIndex = HomeBottomTab.values.indexOf(bottomTab);

    return Scaffold(
      appBar: _AppBar(bottomTab),
      // IndexedStack to retain each page state, more specifically, to preserving scrolling
      body: IndexedStack(
        index: tabIndex,
        children: [
          CollectionsPage(),
          ProgressPage(),
        ],
      ),
      bottomNavigationBar: _BottomAppBar(bottomTab),
    );
  }
}

// A custom app bar as `PreferredSizeWidget`, to conform to the requirements of a `Scaffold.appBar`
class _AppBar extends HookWidget implements PreferredSizeWidget {
  const _AppBar(this._tab);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final HomeBottomTab _tab;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_tab.title),
      actions: [
        AssetIconButton(
          images.settingsAsset,
          onPressed: () {
            readCoordinator(context).navigateToSettings();
          },
        ),
      ],
    );
  }
}

class _BottomAppBar extends HookWidget {
  const _BottomAppBar(this._tab);

  final HomeBottomTab _tab;

  @override
  Widget build(BuildContext context) {
    final tabItems = HomeBottomTab.values
        .map(
          (tab) => BottomNavigationBarItem(icon: tab.icon, label: tab.title),
        )
        .toList();

    return ThemedBottomContainer(
      child: BottomNavigationBar(
        onTap: (index) {
          switch (HomeBottomTab.values[index]) {
            case HomeBottomTab.collections:
              readCoordinator(context).navigateToStudy();
              break;
            case HomeBottomTab.progress:
              readCoordinator(context).navigateToProgress();
              break;
          }
        },
        currentIndex: HomeBottomTab.values.indexOf(_tab),
        items: tabItems,
      ),
    );
  }
}

extension _TabMetadata on HomeBottomTab {
  String get title {
    switch (this) {
      case HomeBottomTab.collections:
        return strings.collectionsNavigationTab;
      case HomeBottomTab.progress:
        return strings.progressNavigationTab;
    }
  }

  ImageIcon get icon {
    switch (this) {
      case HomeBottomTab.collections:
        return ImageIcon(AssetImage(images.folderAsset));
      case HomeBottomTab.progress:
        return ImageIcon(AssetImage(images.trendingUpArrowAsset));
    }
  }
}
