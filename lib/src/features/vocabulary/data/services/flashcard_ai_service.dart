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
          'STRICT RULE 1: DO NOT output programming language names (Java, C#, C++, Python, etc.), frameworks, database brands, or product names. '
          'STRICT RULE 2: "meaning" and "exampleTranslation" MUST BE WRITTEN IN JAPANESE (日本語) WITH HIRAGANA (ひらがな: は、が、の、を、です、ます). '
          'ABSOLUTELY NO CHINESE (NO Simplified Chinese 简体中文 like 软件, 项目, 方案, 部署). Use Japanese hiragana, katakana, and Japanese kanji! '
          'STRICT RULE 3: "example" MUST be in English. "exampleTranslation" MUST be the FULL ACCURATE Japanese translation of "example". '
          'Example: "In a software project, a fallback solution is used when a specific feature is not available." -> "ソフトウェアプロジェクトにおいて、特定の機能が利用できない場合には代替手段（フォールバック）が使用されます。" '
          'Output valid JSON array only. No markdown, no explanation.';

      final userText =
          'Generate $count practical IT English vocabulary flashcards as a JSON array. '
          'DO NOT include programming language names (like Java, C#, C++) or brand names. '
          'Use professional IT concepts such as "refactor", "deadlock", "latency", "idempotent", "fallback", "deprecate", "throughput", "provision", "mitigate". '
          'Each item must have: "term" (English IT word/phrase), "hint" (short usage context in English), '
          '"meaning" (Japanese explanation in JAPANESE WITH HIRAGANA), "example" (English example sentence in English), '
          '"exampleTranslation" (FULL ACCURATE Japanese translation of the example sentence IN JAPANESE WITH HIRAGANA), "category" (e.g. Development, Architecture, Testing, Operations). '
          'Return JSON array only: [{"term":"...","hint":"...","meaning":"...","example":"...","exampleTranslation":"...","category":"..."}]';

      final response = await _repository.evaluateCorrection(
        userText: userText,
        systemPrompt: systemPrompt,
      );

      final cards = _parseFlashcards(response);

      // Perform a dedicated high-quality translation pass for any cards with incomplete or Chinese translations
      for (int i = 0; i < cards.length; i++) {
        final card = cards[i];
        if (!_isTranslationHighQuality(card.example, card.exampleTranslation)) {
          final cleanTranslation = await _translateSentence(card.example, card.term);
          if (cleanTranslation.isNotEmpty && _isJapaneseText(cleanTranslation)) {
            cards[i] = card.copyWith(exampleTranslation: cleanTranslation);
          }
        }
      }

      return cards;
    } catch (_) {
      return [];
    }
  }

  bool _isJapaneseText(String text) {
    if (text.isEmpty) return false;
    // Must contain Japanese Hiragana (\u3040-\u309F)
    final hasHiragana = RegExp(r'[\u3040-\u309F]').hasMatch(text);
    // Must not contain Chinese-specific simplified terms
    final hasChineseTerms = RegExp(r'(软件|项目|代码|数据库|服务器|方案|回退|部署|功能不可用)').hasMatch(text);
    return hasHiragana && !hasChineseTerms;
  }

  bool _isTranslationHighQuality(String example, String translation) {
    if (!_isJapaneseText(translation)) return false;
    if (translation == example) return false;

    // Check for truncated half-English fragments like "fallbackな機能"
    if (RegExp(r'[a-zA-Z]{3,}な').hasMatch(translation)) return false;

    // If English sentence has >= 6 words, Japanese translation should be reasonably complete (>= 10 Japanese chars)
    final wordCount = example.trim().split(RegExp(r'\s+')).length;
    if (wordCount >= 6 && translation.length < 10) return false;

    return true;
  }

  Future<String> _translateSentence(String exampleSentence, String term) async {
    if (exampleSentence.isEmpty) return '';
    try {
      const systemPrompt =
          'IT英語を日本語（ひらがな・カタカナ・日本の漢字）で正確に和訳してください。'
          '【厳禁】中国語（簡体字・繁体字）の出力は完全に禁止です。「は、が、の、を、です、ます」などのひらがなを含めた自然な日本語のみ出力してください。';
      final userText =
          'In a software project, a fallback solution is used when a specific feature is not available. → ソフトウェアプロジェクトにおいて、特定の機能が利用できない場合には代替手段が使用されます。\n'
          'The team will deploy the hotfix to production tonight. → チームは今夜、本番環境にホットフィックスをデプロイします。\n'
          'We should cache the API response to reduce latency. → レイテンシーを削減するため、APIレスポンスをキャッシュすべきです。\n\n'
          '$exampleSentence →';

      final response = await _repository.evaluateCorrection(
        userText: userText,
        systemPrompt: systemPrompt,
      );

      String clean = response.replaceAll('"', '').replaceAll('→', '').trim();
      if (clean.contains('\n')) {
        final lines = clean.split('\n');
        for (int i = lines.length - 1; i >= 0; i--) {
          if (_isJapaneseText(lines[i])) {
            clean = lines[i].trim();
            break;
          }
        }
      }
      if (clean.isNotEmpty && _isJapaneseText(clean) && clean.length >= 8) {
        return clean;
      }
    } catch (_) {}
    return '';
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

        var meaning = data['meaning']?.toString().trim() ?? '';
        var exampleTranslation = data['exampleTranslation']?.toString().trim() ?? '';

        // If meaning is Chinese or missing Hiragana, provide a Japanese term explanation
        if (!_isJapaneseText(meaning)) {
          meaning = '$term のIT実務用語';
        }

        // If translation is empty, identical to English example, or Chinese (lacks Hiragana), fall back to meaning
        if (!_isJapaneseText(exampleTranslation) || exampleTranslation == data['example']) {
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
