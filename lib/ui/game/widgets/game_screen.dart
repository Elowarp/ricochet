/*
 *  Contact : Elowan - elowarp@gmail.com
 *  Creation : 24-07-2025 22:03:55
 *  Last modified : 01-08-2025 13:08:03
 *  File : game_screen.dart
 */

import 'package:flutter/material.dart';
import 'package:ricochet_app/ui/game/view_model/game_viewmodel.dart';

class GameScreen extends StatelessWidget {
  final GameViewModel viewModel;
  const GameScreen({super.key, required this.viewModel});

  /// Retourne les bordures d'une case en (x,y) en fonction de ses murs
  _borderTile({int x = -1, int y = -1}) {
    final noWall = BorderSide(color: Colors.blueGrey);
    final wall = BorderSide(color: Colors.blueGrey, width: 4);
    final (t, r, b, l) = viewModel.getWalls(x: x, y: y);

    return Border(
      top: t ? wall : noWall,
      bottom: b ? wall : noWall,
      left: l ? wall : noWall,
      right: r ? wall : noWall,
    );
  }

  static colorRobot({int id = -1}){
    switch (id) {
      case 0: // Robot 0
        return Colors.greenAccent.shade100;

      case 1: 
        return Colors.redAccent.shade100;

      case 2: 
        return Colors.purpleAccent.shade100;

      case 3: 
        return Colors.orangeAccent.shade100;

      case 4: 
        return Colors.limeAccent.shade100;

      default:
        return Colors.black;
    }

  }

  /// Retourne la couleur de fond d'une case en (x,y) en fonction de son type
  _colorTile({int x = -1, int y = -1}) {
    switch (viewModel.getCaseType(x: x, y: y)) {
      case 0: // Case Vide
        return Colors.blueAccent.shade100;

      case 1: // Case Verte
        return Colors.greenAccent.shade100;

      case 2: // Case Rouge
        return Colors.redAccent.shade100;

      case 3: // Case Violette
        return Colors.purpleAccent.shade100;

      case 4: // Case Orange
        return Colors.orangeAccent.shade100;

      case 5: // Case Indigo
        return Colors.limeAccent.shade100;

      default:
        return Colors.black;
    }
  }

  /// Renvoie le widget à afficher pour la case en (x,y)
  _getTile({int x = -1, int y = -1}) {
    var tileContent = Container();

    // Affichage des robots
    for (var i = 0; i < viewModel.robots.length; i++) {
      final robot = viewModel.robots[i];
      if (robot.x == x && robot.y == y) {
        tileContent = Container(
          width: 500/viewModel.gridWidth,
          height: 500/viewModel.gridHeight,
          decoration: BoxDecoration(
            color: colorRobot(id: robot.id),
            shape: BoxShape.circle,
          ),
          child: Center(child: Text('$i'))
        );
        break;
        
      }
    }

    // Si aucun robot n'est présent, on affiche la case vide du bon type + murs
    return GridTile(
        child: Container(
          decoration: BoxDecoration(
            color: _colorTile(x: x, y: y), 
            border: _borderTile(x: x, y: y)
          ),
          child: tileContent,
      )
    );
  }

  /// Renvoie le widget grille avec les bonnes informations
  _drawGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: 500,
        height: 500,
        child: GridView.count(
          // Grille de gridWidth de longueur
          crossAxisCount: viewModel.gridWidth,
          children: List.generate(viewModel.gridWidth * viewModel.gridHeight,
              (index) {
            return Center(
              child: _getTile(
                  x: index % viewModel.gridWidth,
                  y: (index / viewModel.gridHeight).floor()),
            );
          }),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel.loadGame();
    return Scaffold(
        body: SafeArea(
            child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(child: _drawGrid()),
                        ), // Grille de jeu
                        Expanded(
                            child: Container(
                                color: Colors.blue,
                                child: ControllerWidget(viewModel: viewModel)))
                      ],
                    ),
                  );
                })));
  }
}

class ControllerWidget extends StatelessWidget {
  final GameViewModel viewModel;

  const ControllerWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Selectionne ton robot : "),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    List<Widget>.generate(viewModel.robots.length, (int index) {
                  if (index == viewModel.selectedRobot) {
                    return ElevatedButton(
                      onPressed: () => viewModel.selectedRobot = index,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.lerp(const Color.fromARGB(255, 0, 0, 0), GameScreen.colorRobot(id: index), 0.5),
                      ),
                      child: Text('$index', style:TextStyle(color: Colors.white)),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () => viewModel.selectedRobot = index,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GameScreen.colorRobot(id: index),
                      ),
                      child: Text('$index'),
                    );
                  }
                }),
              ),
              SizedBox(
                height: 20,
              ),

              Text("Déplace ton robot : "),
              ElevatedButton(
                  onPressed: () => viewModel.moveRobot(dir: "up"),
                  child: Text("up")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => viewModel.moveRobot(dir: "left"),
                      child: Text("left")),
                  ElevatedButton(
                      onPressed: () => viewModel.moveRobot(dir: "right"),
                      child: Text("right")),
                ],
              ),
              ElevatedButton(
                  onPressed: () => viewModel.moveRobot(dir: "down"),
                  child: Text("down")),
            ],
          );
        });
  }
}
