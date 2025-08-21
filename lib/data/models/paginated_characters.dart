import 'character.dart';

class PaginatedCharacters {
  final List<Character> characters;
  final int page;
  final int totalPages;

  const PaginatedCharacters({
    required this.characters,
    required this.page,
    required this.totalPages,
  });

  
}
