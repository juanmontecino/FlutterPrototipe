import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/helpers/preferences.dart';
import 'package:flutter_guide_2024/providers/theme_provider.dart';
import 'package:flutter_guide_2024/providers/canciones_provider.dart'; // Importa el nuevo provider
import 'package:flutter_guide_2024/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initShared();
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(isDarkMode: Preferences.darkmode),
      ),
      ChangeNotifierProvider<CancionesProvider>( // Nuevo Provider
        create: (_) => CancionesProvider(),
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
        'profile': (context) => ProfileScreen(),
        'canciones_lista': (context) => ListaCancionesScreen(), 
        'canciones_detalle': (context) => DetalleCancionScreen(), 
      },
    );
  }
}
