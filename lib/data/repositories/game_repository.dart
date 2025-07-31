/*
 *  Contact : Elowan - elowarp@gmail.com
 *  Creation : 24-07-2025 22:04:46
 *  Last modified : 24-07-2025 23:15:20
 *  File : game_repository.dart
 */

class GameRepository {
    final int width;
    final int height;
    final int nbRobot;

    GameRepository({
        required this.width,
        required this.height,
        required this.nbRobot,
    });

    List<List> _grid = [];

    List<List> get grid => _grid;

    void initGrid() => {
        // Génére une grille de taille height*width de cases 0
        _grid = List.generate(height, (int i) => 
        List<int>.generate(width, (int j) => 0, growable: false)
        , growable: false)
    };
}