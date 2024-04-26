import 'package:flutter_tdd_course/core/network/network_info.dart';
import 'package:flutter_tdd_course/core/utils/helpers/input_converter.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> setUpServiceLocator() async {
  /// Extenal
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);

  serviceLocator.registerSingleton<http.Client>(http.Client());

  serviceLocator.registerSingleton<InternetConnectionChecker>(InternetConnectionChecker());

  /// Core
  serviceLocator.registerSingleton<InputConverter>(InputConverter());
  serviceLocator.registerSingleton<NetworkInfo>(NetworkInfoImpl(serviceLocator<InternetConnectionChecker>()));

  // Data sources
  serviceLocator.registerSingleton<NumberTriviaRemoteDataSource>(NumberTriviaRemoteDataSourceImpl(
    client: serviceLocator<http.Client>(),
  ));
  serviceLocator.registerSingleton<NumberTriviaLocalDataSource>(NumberTriviaLocalDataSourceImpl(
    sharedPreferences: serviceLocator<SharedPreferences>(),
  ));

  // repository
  serviceLocator.registerSingleton<NumberTriviaRepository>(
    NumberTriviaRepositoryImpl(
      remoteDataSource: serviceLocator<NumberTriviaRemoteDataSource>(),
      localDataSource: serviceLocator<NumberTriviaLocalDataSource>(),
      networkInfo: serviceLocator<NetworkInfo>(),
    ),
  );

  // use cases
  serviceLocator.registerSingleton(GetConcreteNumberTrivia(serviceLocator<NumberTriviaRepository>()));
  serviceLocator.registerSingleton(GetRandomNumberTrivia(serviceLocator<NumberTriviaRepository>()));

  // blocs
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator<GetConcreteNumberTrivia>(),
      getRandomNumberTrivia: serviceLocator<GetRandomNumberTrivia>(),
      inputConverter: serviceLocator<InputConverter>(),
    ),
  );
}
