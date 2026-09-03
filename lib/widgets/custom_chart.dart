import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CategorySpendChart extends StatefulWidget {
  final Map<String, double> categoryData;

  const CategorySpendChart({
    super.key,
    required this.categoryData,
  });

  @override
  State<CategorySpendChart> createState() => _CategorySpendChartState();
}

class _CategorySpendChartState extends State<CategorySpendChart> {
  int touchedIndex = -1;

  final List<Color> _chartColors = [
    AppColors.primaryTeal,
    AppColors.accentGold,
    AppColors.protectiveGreen,
    AppColors.infoBlue,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final entries = widget.categoryData.entries.toList();
    final double total = widget.categoryData.values.fold(0, (a, b) => a + b);

    return SizedBox(
      height: 220,
      child: Row(
        children: [
          // Donut Chart
          Expanded(
            flex: 6,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 3,
                centerSpaceRadius: 42,
                sections: List.generate(entries.length, (i) {
                  final isTouched = i == touchedIndex;
                  final fontSize = isTouched ? 16.0 : 13.0;
                  final radius = isTouched ? 50.0 : 42.0;
                  final pct = total > 0 ? (entries[i].value / total * 100).toStringAsFixed(0) : "0";

                  return PieChartSectionData(
                    color: _chartColors[i % _chartColors.length],
                    value: entries[i].value,
                    title: '$pct%',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Legend
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(entries.length, (i) {
                final color = _chartColors[i % _chartColors.length];
                final entry = entries[i];
                final isTouched = i == touchedIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
                      Container(
                        width: isTouched ? 14 : 10,
                        height: isTouched ? 14 : 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isTouched ? FontWeight.bold : FontWeight.w500,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              "₹${entry.value.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
