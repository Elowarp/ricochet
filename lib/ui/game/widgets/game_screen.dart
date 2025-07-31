/*
 *  Contact : Elowan - elowarp@gmail.com
 *  Creation : 24-07-2025 22:03:55
 *  Last modified : 24-07-2025 23:30:40
 *  File : game_screen.dart
 */

import 'package:flutter/material.dart';
import 'package:ricochet_app/ui/game/view_model/game_viewmodel.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.viewModel});

  final GameViewModel viewModel;

  _drawGrid({double space = 30, Color color = Colors.red}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        var h = Container(width: 2, height: height, color: color);
        var v = Container(width: width, height: 2, color: color);
        return Stack(children: <Widget>[
          ...List.generate((width / space).round(), (index) => Positioned(left: index * space, child: h)),
          ...List.generate((height / space).round(), (index) => Positioned(top: index * space, child: v)),
        ]);
      }
    );
  }

  @override
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