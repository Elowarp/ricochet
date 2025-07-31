/*
 *  Contact : Elowan - elowarp@gmail.com
 *  Creation : 24-07-2025 22:04:46
 *  Last modified : 31-07-2025 21:03:49
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

class GameRepository {
    final int width;
    final int height;
    final int nbRobots;

    GameRepository({
        required this.width,
        required this.height,
        required this.nbRobots,
    });

    List<List> _grid = [];
    List<Robot> _robots = [];

    List<List> get grid => _grid;
    List<Robot> get robots => _robots;

    int _chooseCase(){
      final proba = Random().nextInt(100);
      if (proba < 87) {return 0;} // 87% de chance d'avoir une case vide
      else if (proba < 92) {return 1;} // 5% d'un mur à droite
      else if (proba < 97) {return 2;} // 5% d'un mur à bas
      else if (proba <= 99) {return 3;} // 2% d'un mur en bas gauche
      else {return 4;} // 1% d'une case impossible
    }

    /// Génére une grille de taille height*width de cases aléatoires
    void initGrid() => {
        _grid = List.generate(height, (int i) => 
          List<int>.generate(width, (int j) => _chooseCase(), growable: false)
          , growable: false
        )
    };

    /// Génère une liste de robots de taille nbRobots
    void initRobot() => {
      _robots = List.generate(nbRobots, (int i) =>
        Robot(id: i, x: Random().nextInt(width), y: Random().nextInt(height))
      )
    };
}