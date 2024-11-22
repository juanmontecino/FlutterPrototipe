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
              _buildCaptureSwitch(themeColor),
              SizedBox(height: 10),
              _buildShinyCheckbox(themeColor),
              SizedBox(height: 20),
              _buildNicknameField(themeColor),
              SizedBox(height: 20),
              _buildNotesField(themeColor),
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

  Widget _buildCaptureSwitch(Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: themeColor,
          width: 2, 
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        title: Text('Capturado'),
        subtitle: Text('Selecciona si lo capturaste!'),
        value: _isPokemonCaptured,
        onChanged: (bool value) {
          setState(() {
            _isPokemonCaptured = value;
          });
        },
      ),
    );
  }


  Widget _buildShinyCheckbox(Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: themeColor,
          width: 2, 
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        title: Text('Versión Shiny'),
        subtitle: Text('Es su versión Shiny?'),
        value: _isShiny,
        onChanged: (bool? value) {
          setState(() {
            _isShiny = value ?? false;
          });
        },
      ),
    );
  }

Widget _buildNicknameField(Color themeColor) {
  return TextFormField(
    controller: _nicknameController,
    decoration: InputDecoration(
      labelText: 'Nickname',
      border: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor), 
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor),
      ),
      prefixIcon: Icon(
        Icons.drive_file_rename_outline,
        color: themeColor, 
      ),
      floatingLabelStyle: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white // Si el tema es oscuro, el texto será blanco
            : Colors.black, // Si el tema es claro, el texto será negro
      ),
    ),
    validator: (value) {
      if (_isPokemonCaptured && (value == null || value.isEmpty)) {
        return 'Demosle un nombre al Pokemon!';
      }
      return null;
    },
  );
}

Widget _buildNotesField(Color themeColor) {
  return TextFormField(
    controller: _notesController,
    decoration: InputDecoration(
      labelText: 'Notas del Entrenador:',
      border: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor), 
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor), 
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: themeColor), 
      ),
      prefixIcon: Icon(
        Icons.note,
        color: themeColor, 
      ),
      floatingLabelStyle: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white // Si el tema es oscuro, el texto será blanco
            : Colors.black, // Si el tema es claro, el texto será negro
      ),
    ),
    maxLines: 3,
  );
}


  Widget _buildSaveButton(Color themeColor) {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(Icons.save),
        label: Text('Guardar Notas'),
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