import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _MyFormScreenState createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController();
  bool _isSwitchOn = false;
  bool _isChecked = false;
  String _imagePath =
      'https://images.unsplash.com/photo-1444927714506-8492d94b4e3d?q=80&w=1476&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'; // URL de la imagen principal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de texto
              TextFormField(
                controller: _textFieldController,
                decoration: const InputDecoration(
                  label: Text("Nombre", style: TextStyle(color: Colors.indigo)),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.indigo)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.indigo)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.indigo)),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.indigo)),
                  focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.indigo)),
                  errorStyle: TextStyle(
                      color: Colors.indigo), // Color del mensaje de error
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Activar opción'),
                  Switch(
                    value: _isSwitchOn,
                    activeColor: Colors.indigo, // Color del interruptor
                    activeTrackColor: Colors.indigo[200], // Color de la pista
                    onChanged: (value) {
                      setState(() {
                        _isSwitchOn = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isChecked,
                    activeColor: Colors.indigo, // Color del checkbox
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                  const Text('Acepto los términos y condiciones'),
                ],
              ),
              const SizedBox(height: 20),

              // Imagen principal
              Center(
                child: Image.network(
                  _imagePath,
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),

              // Botón de enviar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo, // Color de fondo índigo
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Procesando datos...')),
                    );
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
