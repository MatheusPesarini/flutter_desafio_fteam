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

  Future<PaginatedCharacters> getCharacters({
    int page = 1,
    String? name,
    String? status,
    String? species,
  }) async {
    final params = <String, String>{
      'page': '$page',
      if (name != null && name.isNotEmpty) 'name': name,
      if (status != null && status.isNotEmpty) 'status': status,
      if (species != null && species.isNotEmpty) 'species': species,
    };

    final characterUrl = Uri.parse(
      '$baseUrl/character',
    ).replace(queryParameters: params);
    final response = await httpClient.get(characterUrl);

    if (response.statusCode == 404) {
      return const PaginatedCharacters(
        characters: [],
        page: 1,
        totalPages: 1,
        hasNextPage: false,
      );
    }

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar personagens: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PaginatedCharacters.fromJson(json, page: page);
  }
}
