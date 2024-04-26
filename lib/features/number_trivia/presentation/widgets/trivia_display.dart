import 'package:flutter/material.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia trivia;
  const TriviaDisplay({
    super.key,
    required this.trivia,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            trivia.number.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(trivia.text),
              ),
            ),
          )
        ],
      ),
    );
  }
}
