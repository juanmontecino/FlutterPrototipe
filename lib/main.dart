import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_guide_2024/helpers/preferences.dart';
import 'package:flutter_guide_2024/providers/pokemon_provider.dart';
import 'package:flutter_guide_2024/providers/libros_provider.dart';
import 'package:flutter_guide_2024/providers/theme_provider.dart';
import 'package:flutter_guide_2024/providers/news_provider.dart';
import 'package:flutter_guide_2024/providers/canciones_provider.dart'; // Importa el nuevo provider
import 'package:flutter_guide_2024/screens/libro_detail_screen.dart';
import 'package:flutter_guide_2024/screens/libro_list_screen.dart';
import 'package:flutter_guide_2024/providers/news_search_provider.dart'; // Nuevo import
import 'package:flutter_guide_2024/screens/screens.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Preferences.initShared();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(isDarkMode: Preferences.darkmode),
      ),
      ChangeNotifierProvider<PokemonProvider>(
        create: (_) => PokemonProvider(), 
        lazy: false,
      ),

      ChangeNotifierProvider<CancionesProvider>( // Nuevo Provider
        create: (_) => CancionesProvider(),
      ),
      ChangeNotifierProvider<LibrosProvider>(
        create: (_) => LibrosProvider(),
      ),
      ChangeNotifierProvider<NewsProvider>(
        create: (_) => NewsProvider(),
      ),
      // Añadimos el NewsSearchProvider que depende de NewsProvider
      ChangeNotifierProxyProvider<NewsProvider, NewsSearchProvider>(
        create: (context) => NewsSearchProvider(
          newsProvider: context.read<NewsProvider>(),
        ),
        update: (context, newsProvider, previous) => 
          previous ?? NewsSearchProvider(newsProvider: newsProvider),
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
      theme: tema.temaActual,
      routes: {
        'home': (context) => const HomeScreen(),
        'news': (context) => NewsScreen(),
        'profile': (context) => ProfileScreen(),
        'pokemon_list': (context) => ListadoScreen(),
        'pokemon_detail': (context) => PokemonDetailScreen(),
        'canciones_lista': (context) => ListaCancionesScreen(),
        'canciones_detalle': (context) => DetalleCancionScreen(),
        'libros_list': (context) => const LibrosListScreen(),
        'libro_detail': (context) => const LibroDetailScreen(),
        'provider_navigation_bar_provider': (context) => NewsScreen(),
        'search': (context) => const NewsSearchScreen(),
      },
    );
  }
}