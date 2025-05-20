import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/imc_screen.dart';           // tela de cálculo IMC
import 'screens/imc_historico_screen.dart'; // tela histórico IMC
import 'screens/lista_refeicoes_screen.dart';
import 'screens/refeicoes_screen.dart';
import 'screens/notas_list_screen.dart';

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
      },
    );
  }
}
