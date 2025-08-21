import 'character.dart';

class PaginatedCharacters {
  final List<Character> characters;
  final int page;
  final int totalPages;
  final bool hasNextPage;

  const PaginatedCharacters({
    required this.characters,
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
  });

  factory PaginatedCharacters.fromJson(
    Map<String, dynamic> json, {
    required int page,
  }) {
    final info = (json['info'] as Map<String, dynamic>?) ?? const {};
    final results = (json['results'] as List<dynamic>? ?? [])
        .map((item) => Character.fromJson(item as Map<String, dynamic>))
        .toList();

    final totalPages = (info['pages'] as int?) ?? 1;
    final hasNextPage = info['next'] != null;

    return PaginatedCharacters(
      characters: results,
      page: page,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
    );
  }
}
