import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_desafio_fteam/ui/views/character_detail_page.dart';
import 'package:flutter_desafio_fteam/ui/widgets/character_card.dart';
import 'package:flutter_desafio_fteam/ui/viewmodels/characters_view_model.dart';
import 'dart:async';

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

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CharactersViewModel>();

    return Scaffold(
      appBar: AppBar(toolbarHeight: 48, title: const Text('Personagens')),
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

                if (!vm.isLoading && vm.characters.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.all(12),
                    children: const [
                      _FiltersBar(),
                      SizedBox(height: 48),
                      Center(child: Text('Nenhum resultado')),
                    ],
                  );
                }

                return Column(
                  children: [
                    const _FiltersBar(),
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

class _FiltersBar extends StatefulWidget {
  const _FiltersBar();

  @override
  State<_FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<_FiltersBar> {
  Timer? _debounce;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final vm = context.read<CharactersViewModel>();
    _controller = TextEditingController(text: vm.query);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CharactersViewModel>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  labelText: 'Buscar por nome',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: vm.query.isNotEmpty
                      ? IconButton(
                          tooltip: 'Limpar',
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            vm.setQuery('');
                          },
                        )
                      : null,
                ),
                onChanged: (text) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 400), () {
                    vm.setQuery(text);
                  });
                },
                textInputAction: TextInputAction.search,
                onSubmitted: vm.setQuery,
              ),
            ),
          ),
          const SizedBox(width: 12),
          DropdownButton<String?>(
            value: vm.status,
            hint: const Text('Status'),
            onChanged: vm.setStatus,
            items: const [
              DropdownMenuItem(value: null, child: Text('Todos')),
              DropdownMenuItem(value: 'alive', child: Text('Vivos')),
              DropdownMenuItem(value: 'dead', child: Text('Mortos')),
              DropdownMenuItem(value: 'unknown', child: Text('Desconhecido')),
            ],
          ),
        ],
      ),
    );
  }
}
