/*
 *  Contact : Elowan - elowarp@gmail.com
 *  Creation : 24-07-2025 22:03:32
 *  Last modified : 24-07-2025 23:15:26
 *  File : GamePage.dart
 */

import 'dart:collection';

import 'package:flutter/material.dart';

import './game.dart';
import '../../../data/repositories/game_repository.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    required GameRepository gameRepository,
  }) :
    _gameRepository = gameRepository;

  final GameRepository _gameRepository;

  Game? _game;
  Game? get game => _game;  

  List<List> _grid = [];

  UnmodifiableListView<UnmodifiableListView> get grid => 
    UnmodifiableListView(
      List<UnmodifiableListView>.generate(_grid.length, (int i) => UnmodifiableListView(_grid[i]))
    );

  void loadGame() {
    _gameRepository.initGrid();
    _grid = _gameRepository.grid;
  }
}