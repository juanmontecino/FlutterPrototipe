import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/helpers/preferences.dart';
import 'package:flutter_guide_2024/providers/theme_provider.dart';
import 'package:flutter_guide_2024/providers/news_provider.dart';
import 'package:flutter_guide_2024/screens/screens.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initShared();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(isDarkMode: Preferences.darkmode),
      ),
      ChangeNotifierProvider<NewsProvider>( // Añadir este provider
        create: (_) => NewsProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<ThemeProvider>(context, listen: true);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        /* theme: Preferences.darkmode ? ThemeData.dark() : ThemeData.light(), */
        theme: tema.temaActual,
        routes: {
          'home': (context) => const HomeScreen(),
          'provider_navigation_bar_provider': (context) =>
              NewsScreen(),
          'profile': (context) => ProfileScreen(),
          // 'custom_list_item': (context) => CustomListItem(),
        }
        /* home: DesignScreen(), */
        );
  }
}
