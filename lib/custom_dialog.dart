import 'package:flutter/material.dart';
import 'home_page.dart';
class CustomDialog extends StatelessWidget{
  final title;
  final content;
  final VoidCallback callback;
  final actionText;
  CustomDialog(this.title,this.content,this.callback,{this.actionText ="Game finished"});
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(title),
      content: new Text(content) ,
      actions: <Widget>[
        new FlatButton(onPressed: callback, color: Colors.white, child: new Text("Play"),),
        new FlatButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => homePage()),
          );
        }, child: new Text("Menu"))
      ]
    );
  }
}