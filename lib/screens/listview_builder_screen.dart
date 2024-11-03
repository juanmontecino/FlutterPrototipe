import 'dart:developer';

import 'package:flutter/material.dart';

class ListViewBuilderScreen extends StatelessWidget {
  const ListViewBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            log('posicion $index');
            return ListTile(
              leading: const Icon(Icons.check_box,
                  color: Color.fromARGB(255, 251, 192, 45)),
              title: Text('Elemento nro $index'),
              subtitle: const Text('Subtitulo de la lista'),
              trailing: const Icon(Icons.people,
                  color: Color.fromARGB(255, 251, 192, 45)),
            );
          },
        ),
      ),
    );
  }
}
