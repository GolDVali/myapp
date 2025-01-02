 import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/agregar_gasto.dart' as agregar;
import 'dart:math';
import 'package:myapp/home_screen.dart';
import 'package:myapp/extra.dart'; // Importa OpcionesInterfaz

class GastosChart extends StatefulWidget {
  const GastosChart({super.key});

  @override
  _GastosChartState createState() => _GastosChartState();
}

class _GastosChartState extends State<GastosChart> {
  final random = Random();
  
  final List<Map<String, dynamic>> gastos = [
    {"categoria": "Alimentación", "cantidad": 0.0},
    {"categoria": "Transporte", "cantidad": 0.0},
    {"categoria": "Entretenimiento", "cantidad": 0.0},
    {"categoria": "Educación", "cantidad": 0.0},
    {"categoria": "Otros", "cantidad": 0.0},
  ];

  @override
  void initState() {
    super.initState();
    _generarGastosAleatorios();
  }

  void _generarGastosAleatorios() {
    setState(() {
      for (var gasto in gastos) {
        gasto["cantidad"] = random.nextDouble() * 500; // Cantidad aleatoria hasta 500
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const IconosInferiores(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Distribución de Gastos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: PieChart(
              PieChartData(
                sections: gastos.map((gasto) {
                  final double cantidad = gasto["cantidad"];
                  return PieChartSectionData(
                    color: Colors.primaries[random.nextInt(Colors.primaries.length)],
                    value: cantidad,
                    title: gasto["categoria"],
                    radius: 50,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _generarGastosAleatorios,
            child: const Text('Generar Nuevos Gastos'),
          ),
        ],
      ),
    );
  }
}

class IconosInferiores extends StatelessWidget {
  const IconosInferiores({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HomeScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  agregar.AgregarGastos()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GastosChart()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OpcionesInterfaz()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AgregarGasto extends StatelessWidget {
  const AgregarGasto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Gasto'),
      ),
      body: const Center(
        child: Text('Formulario para agregar un nuevo gasto'),
      ),
    );
  }
}