import 'package:flutter/material.dart';

class AppLoadingLine extends StatelessWidget {
  const AppLoadingLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
        bottom: 14.0,
      ),
      child: Row(
        children: const <Widget>[
          Expanded(
            child: Text(
              "Por favor, aguarde!",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
