import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKey {
  static String get openAIApiKey => dotenv.env['API_KEY'] ?? 'default_value';
}
