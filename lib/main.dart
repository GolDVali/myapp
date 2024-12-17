import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/agregar_gasto.dart';
import 'package:myapp/registro.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/extra.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _Myappstate createState() => _Myappstate();
}

class _Myappstate extends State<MyApp> {
  final bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de gastos',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      routes: {
        '/': (BuildContext context) {
          if (_loggedIn) {
            return  HomeScreen();
          } else {
            return  HomeScreen();
          }
        },
        'Extra': (BuildContext context) =>  const OpcionesInterfaz(),
        'Agregar': (BuildContext context) =>  AgregarGasto(),
        'Registro': (BuildContext context) => const RegistrationForm(),
      },
    );
  }
}
