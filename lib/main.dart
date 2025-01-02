import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/agregar_gasto.dart';
import 'package:myapp/registro.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/extra.dart';
import 'package:myapp/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Widget> _initialScreen;

  @override
  void initState() {
    super.initState();
    _initialScreen = _checkLoginStatus();
  }

  Future<Widget> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastLogin = prefs.getString('last_login');
    if (lastLogin != null) {
      DateTime lastLoginDate = DateTime.parse(lastLogin);
      if (DateTime.now().difference(lastLoginDate).inDays < 3) {
        return HomeScreen();
      }
    }
    return const Login();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialScreen,
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'App de gastos',
            theme: ThemeData(primarySwatch: Colors.lightBlue),
            routes: {
              '/': (BuildContext context) => snapshot.data ?? const Login(),
              'Extra': (BuildContext context) => OpcionesInterfaz(),
              'Home': (BuildContext context) => HomeScreen(),
              'Registro': (BuildContext context) => const RegistrationForm(),
              'Agregar': (BuildContext context) => AgregarGasto(),
            },
          );
        } else {
          return const CircularProgressIndicator(); // Mostrar indicador de carga mientras se resuelve Future
        }
      },
    );
  }
}
