import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_course/core/constants/app_constants.dart';
import 'package:flutter_tdd_course/core/error/failures.dart';
import 'package:flutter_tdd_course/core/usecases/usecase.dart';
import 'package:flutter_tdd_course/core/utils/enums/request_progress_status.dart';
import 'package:flutter_tdd_course/core/utils/helpers/input_converter.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initial state should be empty', () async {
    // assert
    expect(bloc.state, const NumberTriviaState());
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'Test text', number: 1);

    test('should call the InputConverter to validate and convert the string to an unsigned integer', () async {
      // arrange
      when(() => mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(const Right(tNumberParsed));
      when(() => mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))).thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
      // assert
      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emits new NumberTriviaState when InputConverter is invalid.',
      setUp: () {
        when(() => mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(Left(InvalidInputFailure()));
        when(() => mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))).thenAnswer((_) async => const Right(tNumberTrivia));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const GetTriviaForConcreteNumber(
          numberString: tNumberString,
        ));
      },
      expect: () {
        return [
          NumberTriviaState(
            errorMessage: AppConstants.failures.invalidInputFailureMessage,
            requestProgressStatus: RequestProgressStatus.error,
          )
        ];
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emits new NumberTriviaState when we get data from use case.',
      setUp: () {
        when(() => mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(const Right(tNumberParsed));
        when(() => mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))).thenAnswer((_) async => const Right(tNumberTrivia));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const GetTriviaForConcreteNumber(
          numberString: tNumberString,
        ));
      },
      expect: () {
        return [
          const NumberTriviaState(requestProgressStatus: RequestProgressStatus.loading),
          const NumberTriviaState(
            requestProgressStatus: RequestProgressStatus.success,
            trivia: tNumberTrivia,
          ),
        ];
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emits new NumberTriviaState when we get data from use case and fails.',
      setUp: () {
        when(() => mockInputConverter.stringToUnsignedInteger(tNumberString)).thenReturn(const Right(tNumberParsed));
        when(() => mockGetConcreteNumberTrivia(const Params(number: tNumberParsed))).thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const GetTriviaForConcreteNumber(
          numberString: tNumberString,
        ));
      },
      expect: () {
        return [
          const NumberTriviaState(requestProgressStatus: RequestProgressStatus.loading),
          NumberTriviaState(
            requestProgressStatus: RequestProgressStatus.error,
            errorMessage: AppConstants.failures.serverFailureMessage,
          ),
        ];
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'Test text', number: 1);

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emits new NumberTriviaState when we get data from random use case.',
      setUp: () {
        when(() => mockGetRandomNumberTrivia(NoParams())).thenAnswer((_) async => const Right(tNumberTrivia));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const GetTriviaForRandomNumber());
      },
      expect: () {
        return [
          const NumberTriviaState(requestProgressStatus: RequestProgressStatus.loading),
          const NumberTriviaState(
            requestProgressStatus: RequestProgressStatus.success,
            trivia: tNumberTrivia,
          ),
        ];
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'emits new NumberTriviaState when we get data from use case and fails.',
      setUp: () {
        when(() => mockGetRandomNumberTrivia(NoParams())).thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => bloc,
      act: (bloc) {
        bloc.add(const GetTriviaForRandomNumber());
      },
      expect: () {
        return [
          const NumberTriviaState(requestProgressStatus: RequestProgressStatus.loading),
          NumberTriviaState(
            requestProgressStatus: RequestProgressStatus.error,
            errorMessage: AppConstants.failures.serverFailureMessage,
          ),
        ];
      },
    );
  });
}
