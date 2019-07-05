import 'package:flutter/material.dart';

class LoadingLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 14.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Por favor, aguarde!",
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          Container(
            width: 15.0,
            height: 15.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: 2.0,
            ),
          ),
        ],
      ),
    );
  }
}
