class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'error',
      status: json['status'] as String? ?? 'error',
      species: json['species'] as String? ?? 'error',
      image: json['image'] as String? ?? 'error',
    );
  }
}
