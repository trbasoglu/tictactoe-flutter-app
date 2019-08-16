import 'package:flutter/material.dart';
import 'game_page.dart';
import 'package:url_launcher/url_launcher.dart';

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    'images/tictactoe_fg.png',
                    width: 200.0,
                    height: 200.0,
                  )
                ],
              ),
              _button("SINGLEPLAYER", () {
                Navigator.pushNamed(context, '/singleplayer');
              }),
              _button("MULTIPLAYER", () {
                Navigator.pushNamed(context, '/multiplayer');
              }),
              _button("OTHER APPS", _launchURL),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = "https://play.google.com/store/apps/developer?id=Hisario";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _button(var _title, var _action) {
    return SizedBox(
      width: double.infinity,
      child: new RaisedButton(
        onPressed: _action,
        child: new Text(_title),
        shape: StadiumBorder(
            side: BorderSide(
                color: Colors.white, style: BorderStyle.solid, width: 2.0)),
        splashColor: Colors.amber,
        color: Colors.deepOrange,
        textColor: Colors.white,
      ),
    );
  }
}
