import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/screens/card_screen.dart';
import 'package:flutter_guide_2024/screens/form_screen.dart';
import 'package:flutter_guide_2024/screens/listview_builder_screen.dart';
import 'package:provider/provider.dart';

class BottomNavigationProvider extends StatelessWidget {
  BottomNavigationProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _handlerPage(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Montecino'),
          backgroundColor: Colors.indigo[900],
          elevation: 10,
          toolbarHeight: 80,
        ),
        bottomNavigationBar: ElementsButtonProvider(),
        body: const ElementsBodyProvider(),
      ),
    );
  }
}

class ElementsButtonProvider extends StatelessWidget {
  ElementsButtonProvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<_handlerPage>(context, listen: true);

    return BottomNavigationBar(
      currentIndex: page.paginaActual,
      elevation: 10,
      unselectedItemColor: Colors.grey,
      onTap: (value) {
        print('value: $value');
        page.paginaActual = value;
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list), // Icono para "Lista registros"
          label: 'Lista registros',
          activeIcon: Icon(Icons.list_alt,
              color: Colors.indigo), // Icono activo para "Lista registros"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article), // Icono para "Individual"
          label: 'Individual',
          activeIcon: Icon(Icons.article_outlined,
              color: Colors.indigo), // Icono activo para "Individual"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.create), // Icono para "Formulario"
          label: 'Formulario',
          activeIcon: Icon(Icons.edit,
              color: Colors.indigo), // Icono activo para "Formulario"
          tooltip: 'Boton 3',
        ),
      ],
    );
  }
}

class ElementsBodyProvider extends StatelessWidget {
  const ElementsBodyProvider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = Provider.of<_handlerPage>(context, listen: true);

    // Mostrar diferentes widgets en función del índice seleccionado
    switch (page.paginaActual) {
      case 0:
        return const ListViewBuilderScreen(); // Mostrar lista en la primera pantalla
      case 1:
        return CardScreen(
            url:
                'https://images.unsplash.com/photo-1444927714506-8492d94b4e3d?q=80&w=1476&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            title: 'titulo de prueba ',
            body:
                'Incididunt reprehenderit non ullamco deserunt laborum adipisicing elit. Irure est consectetur eu non dolor nisi deserunt id ipsum commodo ex in. Sunt sit non dolor aliquip ullamco do velit proident magna esse commodo eiusmod duis labore. Elit eu enim laboris elit aute labore et deserunt sint irure aliquip. Commodo ut velit elit incididunt.');
      case 2:
        return const FormScreen();
      default:
        return const Center(child: Text('Ninguna Solapa'));
    }
  }
}

class _handlerPage extends ChangeNotifier {
  int _paginaActual = 0;

  int get paginaActual => _paginaActual;

  set paginaActual(int value) {
    _paginaActual = value;
    notifyListeners();
  }
}
