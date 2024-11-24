import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'dart:io';

import 'package:screenshot/screenshot.dart';


class RutinaPage extends StatelessWidget {
  final String? rutina;

  const RutinaPage({Key? key, required this.rutina}) : super(key: key);

  List<String> separarRutinaEnFilas(String? rutina) {
    return rutina?.split('\n') ?? [];
  }
  Future<void> generarPDF(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          List<String> filas = separarRutinaEnFilas(rutina);

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Tu rutina personalizada',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                  ' RECUERDA CALENTAR ANTES DE ENTRENAR',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)
              ),
              pw.SizedBox(height: 40),
              for (var linea in filas)
                pw.Text(
                  linea,
                  style: pw.TextStyle(fontSize: 14, ),
                ),

            ]
          );
        },
      ),
    );


    final outputDirectory = await getApplicationDocumentsDirectory();
    final outputFile = File('${outputDirectory.path}/rutina.pdf');
    await outputFile.writeAsBytes(await pdf.save());


    // Verificar si el archivo PDF existe
    bool fileExists = await outputFile.exists();

    if (fileExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rutina guardada exitosamente como PDF')),
      );
      await OpenFile.open(outputFile.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hubo un error al guardar el PDF')),
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    List<String> filas = rutina?.split('\n') ?? [];
    final ScreenshotController screenshotController = ScreenshotController();


    return Scaffold(
        body: Screenshot(
          controller: screenshotController,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    textAlign: TextAlign.center,
                    "Tu rutina personalizada 🔥",
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: rutina!= null && rutina!.isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: filas.map((fila) {
                          return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              fila.trim(),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ) ,
                          );
                        }).toList(),
                      ) : Text(
                        rutina ??
                            'Ingresa tus datos correctamente para recibir una rutina personalizada',
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => generarPDF(context),
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                            horizontal: 120, vertical: 20)),
                        backgroundColor: WidgetStateProperty.all(Colors.red)),
                    child: const Text("Guardar rutina como PDF",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800),),

                  ),
                  const SizedBox(height: 220,),

                ],
              ),
            ),
          ),
        )
    );


  }
}
