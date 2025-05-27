import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../db/database_helper.dart';
import 'package:intl/intl.dart';

class GraficoPesoScreen extends StatefulWidget {
  const GraficoPesoScreen({super.key});

  @override
  State<GraficoPesoScreen> createState() => _GraficoPesoScreenState();
}

class _GraficoPesoScreenState extends State<GraficoPesoScreen> {
  List<FlSpot> _spots = [];
  List<String> _labels = [];
  String _filtro = '7 dias';

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final db = await DatabaseHelper().database;
    final agora = DateTime.now();
    final dataLimite = _filtro == '7 dias'
        ? agora.subtract(const Duration(days: 7))
        : agora.subtract(const Duration(days: 30));

    final dados = await db.rawQuery('''
      SELECT data, peso FROM pesos
      WHERE data >= ?
      ORDER BY data ASC
    ''', [dataLimite.toIso8601String()]);

    List<FlSpot> spots = [];
    List<String> labels = [];

    for (int i = 0; i < dados.length; i++) {
      final peso = double.tryParse(dados[i]['peso'].toString()) ?? 0;
      final dataStr = dados[i]['data'] as String;
      final data = DateTime.tryParse(dataStr);
      if (data != null) {
        spots.add(FlSpot(i.toDouble(), peso));
        labels.add(DateFormat('dd/MM').format(data));
      }
    }

    setState(() {
      _spots = spots;
      _labels = labels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gráfico de Peso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Filtro: '),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _filtro,
                  items: const [
                    DropdownMenuItem(value: '7 dias', child: Text('Última Semana')),
                    DropdownMenuItem(value: '30 dias', child: Text('Último Mês')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _filtro = value!;
                    });
                    _carregarDados();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _spots.isEmpty
                  ? const Center(child: Text('Nenhum dado encontrado'))
                  : LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            spots: _spots,
                            barWidth: 4,
                            color: Colors.green,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.green.withOpacity(0.3),
                            ),
                            dotData: FlDotData(show: true),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 && index < _labels.length) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(_labels[index], style: const TextStyle(fontSize: 10)),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
