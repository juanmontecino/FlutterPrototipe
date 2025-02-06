import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/helpers/preferences.dart';
import 'package:flutter_guide_2024/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Perfil de usuario'),
        elevation: 10,
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderProfile(size: size),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: BodyProfile(),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyProfile extends StatelessWidget {
  bool darkMode = false;

  BodyProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final temaProvider = Provider.of<ThemeProvider>(context, listen: false);
    print(Preferences.darkmode);
    return Column(
      children: [
        SwitchListTile.adaptive(
          title: const Text('Dark Mode'),
          value: Preferences.darkmode,
          onChanged: (bool value) {
            Preferences.darkmode = value;
            value ? temaProvider.setDark() : temaProvider.setLight();
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
            onChanged: (value) {
              Preferences.telefono = value;
            },
            style: TextStyle(fontSize: 18),
            initialValue: Preferences.telefono,
            keyboardType: TextInputType.phone,
            decoration: decorationInput(
                label: 'Telefono',
                icon: Icons.phone,
                helperText: 'Ingresar número sin 0 ni 15')),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
            onChanged: (value) {
              Preferences.email = value;
            },
            style: TextStyle(fontSize: 18),
            initialValue: Preferences.email,
            keyboardType: TextInputType.emailAddress,
            decoration: decorationInput(
                label: 'Email', icon: Icons.alternate_email_outlined)),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
            onChanged: (value) {
              Preferences.apellido = value;
            },
            style: TextStyle(fontSize: 18),
            initialValue: Preferences.apellido,
            keyboardType: TextInputType.text,
            decoration: decorationInput(label: 'Apellido')),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
            onChanged: (value) {
              Preferences.nombre = value;
            },
            style: TextStyle(fontSize: 18),
            initialValue: Preferences.nombre,
            keyboardType: TextInputType.text,
            decoration: decorationInput(label: 'Nombre'))
      ],
    );
  }

  InputDecoration decorationInput(
      {IconData? icon, String? hintText, String? helperText, String? label}) {
    return InputDecoration(
      fillColor: Colors.black,
      label: Text(label ?? '', style: const TextStyle(color: Colors.indigo)),
      hintText: hintText,
      helperText: helperText,
      helperStyle: const TextStyle(fontSize: 16),
      prefixIcon: (icon != null) ? Icon(icon) : null,
         border: const UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.indigo)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.indigo)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.indigo))
    );
  }
}

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size.height * 0.40,
      color: const Color(0xff2d3e4f),
      child: Center(
        child: CircleAvatar(
          radius: 100,
          // child: Image.network('https://cdn2.iconfinder.com/data/icons/flat-style-svg-icons-part-1/512/user_man_male_profile_account-512.png'),
          // child: Icon(Icons.supervised_user_circle_sharp, size: 200,)
          child: Image.asset('assets/images/avatar.png'),
        ),
      ),
    );
  }
}
