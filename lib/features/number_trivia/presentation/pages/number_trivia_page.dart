import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_course/core/utils/enums/request_progress_status.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_tdd_course/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter_tdd_course/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number trivia')),
      body: BlocProvider(
        create: (_) => serviceLocator<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state.requestProgressStatus.isNothing) {
                      return const MessageDisplay(message: 'Start Searching!');
                    } else if (state.requestProgressStatus.isLoading) {
                      return const LoadingWidget();
                    } else if (state.requestProgressStatus.isError) {
                      return MessageDisplay(message: state.errorMessage);
                    } else {
                      return TriviaDisplay(
                        trivia: NumberTrivia(
                          number: state.trivia.number,
                          text: state.trivia.text,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                const TriviaControls()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
