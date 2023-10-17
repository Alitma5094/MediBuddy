import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:medibuddy/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            progressIndicatorTheme: const ProgressIndicatorThemeData().copyWith(
              circularTrackColor: lightColorScheme?.surface,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
            progressIndicatorTheme: const ProgressIndicatorThemeData().copyWith(
              circularTrackColor: darkColorScheme?.surface,
            ),
          ),
          home: const Navigation(),
        );
      },
    );
  }
}
