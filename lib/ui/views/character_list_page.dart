import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_desafio_fteam/ui/views/character_detail_page.dart';
import 'package:flutter_desafio_fteam/ui/widgets/character_card.dart';
import 'package:flutter_desafio_fteam/ui/viewmodels/characters_view_model.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CharactersView();
  }
}

class _CharactersView extends StatefulWidget {
  const _CharactersView();

  @override
  State<_CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<_CharactersView> {
  bool _onScrollEnd(ScrollNotification n, CharactersViewModel vm) {
    if (n.metrics.pixels >= n.metrics.maxScrollExtent * 0.9) {
      vm.loadMore();
    }
    return false;
  }

  static const double _maxCardWidth = 220;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CharactersViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Personagens')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: vm.refresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) => _onScrollEnd(n, vm),
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                if (vm.error != null && vm.characters.isEmpty) {
                  return ListView(
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.3),
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 12),
                      Center(child: Text('Erro: ${vm.error}')),
                      const SizedBox(height: 12),
                      Center(
                        child: FilledButton(
                          onPressed: vm.loadInitial,
                          child: const Text('Tentar novamente'),
                        ),
                      ),
                    ],
                  );
                }

                if (vm.isLoading && vm.characters.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: constraints.maxWidth >= 900,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: _maxCardWidth,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: vm.characters.length,
                          itemBuilder: (_, i) {
                            final c = vm.characters[i];
                            return CharacterCard(
                              character: c,
                              onTap: () => Navigator.pushNamed(
                                context,
                                CharacterDetailPage.routeName,
                                arguments: c,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (vm.isLoading && vm.characters.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: CircularProgressIndicator(),
                      ),
                    if (!vm.hasMore && vm.characters.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Fim'),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
