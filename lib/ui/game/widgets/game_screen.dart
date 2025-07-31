/*
 *  Contact : Elowan - elowarp@gmail.com
 *  Creation : 24-07-2025 22:03:55
 *  Last modified : 31-07-2025 18:29:36
 *  File : game_screen.dart
 */

import 'package:flutter/material.dart';
import 'package:ricochet_app/ui/game/view_model/game_viewmodel.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.viewModel});

  final GameViewModel viewModel;

  /// Retourne les bordures d'une case en (x,y) en fonction de ses murs
  _borderTile({int x = -1, int y = -1}) {
    final noWall = BorderSide(color: Colors.blueGrey);
    final wall = BorderSide(color: Colors.blueGrey, width:4);
    final (t, r, b, l) = viewModel.getWalls(x:x, y:y);

    return Border(
      top: t ? wall : noWall,
      bottom: b ? wall : noWall,
      left: l ? wall : noWall,
      right: r ? wall : noWall,
    );
  }

  /// Retourne la couleur de fond d'une case en (x,y) en fonction de son type
  _colorTile({int x = -1, int y = -1}) {
    switch (viewModel.getCase(x:x, y:y)) {
      case 0: // Case Vide
        return Colors.blueAccent.shade100;

      case 1: //Case Mur Droite
        return Colors.blueAccent.shade100;

      case 2: //Case Mur Bas
        return Colors.blueAccent.shade100;

      case 3: //Case Mur Bas Droite
        return Colors.blueAccent.shade100;

      case 4: // Case Impossible
        return Colors.red;

      default: 
        return Colors.black;

    }
  }

  /// Renvoie le widget à afficher pour la case en (x,y)
  _getTile({int x = -1, int y = -1}){
    // Affichage des robots
    for (var i = 0; i<viewModel.robots.length; i++) {
      final robot = viewModel.robots[i];
      if (robot.x == x && robot.y == y) {
        return GridTile(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              border: Border.all(color: Colors.blueGrey)
            ),
            child: Text('R${robot.id}'),
          )
        );
      }
    }

    // Si aucun robot n'est présent, on affiche la case vide du bon type + murs
    return GridTile(
      child: Container(
        decoration: BoxDecoration(
          color: _colorTile(x:x, y:y),
          border: _borderTile(x:x, y:y)
        ),
      )
    );
  }

  /// Renvoie le widget grille avec les bonnes informations 
  _drawGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(maxWidth: 500, maxHeight: 500),
          child: GridView.count( // Grille de gridWidth de longueur
            crossAxisCount: viewModel.gridWidth,
            children: List.generate(
              viewModel.gridWidth*viewModel.gridHeight, 
              (index) {
                return Center(
                  child: _getTile(
                    x:index % viewModel.gridWidth, 
                    y:(index / viewModel.gridHeight).floor()
                  ),
                );
            }),
          ),
        );
      }
    );
  }

  @override
  /// Ne dessine que la grille
  Widget build(BuildContext context) {
    viewModel.loadGame();
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel, 
          builder: (context, _) {
            return _drawGrid();
          }
        ) 
      )
    );
  }
}