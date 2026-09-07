import 'package:flutter_test/flutter_test.dart';
import 'package:brse_ai_coach/src/features/exercises/data/sources/drill_seeds_data.dart';

void main() {
  test('Verify seed counts per category', () {
    final Map<String, int> categoryCounts = {};
    for (final seed in DrillSeedsData.allSeeds) {
      categoryCounts[seed.category] = (categoryCounts[seed.category] ?? 0) + 1;
    }

    print('=== SEED COUNTS PER CATEGORY ===');
    int total = 0;
    categoryCounts.forEach((category, count) {
      print('$category: $count seeds');
      total += count;
    });
    print('Total seeds: $total');

    expect(categoryCounts.length, equals(10));
    categoryCounts.forEach((cat, count) {
      expect(count >= 14, isTrue); // Each category has 14-18 seeds now!
    });
  });
}
