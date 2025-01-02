import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final key = encrypt.Key.fromLength(32);
  final _iv = encrypt.IV.fromLength(16);
  final _encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));

  String _encrypt(String text) {
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  Future<void> login() async {
    try {
      String encryptedEmail = _encrypt(_usernameController.text);
      String encryptedPassword = _encrypt(_passwordController.text);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where('correo', isEqualTo: encryptedEmail)
          .where('password', isEqualTo: encryptedPassword)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_login', DateTime.now().toIso8601String());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
      }
    } catch (e) {
      print('ERROR......$e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ha ocurrido un error. Inténtelo de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo de la app
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('lib/imagenes/michify.jpeg'),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(height: 20),

              // Campo de "Correo"
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Campo de "Contraseña"
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botón de "Ingresar"
              ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Ingresar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'Registro');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Registrar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
