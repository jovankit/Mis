import 'package:flutter/material.dart';

class ClothesQuestion extends StatelessWidget {
  String questionContent;

  ClothesQuestion(this.questionContent);

  @override
  Widget build(BuildContext context) {
    return Text(
      questionContent,
      style: const TextStyle(color: Colors.blue),
    );
  }
}
