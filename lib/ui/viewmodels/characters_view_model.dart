import 'package:flutter/foundation.dart';
import 'package:flutter_desafio_fteam/data/models/character.dart';
import 'package:flutter_desafio_fteam/data/repositories/character_repository.dart';

class CharactersViewModel extends ChangeNotifier {
  final CharacterRepository _repo;

  CharactersViewModel(this._repo);

  final List<Character> _characters = [];
  List<Character> get characters => List.unmodifiable(_characters);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int _page = 1;
  int _totalPages = 1;
  bool get hasMore => _page < _totalPages;

  String _query = '';
  String? _status; 
  String get query => _query;
  String? get status => _status;

  Future<void> loadInitial() async {
    if (_isLoading) return;
    _characters.clear();
    _page = 1;
    _totalPages = 1;
    _error = null;
    notifyListeners();
    await _loadPage();
  }

  Future<void> loadMore() async {
    if (_isLoading || !hasMore) return;
    _page += 1;
    await _loadPage(append: true);
  }

  Future<void> refresh() async => loadInitial();

  void setQuery(String value) {
    final v = value.trim();
    if (_query == v) return;
    _query = v;
    loadInitial();
  }

  void setStatus(String? value) {
    if (_status == value) return;
    _status = value;
    loadInitial();
  }

  Future<void> _loadPage({bool append = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _repo.fetchCharacters(
        page: _page,
        name: _query.isEmpty ? null : _query,
        status: _status,
      );
      _totalPages = result.totalPages;
      if (!append) {
        _characters
          ..clear()
          ..addAll(result.characters);
      } else {
        _characters.addAll(result.characters);
      }
    } catch (error) {
      _error = error.toString();
      if (append) _page -= 1;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
