import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import '''
package:pdf/widgets.dart''' as pw;
import 'package:printing/printing.dart';

class PDFHelper {
  static Future<void> createAndSavePDF(BuildContext context) async {
    final pdf = pw.Document();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Obtener los datos de Firestore
    final snapshot = await firestore
        .collection('Gastos')
        .orderBy('fecha', descending: true)
        .get();
    final gastos = snapshot.docs;

    // Crear el PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Estado de Cuenta Mensual',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              ...gastos.map((doc) {
                var data = doc.data();
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Nombre: ${data['nombre']}'),
                    pw.Text('Monto: \$${data['monto'].toStringAsFixed(2)}'),
                    pw.Text('Fecha: ${data['fecha'].toDate()}'),
                    pw.SizedBox(height: 10),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );

    // Guardar o imprimir el PDF
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'estado_de_cuenta_mensual.pdf');
  }
}