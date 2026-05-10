import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/chart_models.dart';

class ChartBoard extends StatelessWidget {
  const ChartBoard({super.key, required this.palaces, required this.onTap});

  final List<ChartPalace> palaces;
  final ValueChanged<ChartPalace> onTap;

  @override
  Widget build(BuildContext context) {
    final borderIndices = <int, ChartPalace>{
      0: palaces[0],
      1: palaces[1],
      2: palaces[2],
      3: palaces[3],
      4: palaces[4],
      7: palaces[5],
      8: palaces[6],
      11: palaces[7],
      12: palaces[8],
      13: palaces[9],
      14: palaces[10],
      15: palaces[11],
    };

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 16,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (BuildContext context, int index) {
          final palace = borderIndices[index];
          if (palace != null) {
            return InkWell(
              onTap: () => onTap(palace),
              child: Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: palace.isUnlocked ? Colors.white : AppColors.amberSoft,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: palace.isUnlocked ? AppColors.line : AppColors.amber,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      palace.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${palace.score}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: palace.score >= 35
                            ? AppColors.jade
                            : AppColors.caution,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: index.isEven ? AppColors.jadeSoft : AppColors.amberSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _centerText(index),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          );
        },
      ),
    );
  }

  String _centerText(int index) {
    switch (index) {
      case 5:
        return 'Minh';
      case 6:
        return 'Mệnh';
      case 9:
        return 'AI';
      case 10:
        return '12 cung';
      default:
        return '';
    }
  }
}
