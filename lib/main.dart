import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ricochet_app/data/repositories/game_repository.dart';
import 'package:ricochet_app/ui/game/view_model/game_viewmodel.dart';
import 'package:ricochet_app/ui/game/widgets/game_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'ZouBoom',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 196, 132, 255)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GameScreen(
          viewModel: GameViewModel(
            gameRepository: GameRepository(
              width: 20, height: 20, nbRobots: 5
            )
          ),
        );
        break;

      default:
        throw UnimplementedError("No widget for $selectedIndex");
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
