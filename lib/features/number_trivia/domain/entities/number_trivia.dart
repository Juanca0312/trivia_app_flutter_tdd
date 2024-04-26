import 'package:equatable/equatable.dart';

/// Class representing a trivia data associated with a number.
///
/// This class contains information about a trivia fact related to a specific
/// number.
class NumberTrivia extends Equatable {
  /// Constructs an instance of [NumberTrivia].
  ///
  /// [text] is the text describing the trivia fact.
  /// [number] is the number associated with the trivia fact.
  const NumberTrivia({
    required this.text,
    required this.number,
  });

  const NumberTrivia.empty()
      : this(
          text: '',
          number: 0,
        );

  /// The text describing the trivia fact.
  final String text;

  /// The number associated with the trivia fact.
  final int number;

  @override
  List<Object?> get props => [
        text,
        number,
      ];
}
