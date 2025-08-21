import 'package:flutter_desafio_fteam/core/api/api_client.dart';
import 'package:flutter_desafio_fteam/data/models/paginated_characters.dart';

class CharacterRepository {
  final ApiClient _api;
  CharacterRepository(this._api);

  Future<PaginatedCharacters> fetchCharacters({int page = 1}) {
    return _api.getCharacters(page: page);
  }
}
