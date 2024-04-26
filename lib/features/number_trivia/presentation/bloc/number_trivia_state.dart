part of 'number_trivia_bloc.dart';

class NumberTriviaState extends Equatable {
  final RequestProgressStatus requestProgressStatus;
  final NumberTrivia trivia;
  final String errorMessage;

  const NumberTriviaState({
    this.requestProgressStatus = RequestProgressStatus.nothing,
    this.trivia = const NumberTrivia.empty(),
    this.errorMessage = '',
  });

  NumberTriviaState copyWith({
    RequestProgressStatus? requestProgressStatus,
    NumberTrivia? trivia,
    String? errorMessage,
  }) =>
      NumberTriviaState(
        requestProgressStatus: requestProgressStatus ?? this.requestProgressStatus,
        trivia: trivia ?? this.trivia,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object> get props => [
        requestProgressStatus,
        trivia,
        errorMessage,
      ];
}
