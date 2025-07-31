/*
 *  Contact : Elowan - elowarp@gmail.com
 *  Creation : 24-07-2025 22:03:32
 *  Last modified : 31-07-2025 18:24:10
 *  File : GamePage.dart
 */

import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../data/repositories/game_repository.dart';

// Top, right, bottom, left
typedef Walls = (bool, bool, bool, bool);

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    required GameRepository gameRepository,
  }) :
    _gameRepository = gameRepository;

  final GameRepository _gameRepository;

  List<List> _grid = [];
  List<Robot> _robots = [];
  
  /// Renvoie les tailles du plateau
  int get gridWidth => _gameRepository.width;
  int get gridHeight => _gameRepository.height;

  /// Renvoie la matrice de jeu non modifable 
  UnmodifiableListView<UnmodifiableListView> get grid => 
    UnmodifiableListView(
      List<UnmodifiableListView>.generate(_grid.length, (int i) => UnmodifiableListView(_grid[i]))
    );

  /// Renvoie la liste de robots non modifable 
  UnmodifiableListView<Robot> get robots =>
    UnmodifiableListView(_robots);

  /// Renvoie le type de la case
  int getCase({int x=-1, int y=-1}){
    return _grid[x][y];
  }

  /// Renvoie un type Walls représentant si un mur est présent autour 
  /// de la case (top, right, bottom, left) en comptant les bords du 
  /// terrain 
  Walls getWalls({int x=-1, int y=-1}) {
    return (
      y-1<0 || _grid[x][y-1] == 2 || _grid[x][y-1] == 3, // Top
      x+1>=gridWidth || _grid[x][y] == 1 || _grid[x][y] == 3, // Right
      y+1>=gridHeight || _grid[x][y] == 2 || _grid[x][y] == 3, // Bottom
      x-1<0 || _grid[x-1][y] == 1 || _grid[x-1][y] == 3 // Left
    );
  }

  /// Initialise le jeu 
  void loadGame() {
    _gameRepository.initGrid();
    _gameRepository.initRobot();
    _grid = _gameRepository.grid;
    _robots = _gameRepository.robots;

  }
}