import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_desafio_fteam/data/models/character.dart';

class CharacterDetailPage extends StatelessWidget {
  static const routeName = '/detail';

  final Character character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Hero(
              tag: 'character_${character.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: Semantics(
                    label: 'Imagem de ${character.name}',
                    child: CachedNetworkImage(
                      imageUrl: character.image,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 200),
                      placeholder: (ctx, _) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (ctx, e, s) => const Center(
                        child: Icon(Icons.broken_image, size: 48),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              character.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: CircleAvatar(
                    radius: 6,
                    backgroundColor: _statusColor(character.status, color),
                  ),
                  label: Text('Status: ${character.status}'),
                  backgroundColor: color.surfaceContainerHighest,
                ),
                Chip(
                  label: Text('Espécie: ${character.species}'),
                  backgroundColor: color.surfaceContainerHighest,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status, ColorScheme scheme) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return scheme.error;
      default:
        return scheme.outline;
    }
  }
}
