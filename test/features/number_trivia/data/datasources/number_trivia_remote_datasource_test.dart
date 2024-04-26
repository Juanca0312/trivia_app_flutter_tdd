import 'dart:convert';

import 'package:flutter_tdd_course/core/error/exceptions.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(Uri());
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('''should perform a GET request on a URL with number 
      being the endpoint and with aplication/json header''', () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(
            fixture('trivia.json'),
            200,
          ));

      // act
      await dataSource.getConcreteNumberTrivia(tNumber);

      // expect
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
    });

    test('''should return NumberTrivia whe the response is 200 (success)''', () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(
            fixture('trivia.json'),
            200,
          ));

      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      // expect
      expect(result, tNumberTriviaModel);
    });

    test('''should throw ServerException when the response is 404 or other''', () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(
            'somethign went wrong',
            404,
          ));

      // act
      final call = dataSource.getConcreteNumberTrivia;

      // expect
      expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('''should perform a GET request on a URL with number 
      being the endpoint and with aplication/json header''', () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(
            fixture('trivia.json'),
            200,
          ));

      // act
      await dataSource.getRandomNumberTrivia();

      // expect
      verify(() => mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random/trivia'),
            headers: {
              'Content-Type': 'application/json',
            },
          ));
    });

    test('''should return NumberTrivia whe the response is 200 (success)''', () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(
            fixture('trivia.json'),
            200,
          ));

      // act
      final result = await dataSource.getRandomNumberTrivia();

      // expect
      expect(result, tNumberTriviaModel);
    });

    test('''should throw ServerException when the response is 404 or other''', () async {
      // arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(
            'something went wrong',
            404,
          ));

      // act
      final call = dataSource.getRandomNumberTrivia;

      // expect
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
