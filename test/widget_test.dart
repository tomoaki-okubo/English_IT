import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:brse_ai_coach/src/app.dart';
import 'package:brse_ai_coach/src/features/dashboard/presentation/controllers/training_activity_controller.dart';
import 'package:brse_ai_coach/src/features/exercises/domain/entities/drill_question.dart';
import 'package:brse_ai_coach/src/features/exercises/domain/entities/saved_drill_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync('hive_test');
    Hive.init(tempDir.path);
    await Hive.openBox<String>('saved_drills');
    await Hive.openBox<String>('training_activity');
  });

  testWidgets('Dashboard smoke test with TrainingCalendarCard', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: BrseAiCoachApp()));
    await tester.pumpAndSettle();

    // Verify that the Dashboard screen and Calendar are rendered.
    expect(find.text('Welcome, BrSE!'), findsOneWidget);
    expect(find.text('連続日数'), findsOneWidget);
    expect(find.text('今月学習'), findsOneWidget);
    expect(find.text('総学習数'), findsOneWidget);
    expect(find.text('Training Menu'), findsOneWidget);
  });

  test('TrainingActivityController records drills and chat turns correctly', () async {
    final container = ProviderContainer();
    final controller = container.read(trainingActivityControllerProvider.notifier);

    // Initial streak
    expect(container.read(trainingActivityControllerProvider).currentStreak, 0);

    // Record drill
    await controller.recordActivity(drills: 2);
    expect(container.read(trainingActivityControllerProvider).currentStreak, 1);
    expect(container.read(trainingActivityControllerProvider).totalActivitiesCount, 2);

    // Record chat turns
    await controller.recordActivity(chatTurns: 3);
    expect(container.read(trainingActivityControllerProvider).totalActivitiesCount, 5);
    expect(container.read(trainingActivityControllerProvider).activeDaysThisMonth, 1);
  });

  test('DrillQuestion shuffled preserves translation', () {
    const question = DrillQuestion(
      category: 'API & Backend',
      topic: 'API Lifecycle',
      question: 'We plan to _____ version 1.',
      options: ['deprecate', 'appreciate', 'celebrate'],
      correctIndex: 0,
      explanation: 'Explanation text',
      translation: '和訳テキスト',
    );

    final shuffled = question.shuffled();
    expect(shuffled.translation, '和訳テキスト');
    expect(shuffled.explanation, 'Explanation text');
  });

  test('SavedDrillItem serializes and deserializes translation', () {
    final item = SavedDrillItem(
      id: '123',
      category: 'API & Backend',
      topic: 'API Lifecycle',
      question: 'We plan to deprecate version 1.',
      options: ['deprecate', 'appreciate'],
      correctIndex: 0,
      explanation: 'Explanation text',
      savedAt: DateTime.now(),
      translation: '和訳テキスト',
    );

    final map = item.toMap();
    expect(map['translation'], '和訳テキスト');

    final deserialized = SavedDrillItem.fromMap(map);
    expect(deserialized.translation, '和訳テキスト');
  });
}
