import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_course/core/error/exceptions.dart';
import 'package:flutter_tdd_course/core/error/failures.dart';
import 'package:flutter_tdd_course/core/network/network_info.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tNumber = 1;
  const tNumberTriviaModel = NumberTriviaModel(text: 'text', number: tNumber);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => Void);
      });

      body();
    });
  }

  void runTestsOffine(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => Void);

      // act
      await repository.getConcreteNumberTrivia(tNumber);

      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, const Right(tNumberTrivia));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);

        // act
        await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenThrow(ServerException());

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffine(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cache data when the call to local data source is present', () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, const Right(tNumberTrivia));
      });

      test('should return ache failure when the call to local data source is not present', () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        //assert
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('getRandomTrivia', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async => Void);

      // act
      await repository.getConcreteNumberTrivia(tNumber);

      //assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should return remote data when the call to remote data source is successful', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });

      test('should cache the data locally when the call to remote data source is successful', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        // act
        await repository.getRandomNumberTrivia();

        //assert
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test('should return server failure when the call to remote data source is unsuccessful', () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());

        // act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestsOffine(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cache data when the call to local data source is present', () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, const Right(tNumberTrivia));
      });

      test('should return failure when the call to local data source is not present', () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        // act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
