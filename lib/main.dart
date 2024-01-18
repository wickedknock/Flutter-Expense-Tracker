import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 5, 99, 125));
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => {
        runApp(
          MaterialApp(
            darkTheme: ThemeData.dark().copyWith(
              useMaterial3: true,
              colorScheme: kDarkColorScheme,
              cardTheme: const CardTheme().copyWith(
                color: kDarkColorScheme.secondaryContainer,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkColorScheme.primaryContainer),
              ),
            ),
            theme: ThemeData().copyWith(
              useMaterial3: true,
              colorScheme: kColorScheme,
              appBarTheme: const AppBarTheme().copyWith(
                backgroundColor: kColorScheme.onPrimaryContainer,
                foregroundColor: kColorScheme.primaryContainer,
              ),
              cardTheme: const CardTheme().copyWith(
                color: kColorScheme.secondaryContainer,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kColorScheme.primaryContainer,
                    foregroundColor: kDarkColorScheme.onPrimaryContainer),
              ),
              // textTheme: const TextTheme().copyWith(
              //   titleLarge: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       color: kColorScheme.onSecondaryContainer,
              //       fontSize: 14),
              // ),
            ),
            themeMode: ThemeMode.system,
            home: const Expenses(),
          ),
        )
      });
}
