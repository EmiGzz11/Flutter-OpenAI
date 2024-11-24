import 'package:http/http.dart' as http;
import 'api_key.dart';
import 'chat_request_model.dart';
import 'chat_response.dart';

class ChatService {
  static final Uri chatUri =
      Uri.parse('https://api.openai.com/v1/chat/completions');

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIApiKey}'
  };

  Future<String?> request(String prompt) async {
    String? instruccion;
    instruccion =
        "Eres un entrenador personal. Genera una rutina de un día con máximo 5 ejercicios en este formato exacto: Descripción del ejercicio, series, repeticiones y tiempo. No incluyas detalles adicionales.";
    try {
      if (prompt.isEmpty) {
        print("El prompt está vacío");
        return null;
      }

      ChatRequest request = ChatRequest(
        model: "gpt-3.5-turbo",
        temperature: 0.7,
        maxTokens: 150,
        messages: [
          Message(role: "system", content: instruccion),
          Message(role: "user", content: prompt)
        ],
      );

      http.Response response =
          await http.post(chatUri, headers: headers, body: request.toJson());

      if (response.statusCode != 200) {
        print("Error en la solicitud: ${response.statusCode}");
        return null;
      }

      ChatResponse chatResponse = ChatResponse.fromResponse(response);

      String? content = chatResponse.choices?[0].message?.content;
      if (content == null) {
        print("La respuesta no contiene contenido válido");
        return null;
      }

      print(content);
      return content;
    } catch (e) {
      print("Error aquí: $e");
      return null;
    }
  }
}
