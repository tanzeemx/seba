import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'screens/home_page.dart';

// ←←←←← PUT YOUR NEW API KEY HERE (39 characters) ←←←←←
const String GEMINI_API_KEY = "AIzaSyCatl_KnHRGst7NSzzHjojXDSTlLVNrffw";
// Replace the above with your NEW key from: https://aistudio.google.com/app/apikey

void main() {
  runApp(const SEBAApp());
}

class SEBAApp extends StatelessWidget {
  const SEBAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: FlexThemeData.light(
        scheme: FlexScheme.orangeM3,
        useMaterial3: true,
      ),
      dark: FlexThemeData.dark(
        scheme: FlexScheme.orangeM3,
        useMaterial3: true,
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SEBA - Sher-E-Bangla Artificial',
        theme: theme,
        darkTheme: darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
