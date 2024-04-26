import 'package:flutter/material.dart';
import 'package:flutter_tdd_course/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter_tdd_course/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpServiceLocator();
  runApp(const MyApp());
}

/// this is
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Number trivia',
        home: NumberTriviaPage(),
      );
}
