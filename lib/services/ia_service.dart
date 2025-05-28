import 'dart:convert';
import 'package:http/http.dart' as http;

class IaService {
  static const String baseUrl = 'https://saudabahia-api.onrender.com';

  static Future<List<String>> obterSugestoesRefeicoes(double imc) async {
    final url = Uri.parse('$baseUrl/sugestoes-refeicoes');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'imc': imc}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> sugestoes = data['sugestoes'];
      // Converte dinamicos para string
      return sugestoes.map((s) => s.toString()).toList();
    } else {
      throw Exception('Falha ao obter sugestões da IA');
    }
  }
}
