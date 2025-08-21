import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_desafio_fteam/data/models/paginated_characters.dart';

class ApiClient {
  final http.Client httpClient;
  final String baseUrl;

  ApiClient(
    this.httpClient, {
    this.baseUrl = 'https://rickandmortyapi.com/api',
  });

  Future<PaginatedCharacters> getCharacters({int page = 1}) async {
    final characterUrl = Uri.parse('$baseUrl/character?page=$page');
    final response = await httpClient.get(characterUrl);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar personagens: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PaginatedCharacters.fromJson(json, page: page);
  }
}
