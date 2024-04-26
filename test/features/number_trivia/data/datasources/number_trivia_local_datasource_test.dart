import 'dart:convert';

import 'package:flutter_tdd_course/core/constants/app_constants.dart';
import 'package:flutter_tdd_course/core/error/exceptions.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return NumberTrivia model from Shared Preferences when there is in the cache', () async {
      // arrange
      when(() => mockSharedPreferences.getString(AppConstants.cachedNumberTrivia)).thenReturn(fixture('trivia_cached.json'));

      // act
      final result = await dataSource.getLastNumberTrivia();

      // expect
      verify(() => mockSharedPreferences.getString(AppConstants.cachedNumberTrivia));
      expect(result, tNumberTriviaModel);
    });

    test('should throw CacheException when there is not cached value', () async {
      // arrange
      when(() => mockSharedPreferences.getString(AppConstants.cachedNumberTrivia)).thenReturn(null);

      // act
      final call = dataSource.getLastNumberTrivia;

      // expect
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test number', number: 1);
    final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

    test('should call SharedPreferences to cache the data', () async {
      // arrange
      when(() => mockSharedPreferences.setString(AppConstants.cachedNumberTrivia, expectedJsonString)).thenAnswer((_) async => true);

      // act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);

      // expect
      verify(() => mockSharedPreferences.setString(AppConstants.cachedNumberTrivia, expectedJsonString));
    });
  });
}
