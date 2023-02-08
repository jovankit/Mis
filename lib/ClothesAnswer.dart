import 'package:flutter/material.dart';

class ClothesAnswer extends StatelessWidget {
  String answerText;
  void Function() answerFunction;

  ClothesAnswer(this.answerText, this.answerFunction);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: answerFunction,
        style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        foregroundColor: MaterialStateProperty.all(Colors.red)),
        child: Text(answerText));
  }
}

// ElevatedButton.styleFrom(
// backgroundColor:  const Color.fromRGBO(255, 0, 0, 255),
// textStyle: const TextStyle(color: Color.fromRGBO(255, 0, 0, 255))
// )