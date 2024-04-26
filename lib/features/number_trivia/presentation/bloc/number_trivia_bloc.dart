import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_course/core/usecases/usecase.dart';
import 'package:flutter_tdd_course/core/utils/enums/request_progress_status.dart';
import 'package:flutter_tdd_course/core/utils/helpers/failure_helper.dart';
import 'package:flutter_tdd_course/core/utils/helpers/input_converter.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(const NumberTriviaState()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  FutureOr<void> _onGetTriviaForConcreteNumber(GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

    await inputEither.fold((failure) async {
      emit(state.copyWith(
        errorMessage: FailureHelper.mapFailureToMessage(failure),
        requestProgressStatus: RequestProgressStatus.error,
      ));
    }, (number) async {
      emit(state.copyWith(requestProgressStatus: RequestProgressStatus.loading));
      final result = await getConcreteNumberTrivia(Params(number: number));

      await result.fold((failure) async {
        emit(state.copyWith(
          errorMessage: FailureHelper.mapFailureToMessage(failure),
          requestProgressStatus: RequestProgressStatus.error,
        ));
      }, (trivia) async {
        emit(state.copyWith(
          trivia: trivia,
          requestProgressStatus: RequestProgressStatus.success,
        ));
      });
    });
  }

  Future<void> _onGetTriviaForRandomNumber(GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    emit(state.copyWith(requestProgressStatus: RequestProgressStatus.loading));
    final result = await getRandomNumberTrivia(NoParams());

    result.fold((failure) {
      emit(state.copyWith(
        errorMessage: FailureHelper.mapFailureToMessage(failure),
        requestProgressStatus: RequestProgressStatus.error,
      ));
    }, (trivia) {
      emit(state.copyWith(
        trivia: trivia,
        requestProgressStatus: RequestProgressStatus.success,
      ));
    });
  }
}
