// lib/screens/news_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/navigation_provider.dart';
import 'news_listview_builder.dart';
import 'news_search.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NavigationProvider(),
      child: const _NewsView(),
    );
  }
}

class _NewsView extends StatelessWidget {
  const _NewsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const _NavigationBody(),
      bottomNavigationBar: const _NavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: const Text('Noticias'),
      backgroundColor: Colors.indigo[900],
      elevation: 10,
      toolbarHeight: 80,
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar();

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();

    return BottomNavigationBar(
      currentIndex: navigationProvider.currentPage,
      elevation: 10,
      unselectedItemColor: Colors.grey,
      onTap: navigationProvider.setPage,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Noticias',
          activeIcon: Icon(Icons.list_alt, color: Colors.indigo),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Buscar Noticia',
          activeIcon: Icon(Icons.search, color: Colors.indigo),
        ),
      ],
    );
  }
}

class _NavigationBody extends StatelessWidget {
  const _NavigationBody();

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();

    return IndexedStack(
      index: navigationProvider.currentPage,
      children: const [
        NewsListScreen(),
        NewsSearchScreen(),
      ],
    );
  }
}