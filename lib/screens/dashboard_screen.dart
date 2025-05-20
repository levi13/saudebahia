import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard - Saúde Bahia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Aqui podemos adicionar lógica para sair do sistema
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(
              context,
              icon: Icons.restaurant_menu,
              title: 'Refeições',
              onTap: () {
                Navigator.pushNamed(context, '/refeicoes');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.fitness_center,
              title: 'Atividades Físicas',
              onTap: () {
                Navigator.pushNamed(context, '/atividades');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.accessibility_new,
              title: 'Calcular IMC',
              onTap: () {
                Navigator.pushNamed(context, '/imc');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.history,
              title: 'Histórico IMC',
              onTap: () {
                Navigator.pushNamed(context, '/imc_historico');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.list_alt,
              title: 'Lista de Refeições',
              onTap: () {
                Navigator.pushNamed(context, '/lista_refeicoes');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.note_add,
              title: 'Notas',
              onTap: () {
                Navigator.pushNamed(context, '/notas');
              },
            ),
            _buildDashboardCard(
              context,
              icon: Icons.bar_chart,
              title: 'Relatórios',
              onTap: () {
                Navigator.pushNamed(context, '/relatorios');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
