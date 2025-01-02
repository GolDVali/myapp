import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/agregar_gasto.dart' as agregar;
import 'package:myapp/extra.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/pdf_helper.dart'; // Importa correctamente

class GastosChart extends StatefulWidget {
  const GastosChart({super.key});

  @override
  _GastosChartState createState() => _GastosChartState();
}

class _GastosChartState extends State<GastosChart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Asegúrate de que esté definido aquí

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const IconosInferiores(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Gastos').orderBy('fecha', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var gastos = snapshot.data!.docs;
          Map<String, double> dataMap = {};

          for (var doc in gastos) {
            var data = doc.data() as Map<String, dynamic>;
            String categoria = data['categoria'] ?? 'Sin categoría';
            double monto = data['monto'] ?? 0.0;

            if (dataMap.containsKey(categoria)) {
              dataMap[categoria] = dataMap[categoria]! + monto;
            } else {
              dataMap[categoria] = monto;
            }
          }

          return Column(
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
                    sections: dataMap.entries.map((entry) {
                      return PieChartSectionData(
                        color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
                        value: entry.value,
                        title: '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
                        radius: 50,
                        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await PDFHelper.createAndSavePDF(context); // Asegúrate de llamar correctamente a PDFHelper
                },
                child: const Text('Descargar Estado de Cuenta'),
              ),
            ],
          );
        },
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
                MaterialPageRoute(builder: (context) => HomeScreen()),
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