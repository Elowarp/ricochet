/*
 *  Contact : Elowan - elowarp@gmail.com
 *  Creation : 24-07-2025 22:03:32
 *  Last modified : 01-08-2025 12:32:52
 *  File : GamePage.dart
 */

import 'dart:collection';

import 'package:flutter/material.dart';

import '../../../data/repositories/game_repository.dart';

// Top, right, bottom, left
typedef Walls = (bool, bool, bool, bool);

class GameViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  var _selectedRobot = 0;

  GameViewModel({
    required GameRepository gameRepository,
  }) :
    _gameRepository = gameRepository;


  List<List<Case>> _grid = [];
  List<Robot> _robots = [];
  
  /// Renvoie les tailles du plateau
  int get gridWidth => _gameRepository.width;
  int get gridHeight => _gameRepository.height;

  // Selectionne un nouveau robot
  set selectedRobot (int i) {_selectedRobot = i; notifyListeners();}
  int get selectedRobot => _selectedRobot;

  /// Renvoie la matrice de jeu non modifable 
  UnmodifiableListView<UnmodifiableListView<Case>> get grid => 
    UnmodifiableListView(
      List<UnmodifiableListView<Case>>.generate(_grid.length, (int i) => UnmodifiableListView(_grid[i]))
    );

  /// Renvoie la liste de robots non modifable 
  UnmodifiableListView<Robot> get robots =>
    UnmodifiableListView(_robots);

  /// Renvoie le type de la case
  int getCaseType({int x=-1, int y=-1}){
    return _grid[x][y].type;
  }

  /// Renvoie un type Walls représentant si un mur est présent autour 
  /// de la case (top, right, bottom, left) en comptant les bords du 
  /// terrain 
  Walls getWalls({int x=-1, int y=-1}) {
    return (
      y-1<0 || _grid[x][y-1].hasBottomWall, // Top
      x+1>=gridWidth || _grid[x][y].hasRightWall, // Right
      y+1>=gridHeight || _grid[x][y].hasBottomWall, // Bottom
      x-1<0 || _grid[x-1][y].hasRightWall // Left
    );
  }

  /// Initialise le jeu 
  void loadGame() {
    _gameRepository.initGame();
    _grid = _gameRepository.grid;
    _robots = _gameRepository.robots;

  }

  /// Teste si un robot autre que id est sur la case (x,y)
  bool _isAnotherRobotOnCase({int id = -1, int x = -1, int y = -1}) {
    for (var i=0; i<_robots.length; i++){
      if (_robots[i].x == x && _robots[i].y == y && id != i) {
        return true;
      }
    }

    return false;
  }

  /// Trouve la case sur laquelle le robot d'identifiant id va arriver en 
  /// allant dans la direction dir et ne pouvant s'arrêter que contre un mur 
  /// ou un autre robot
  (int, int) _getNextCase({int id = -1, String dir = "none"}) {
    var robot = _robots[id];

    switch (dir) {
      case "up": 
        for (var y=robot.y; y>0; y--) {
          var (t, _, _, _) = getWalls(x: robot.x, y:y);
          if (t || _isAnotherRobotOnCase(id: id, x: robot.x, y:y-1)) {return (robot.x,y);}
        }

        return (robot.x, 0);

      case "right": 
        for (var x=robot.x; x<gridWidth-1; x++) {
          var (_, r, _, _) = getWalls(x: x, y: robot.y);
          if (r || _isAnotherRobotOnCase(id: id, x: x+1, y:robot.y)) {return (x, robot.y);}
        }

        return (gridWidth-1, robot.y);

      case "down": 
        for (var y=robot.y; y<gridHeight-1; y++) {
          var (_, _, b, _) = getWalls(x: robot.x, y:y);
          if (b || _isAnotherRobotOnCase(id: id, x: robot.x, y:y+1)) {return (robot.x,y);}
        }

        return (robot.x, gridHeight-1);

      case "left": 
        for (var x=robot.x; x>0; x--) {
          var (_, _, _, l) = getWalls(x: x, y: robot.y);
          if (l || _isAnotherRobotOnCase(id: id, x: x-1, y:robot.y)) {return (x, robot.y);}
        }

        return (0, robot.y);

      default:
        return (-1, -1);
    }
  }

  /// Déplace le robot en mémoire selon son déplacement en ligne droite
  void moveRobot({String dir = "none"}) {
    var robot = _robots[_selectedRobot];
    final (x, y) = _getNextCase(id: _selectedRobot, dir: dir);
    robot.x = x;
    robot.y = y;

    notifyListeners();
  }
}