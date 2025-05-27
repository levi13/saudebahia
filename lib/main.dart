import 'package:flutter/material.dart';
import 'package:saudebahia/screens/lista_exercicios_screen.dart';
import 'package:saudebahia/screens/relatorios_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/imc_screen.dart';           // tela de cálculo IMC
import 'screens/imc_historico_screen.dart'; // tela histórico IMC
import 'screens/lista_refeicoes_screen.dart';
import 'screens/refeicoes_screen.dart';
import 'screens/notas_list_screen.dart';
import 'screens/peso_screen.dart';
import 'screens/grafico_peso_screen.dart';
import 'screens/exercicios_screen.dart';


void main() {
  runApp(const AppSaude());
}

class AppSaude extends StatelessWidget {
  const AppSaude({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saúde Bahia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/dashboard',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/imc': (context) => const ImcScreen(),
        '/imc_historico': (context) => const ImcHistoricoScreen(),
        '/lista_refeicoes': (context) => const ListaRefeicoesScreen(),
        '/refeicoes':(context) => const RefeicoesScreen(),
        '/notas': (context) => const NotasListScreen(),
        '/peso': (context) => const PesoScreen(),
        '/grafico_peso': (context) => const GraficoPesoScreen(),
        '/exercicios': (context) => const ExerciciosScreen(),
        '/lista-exercicios': (context) => const ListaExerciciosScreen(),
        '/relatorios': (context) => const RelatoriosScreen(),
      },
    );
  }
}
