import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/servico_dados.dart';
import 'rotas.dart';

void main() {
  runApp(const FluentPathApp());
}

class CoresApp {
  static const primaria = Color(0xFF2E7D6B);

  static const destaque = Color(0xFFF2A541);

  static const fundo = Color(0xFFF6F8F7);
}

class FluentPathApp extends StatelessWidget {
  const FluentPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServicoDados(),
      child: MaterialApp(
        title: 'FluentPath',
        debugShowCheckedModeBanner: false,
        theme: _tema(),
        initialRoute: Rotas.dicas,
        routes: Rotas.mapa,
      ),
    );
  }

  ThemeData _tema() {
    final cores = ColorScheme.fromSeed(
      seedColor: CoresApp.primaria,
      primary: CoresApp.primaria,
      secondary: CoresApp.destaque,
      surface: CoresApp.fundo,
    );

    return ThemeData(
      colorScheme: cores,
      scaffoldBackgroundColor: CoresApp.fundo,
      appBarTheme: AppBarTheme(
        backgroundColor: cores.primary,
        foregroundColor: cores.onPrimary,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cores.primary,
          foregroundColor: cores.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
