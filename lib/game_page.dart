import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'custom_dialog.dart';
import 'game_button.dart';

class gamePage extends StatefulWidget {
  final bool withComputer;
  gamePage({Key key, @required this.withComputer}) : super(key: key);
  @override
  _gamePageState createState() => new _gamePageState(withComputer);
}

class _gamePageState extends State<gamePage> {
  final bool withComputer;
  List<GameButton> buttonList;
  List playerX;
  List playerO;
  var activePlayer;
  int c_score = 0;
  int p_score = 0;
  int round = 1;
  var active_color;
  _gamePageState(this.withComputer); //constructor
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonList = doInit();
    if (activePlayer == 1 && withComputer) autoPlay();
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        activePlayer = 2;
        active_color = Colors.amber;
        playerX.add(gb.id);
      } else {
        gb.text = "0";
        gb.bg = Colors.amber;
        activePlayer = 1;
        active_color = Colors.red;
        playerO.add(gb.id);
      }
      gb.enabled = false;
      int winner = checkWinner();
      if (winner == -1) {
        if (playerX.length == 5 || playerO.length == 5)
          reset();
        else if (activePlayer == 1 && withComputer) autoPlay();
      }
    });
  }

//design
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: reset,
          label: new Text("reset"),
          icon: new Icon(Icons.refresh),
          backgroundColor: active_color),
      body: new Container(
        padding: EdgeInsets.all(26.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _state(
                      "Player X",
                      c_score,
                      active_color == Colors.red
                          ? active_color
                          : Colors.blueAccent),
                  _state("Round", round, Colors.black54),
                  _state("Player O", p_score,
                      active_color == Colors.amber ? active_color : Colors.blue)
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
            ),
            new Expanded(
              child: new GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 9.0,
                  mainAxisSpacing: 9.0,
                ),
                itemCount: buttonList.length,
                itemBuilder: (context, i) => new SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: new RaisedButton(
                    onPressed: buttonList[i].enabled
                        ? () => playGame(buttonList[i])
                        : null,
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(buttonList[i].text,
                        style:
                            new TextStyle(color: Colors.white, fontSize: 20.0)),
                    color: buttonList[i].bg,
                    disabledColor: buttonList[i].bg,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<GameButton> doInit() {
    playerX = new List();
    playerO = new List();
    var r = new Random();
    activePlayer = r.nextInt(2) + 1;
    active_color = activePlayer == 1 ? Colors.red : Colors.amber;
    var gameButtons = <GameButton>[
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
      new GameButton(id: 9),
    ];
    return gameButtons;
  }

  int checkWinner({bool control = false}) {
    var winner = -1;

    if (isWinner(playerX)) winner = 1;
    if (isWinner(playerO)) winner = 2;

    if (!control && winner != -1) {
      if (winner == 1) {
        c_score++;
      } else {
        p_score++;
      }
      round++;
      if (round == 8) {
        showDialog(
            context: context,
            builder: (_) => CustomDialog("Result",
                "Player X : $c_score\nPlayer O: $p_score", resetGame));
      }
      Future.delayed(Duration(milliseconds: 500), () {
        reset();
      });
    }
    return winner;
  }

  bool isWinner(List player) {
    bool return_value = false;
    if (player.contains(1) && player.contains(2) && player.contains(3)) {
      return_value = true;
    }
    if (player.contains(4) && player.contains(5) && player.contains(6)) {
      return_value = true;
    }
    if (player.contains(7) && player.contains(8) && player.contains(9)) {
      return_value = true;
    }
    if (player.contains(1) && player.contains(4) && player.contains(7)) {
      return_value = true;
    }
    if (player.contains(2) && player.contains(5) && player.contains(8)) {
      return_value = true;
    }
    if (player.contains(3) && player.contains(6) && player.contains(9)) {
      return_value = true;
    }
    if (player.contains(1) && player.contains(5) && player.contains(9)) {
      return_value = true;
    }
    if (player.contains(7) && player.contains(5) && player.contains(3)) {
      return_value = true;
    }
    return return_value;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    c_score = 0;
    p_score = 0;
    round = 1;
    reset();
  }

  void reset() {
    setState(() {
      buttonList = doInit();
      if (activePlayer == 1 && withComputer) autoPlay();
    });
  }

  void autoPlay() {
    List allCells = new List.generate(9, (i) => i + 1);
    List emptyCells = new List();
    for (var cell in allCells) {
      if (!(playerX.contains(cell) || playerO.contains(cell))) {
        emptyCells.add(cell);
      }
    }
    var play_cell;

    for (var cell in emptyCells) {
      //Check computer is winner any step
      playerX.add(cell);
      if (checkWinner(control: true) == 1) {
        playerX.removeLast();
        play_cell = cell;
      } else {
        playerX.removeLast();
      }
    }
    for (var cell in emptyCells) {
      playerO.add(cell);
      if (checkWinner(control: true) == 2) {
        playerO.removeLast();
        play_cell = play_cell ?? cell;
      } else {
        playerO.removeLast();
      }
    }
    if (play_cell == null) {
      var r = new Random();
      var randIndex = r.nextInt(emptyCells.length);
      play_cell = emptyCells[randIndex];
    }
    playGame(buttonList[play_cell - 1]);
  }

  Widget _state(var name, var score, var _color) {
    return Container(
      child: new Column(
        children: <Widget>[
          new Text(
            "$name",
            style: TextStyle(color: Colors.white),
          ),
          new Text(
            "$score",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      decoration: BoxDecoration(
          color: _color, borderRadius: BorderRadius.circular(8.0)),
      padding: EdgeInsets.all(8.0),
    );
  }
}
