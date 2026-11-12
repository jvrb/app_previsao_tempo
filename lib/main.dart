import 'package:flutter/material.dart';
import 'features/previsao/presentation/screens/tela_busca_cidade.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PrevisaoApp());
}

class PrevisaoApp extends StatelessWidget {
  const PrevisaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Previsão do Tempo CPTEC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TelaBuscaCidade(),
    );
  }
}