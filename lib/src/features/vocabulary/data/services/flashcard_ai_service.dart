import 'dart:convert';
import '../../domain/entities/flashcard.dart';
import '../../../llm_engine/domain/repositories/llm_engine_repository.dart';
import '../../../llm_engine/domain/entities/llm_config.dart';

/// Service that uses the on-device LLM to generate IT vocabulary flashcards.
class FlashcardAiService {
  final LlmEngineRepository _repository;

  FlashcardAiService(this._repository);

  static final Set<String> _forbiddenTerms = {
    'java',
    'c#',
    'c++',
    'c',
    'python',
    'javascript',
    'typescript',
    'php',
    'ruby',
    'go',
    'golang',
    'rust',
    'swift',
    'kotlin',
    'scala',
    'perl',
    'r',
    'html',
    'css',
    'sql',
    'mysql',
    'postgresql',
    'postgres',
    'oracle',
    'sqlite',
    'mongodb',
    'redis',
    'react',
    'angular',
    'vue',
    'spring',
    'django',
    'laravel',
    'flutter',
    'docker',
    'kubernetes',
    'aws',
    'gcp',
    'azure',
    'git',
    'github',
    'jira',
    'confluence',
    'slack',
    'linux',
    'windows',
    'mac',
    'ios',
    'android',
  };

  /// Generate a batch of AI flashcards about IT topics.
  /// Returns a list of generated Flashcard entities.
  Future<List<Flashcard>> generateFlashcards({int count = 5}) async {
    try {
      await _repository.initialize(const LlmConfig(
        modelPath: 'dummy.gguf',
        temperature: 0.1,
        topP: 0.9,
        contextSize: 2048,
      ));

      const systemPrompt =
          'You are an IT English vocabulary teacher for Bridge SEs (Japanese engineers). '
          'Generate practical software engineering verbs, nouns, and technical concepts. '
          'STRICT RULE: DO NOT output programming language names (Java, C#, C++, Python, etc.), frameworks, database brands, or product names. '
          'CRITICAL: "meaning" and "exampleTranslation" MUST BE WRITTEN IN JAPANESE (日本語). '
          'Output valid JSON array only. No markdown, no explanation.';

      final userText =
          'Generate $count practical IT English vocabulary flashcards as a JSON array. '
          'DO NOT include programming language names (like Java, C#, C++) or brand names. '
          'Use professional IT concepts such as "refactor", "deadlock", "latency", "idempotent", "fallback", "deprecate", "throughput", "provision", "mitigate". '
          'Each item must have: "term" (English IT word/phrase), "hint" (short usage context in English), '
          '"meaning" (Japanese explanation in Japanese), "example" (English example sentence in English), '
          '"exampleTranslation" (Japanese translation of the example sentence IN JAPANESE), "category" (e.g. Development, Architecture, Testing, Operations). '
          'Return JSON array only: [{"term":"...","hint":"...","meaning":"...","example":"...","exampleTranslation":"...","category":"..."}]';

      final response = await _repository.evaluateCorrection(
        userText: userText,
        systemPrompt: systemPrompt,
      );

      return _parseFlashcards(response);
    } catch (_) {
      return [];
    }
  }

  List<Flashcard> _parseFlashcards(String response) {
    final cards = <Flashcard>[];

    // Try to extract JSON array from response
    final arrayMatch = RegExp(r'\[[\s\S]*\]').firstMatch(response);
    if (arrayMatch == null) return cards;

    try {
      final List<dynamic> items = jsonDecode(arrayMatch.group(0)!);
      for (int i = 0; i < items.length; i++) {
        final data = items[i] as Map<String, dynamic>;
        final term = data['term']?.toString().trim() ?? '';
        if (term.isEmpty) continue;

        // Exclude proper nouns (languages, brands, products)
        if (_forbiddenTerms.contains(term.toLowerCase())) continue;

        final meaning = data['meaning']?.toString().trim() ?? '';
        var exampleTranslation = data['exampleTranslation']?.toString().trim() ?? '';

        // If translation is empty, identical to English example, or doesn't contain Japanese characters, fall back to meaning
        if (exampleTranslation.isEmpty ||
            exampleTranslation == data['example'] ||
            !RegExp(r'[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff]').hasMatch(exampleTranslation)) {
          exampleTranslation = meaning;
        }

        cards.add(Flashcard(
          id: 'ai_${DateTime.now().millisecondsSinceEpoch}_$i',
          term: term,
          hint: data['hint']?.toString().trim() ?? '',
          meaning: meaning,
          example: data['example']?.toString().trim() ?? '',
          exampleTranslation: exampleTranslation,
          category: data['category']?.toString().trim() ?? 'AI Generated',
          source: FlashcardSource.ai,
        ));
      }
    } catch (_) {}

    return cards;
  }
}
