import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/login.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  RegistrationFormState createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  bool _termsAccepted = false;

  final TextEditingController _Nombrecontroller = TextEditingController();
  final TextEditingController _correocontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _telefonocontroller = TextEditingController();
  final TextEditingController _limitecontroller = TextEditingController();
  final firebase = FirebaseFirestore.instance;

  final key = encrypt.Key.fromLength(32);
  final _iv = encrypt.IV.fromLength(16);
  final _encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));

  String CorreoEncriptado = "";
  String ContrasenaEncriptado = "";
  String TelefonoEncriptado = "";

  void _encryptCorreo() {
    final text = _correocontroller.text;
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    CorreoEncriptado = encrypted.base64;
  }

  void _encryptContrasena() {
    final text = _passwordcontroller.text;
    final encrypted = _encrypter.encrypt(text, iv: _iv);

    ContrasenaEncriptado = encrypted.base64;
  }

  void _encryptTelefono() {
    final text = _telefonocontroller.text;
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    TelefonoEncriptado = encrypted.base64;
  }

  Future<void> registrousuario() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _correocontroller.text,
        password: _passwordcontroller.text,
      );
      _encryptCorreo();
      _encryptContrasena();
      _encryptTelefono();
      await firebase.collection('Usuarios').doc().set({
        'nombre': _Nombrecontroller.text,
        'correo': CorreoEncriptado,
        'password': ContrasenaEncriptado,
        'telefono': TelefonoEncriptado,
        'limite': _limitecontroller.text,
      });
    } catch (e) {
      print('ERROR......$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage('lib/imagenes/michify.jpeg'),
              height: 100,
              key: Key('logo'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _Nombrecontroller,
              key: const Key('nombre'),
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _correocontroller,
              key: const Key('correo'),
              decoration: const InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordcontroller,
              key: const Key('contrasena'),
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _telefonocontroller,
              key: const Key('Telefono'),
              decoration: const InputDecoration(
                labelText: 'Telefono',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _limitecontroller,
              key: const Key('Limite de gasto inicial'),
              decoration: const InputDecoration(
                labelText: 'Limite gasto inicial',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 15),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _termsAccepted = value ?? true;
                    });
                  },
                  key: const Key('terminos'),
                ),
                const Text('Aceptar términos y condiciones'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('ingresarButton'),
              onPressed: _termsAccepted
                  ? () {
                      registrousuario();
                      print('Enviando...');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    }
                  : null,
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}
