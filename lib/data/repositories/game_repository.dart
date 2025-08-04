/*
 *  Contact : Elowan - elowarp@gmail.com
 *  Creation : 24-07-2025 22:04:46
 *  Last modified : 01-08-2025 12:35:05
 *  File : game_repository.dart
 */

import 'dart:math';

class Robot {
  var id = -1;
  var x = -1;
  var y = -1;

  Robot({
    required this.id,
    required this.x,
    required this.y,
  });

  @override
  String toString() {
    return '{id: $id, x: $x, y: $y}';
  }
}

class Case {
  final int type;
  final int x;
  final int y;
  final bool hasRightWall;
  final bool hasBottomWall;

  Case({
    required this.type,
    required this.x,
    required this.y,
    required this.hasRightWall,
    required this.hasBottomWall,
  });
}

class GameRepository {
  final int width;
  final int height;
  final int nbRobots;

  GameRepository({
    required this.width,
    required this.height,
    required this.nbRobots,
  });

  List<List<Case>> _grid = [];
  List<Robot> _robots = [];

  List<List<Case>> get grid => _grid;
  List<Robot> get robots => _robots;

  /// Renvoie la case qui sera en (x,y) sachant que la list types contient
  /// l'ensemble des cases spéciales à ajouter
  /// types = [{int x, int y, int type}]
  Case _chooseCase({int x = -1, int y = -1, List types = const []}) {
    var caseType = 0;
    var hasRightWall = false;
    var hasBottomWall = false;

    // Regarde si le type de la case a déjà été choisi
    for (var type in types) {
      if (type.x == x && type.y == y) {
        caseType = type.type;
      }
    }

    // Choix des murs
    final proba = Random().nextInt(100);
    if (proba < 87) {
    } // 87% de chance d'avoir une case vide
    else if (proba < 92) {
      hasRightWall = true;
    } // 5% d'un mur à droite
    else if (proba < 97) {
      hasBottomWall = true;
    } // 5% d'un mur à bas
    else if (proba <= 99) {
      // 2% d'un mur en bas gauche
      hasBottomWall = true;
      hasRightWall = true;
    }

    return Case(
        type: caseType,
        x: x,
        y: y,
        hasBottomWall: hasBottomWall,
        hasRightWall: hasRightWall);
  }

  /// Génére une grille de taille height*width de cases aléatoires après la génération des robots
  void _initGrid() {
    // Choisis les cases spéciales avant de générer le plateau
    var types = [];
    for (var i = 0; i < _robots.length; i++) {
      int x = Random().nextInt(width);
      int y = Random().nextInt(height);

      types.add((x: x, y: y, type: i+1));
    }

    // Génère le plateau
    _grid = List.generate(
        height,
        (int i) => List<Case>.generate(
            width, (int j) => _chooseCase(types: types, x: i, y: j),
            growable: false),
        growable: false);
  }

  /// Génère une liste de robots de taille nbRobots
  void _initRobot() => {
    _robots = List.generate(
        nbRobots,
        (int i) => Robot(
            id: i, x: Random().nextInt(width), y: Random().nextInt(height)))
  };

  void initGame() {
    _initRobot();
    _initGrid();
  }
}
