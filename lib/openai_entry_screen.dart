import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_ai/rutinaPage.dart';
import 'package:open_ai/services/openai/chat_service.dart';

class OpenaiEntryScreen extends StatefulWidget {
  const OpenaiEntryScreen({super.key});

  @override
  State<OpenaiEntryScreen> createState() => _OpenAIEntryScreenState();
}

class _OpenAIEntryScreenState extends State<OpenaiEntryScreen> {
  TextEditingController edadController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController musculoController = TextEditingController();
  TextEditingController nivelController = TextEditingController();

  String? response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150,),
            Stack(
              children: [
                Image.asset(
                  'assets/banner.png',
                  width: 500,
                  height: 170,
                  fit: BoxFit.cover,
                ),


                Positioned(
                  left: 0, // Ajusta la posición horizontal de la caja (puedes cambiarlo)
                  right: 0, // Ajusta la posición horizontal de la caja (puedes cambiarlo)
                  bottom: 0, // Ajusta la posición vertical de la caja
                  child: Container(
                    height: 500,
                    color: Color(0x80000000), // Color negro semi-transparente (80% opaco)
                  ),
                ),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Ingresa tus datos para recibir una rutina personalizada",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: edadController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: "Edad 🏃‍♂️",
                  hintText: "Ingresa tu edad",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Poppins'),
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: pesoController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: "Peso (kg) ⚖️",
                  hintText: "Ingresa tu peso",
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Poppins'),
                ),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField<String>(
                  value: null,
                  items: <String>[
                    'Biceps',
                    'Triceps',
                    'Pectorales',
                    'Espalda',
                    'Piernas',
                    'Hombros'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    musculoController.text = newValue ?? '';
                  },
                  decoration: const InputDecoration(
                      labelText: "Musculo 💪",
                      hintText: "Selecciona el musculo que deseas entrenar hoy",
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Poppins')),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField<String>(
                  value: null,
                  items: <String>['Basico', 'Intermedio', 'Avanzado']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    nivelController.text = newValue ?? '';
                  },
                  decoration: const InputDecoration(
                    labelText: "Nivel 🏋️",
                    hintText: "Selecciona tu nivel en el gym",
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Poppins'),
                  ),
                  style:
                  const TextStyle(fontFamily: 'Poppins', color: Colors.black),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(
                      horizontal: 120, vertical: 20)),
                      backgroundColor: WidgetStateProperty.all(Colors.red)),
                  onPressed: () async {
                    response = await ChatService().request(
                        "Edad:${edadController.text}, Peso: ${pesoController.text} kg, Musculo: ${musculoController.text}, Nivel: ${nivelController.text}. Genera una rutina de un dia");

                    Navigator.push(context, MaterialPageRoute(builder: (context) => RutinaPage(rutina: response)));

                  },
                  child: const Text("Enviar Datos",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800),
                  ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
