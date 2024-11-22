import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/mocks/pokemon_mock.dart';
import 'package:flutter_guide_2024/utils/pokemon_colors_utils.dart';

class PokemonFormView extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonFormView({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonFormView> createState() => _PokemonFormViewState();
}

class _PokemonFormViewState extends State<PokemonFormView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isPokemonCaptured = false;
  bool _isShiny = false;

  @override
  Widget build(BuildContext context) {
    Color themeColor = PokemonColors.getColorForType(widget.pokemon.types.first.type.name);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notas del Entrenador - ${widget.pokemon.name}'),
        backgroundColor: themeColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPokemonImage(),
              SizedBox(height: 20),
              _buildCaptureSwitch(),
              _buildShinyCheckbox(),
              SizedBox(height: 20),
              _buildNicknameField(),
              SizedBox(height: 20),
              _buildNotesField(),
              SizedBox(height: 20),
              _buildSaveButton(themeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonImage() {
    return Center(
      child: Container(
        height: 150,
        child: Image.network(widget.pokemon.imageUrl),
      ),
    );
  }

  Widget _buildCaptureSwitch() {
    return SwitchListTile(
      title: Text('Capturado'),
      subtitle: Text('Selecciona si lo capturaste!'),
      value: _isPokemonCaptured,
      onChanged: (bool value) {
        setState(() {
          _isPokemonCaptured = value;
        });
      },
    );
  }

  Widget _buildShinyCheckbox() {
    return CheckboxListTile(
      title: Text('Versión Shiny'),
      subtitle: Text('Es su versión Shiny?'),
      value: _isShiny,
      onChanged: (bool? value) {
        setState(() {
          _isShiny = value ?? false;
        });
      },
    );
  }

  Widget _buildNicknameField() {
    return TextFormField(
      controller: _nicknameController,
      decoration: InputDecoration(
        labelText: 'Nickname',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.pets),
      ),
      validator: (value) {
        if (_isPokemonCaptured && (value == null || value.isEmpty)) {
          return 'Demosle un nombre al Pokemon!';
        }
        return null;
      },
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: InputDecoration(
        labelText: 'Notas del Entrenador:',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSaveButton(Color themeColor) {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(Icons.save),
        label: Text('Guardando notas'),
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notas guardadas!')),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}