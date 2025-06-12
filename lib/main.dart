import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class WrapSafarTheme extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Color get outlineLabel =>
      _isDarkMode
          ? Color.fromARGB(255, 172, 199, 255) // Dark mode outline label color
          : Color(0xFF122B5C); // Light mode outline label color

  // Adjusted brightness versions for dark/light themes
  Color get pureWhite =>
      _isDarkMode ? Color.fromARGB(255, 0, 0, 0) : Color(0xFFFFFFFF);
  Color get onPureWhite =>
      _isDarkMode ? Color(0xFFFFFFFF) : Color.fromARGB(255, 0, 0, 0);

  Color get darkBlue => _isDarkMode ? Color(0xFF122B5C) : Color(0xFF1E3A8A);
  Color get onDarkBlue =>
      _isDarkMode
          ? Color(0xFFE0E7FF)
          : Color(0xFFFFFFFF); // soft/light text on dark blue

  Color get vividOrange => _isDarkMode ? Color(0xFF9F470C) : Color(0xFFF97316);
  Color get onVividOrange =>
      _isDarkMode
          ? Color(0xFFFFF7ED)
          : Color(0xFF1E1E1E); // dark text on orange in light mode

  Color get mintGreen => _isDarkMode ? Color(0xFF17803D) : Color(0xFF4ADE80);
  Color get onMintGreen =>
      _isDarkMode
          ? Color(0xFFE6FFF1)
          : Color.fromARGB(255, 9, 83, 46); // readable contrast both ways

  Color get skyBlue => _isDarkMode ? Color(0xFF1C84B5) : Color(0xFF38BDF8);
  Color get onSkyBlue =>
      _isDarkMode
          ? Color(0xFFE0F7FF)
          : Color(0xFF002438); // very dark text for bright blue

  ThemeData get themeData => ThemeData(
    brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: pureWhite,
    scaffoldBackgroundColor: darkBlue,
    cardColor: pureWhite,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBlue,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
    ),
  );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WrapSafarTheme(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WrapSafarTheme>(
      builder: (context, theme, _) {
        return MaterialApp(
          title: 'Wrap Safar',
          debugShowCheckedModeBanner: false,
          theme: theme.themeData,
          home: const HomePage(),
        );
      },
    );
  }
}
