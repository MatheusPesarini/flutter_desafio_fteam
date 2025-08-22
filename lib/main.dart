import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'core/api/api_client.dart';
import 'data/models/character.dart';
import 'data/repositories/character_repository.dart';
import 'ui/views/character_detail_page.dart';
import 'ui/views/character_list_page.dart';
import 'ui/viewmodels/characters_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),
        Provider<ApiClient>(
          create: (ctx) => ApiClient(ctx.read<http.Client>()),
        ),
        Provider<CharacterRepository>(
          create: (ctx) => CharacterRepository(ctx.read<ApiClient>()),
        ),
        ChangeNotifierProvider<CharactersViewModel>(
          create: (ctx) =>
              CharactersViewModel(ctx.read<CharacterRepository>())
                ..loadInitial(),
        ),
      ],
      child: MaterialApp(
        title: 'Rick and Morty',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            scrolledUnderElevation: 0,
          ),
          cardTheme: const CardThemeData(
            elevation: 1,
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
          ),
          chipTheme: const ChipThemeData(
            side: BorderSide(color: Colors.transparent),
          ),
        ),
        themeMode: ThemeMode.light,
        home: const CharactersPage(),
        onGenerateRoute: (settings) {
          if (settings.name == CharacterDetailPage.routeName) {
            final character = settings.arguments as Character;
            return MaterialPageRoute(
              builder: (_) => CharacterDetailPage(character: character),
            );
          }
          return null;
        },
      ),
    );
  }
}
