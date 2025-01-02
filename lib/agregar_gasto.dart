import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/extra.dart';
import 'package:myapp/graph.dart';
import 'package:myapp/home_screen.dart';


class AgregarGastos extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AgregarGastos({super.key});

  void _addExpense(String id, String name, double amount) async {
    try {
      await _firestore.collection('Gastos').doc().set({
        'nombre': name,
        'monto': amount,
        'fecha': FieldValue.serverTimestamp(),
      });
      print('Gasto añadido con éxito');
    } catch (e) {
      print('Error al añadir gasto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Gasto'),
      ),
      bottomNavigationBar: const IconosInferiores(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String id =
                    'gasto_${DateTime.now().millisecondsSinceEpoch}'; // Puedes modificar esto para usar el ID que desees
                final String name = _nameController.text;
                final double? amount = double.tryParse(_amountController.text);

                if (name.isNotEmpty && amount != null && amount > 0) {
                  _addExpense(id, name, amount);
                } else {
                  print('Por favor, ingresa un nombre y un monto válido');
                }
              },
              child: const Text('Agregar Gasto'),
            ),
          ],
        ),
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
                MaterialPageRoute(builder: (context) => AgregarGastos()),
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