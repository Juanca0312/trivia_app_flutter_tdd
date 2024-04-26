import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputStr = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          onChanged: (value) {
            inputStr = value;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      context.read<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(numberString: inputStr));
                    },
                    child: const Text('search'))),
            const SizedBox(width: 10),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      context.read<NumberTriviaBloc>().add(const GetTriviaForRandomNumber());
                    },
                    child: const Text('Random'))),
          ],
        )
      ],
    );
  }
}
