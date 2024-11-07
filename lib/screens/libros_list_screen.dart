import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibrosNavigationProvider extends StatelessWidget {
  const LibrosNavigationProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _handlerPage(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Santicchia'),
          backgroundColor: Colors.indigo[900],
          elevation: 10,
          toolbarHeight: 80,
        ),
      ),
    );
  }
}


// ignore: camel_case_types
class _handlerPage extends ChangeNotifier {
  int _paginaActual = 0;

  int get paginaActual => _paginaActual;

  set paginaActual(int value) {
    _paginaActual = value;
    notifyListeners();
  }
}
