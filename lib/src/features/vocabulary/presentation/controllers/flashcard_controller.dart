import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard.dart';
import '../../data/sources/flashcard_seeds_data.dart';
import '../../data/repositories/flashcard_repository.dart';
import '../../data/services/flashcard_ai_service.dart';
import '../../../llm_engine/domain/providers.dart';

// --- State ---

class FlashcardState {
  final List<Flashcard> allCards;
  final List<Flashcard> sessionDeck;
  final int sessionIndex;
  final bool isLoading;
  final bool isGeneratingAi;
  final String? selectedCategory;
  final FlashcardSessionMode mode;
  final int sessionKnownCount;
  final int sessionUnknownCount;

  const FlashcardState({
    this.allCards = const [],
    this.sessionDeck = const [],
    this.sessionIndex = 0,
    this.isLoading = true,
    this.isGeneratingAi = false,
    this.selectedCategory,
    this.mode = FlashcardSessionMode.all,
    this.sessionKnownCount = 0,
    this.sessionUnknownCount = 0,
  });

  // Statistics
  int get totalCards => allCards.length;
  int get masteredCount => allCards.where((c) => c.status == FlashcardStatus.mastered).length;
  int get learningCount => allCards.where((c) => c.status == FlashcardStatus.learning).length;
  int get newCount => allCards.where((c) => c.status == FlashcardStatus.newCard).length;
  int get totalReviews => allCards.fold(0, (sum, c) => sum + c.reviewCount);

  // Category Filtered Statistics
  List<Flashcard> get filteredCards {
    if (selectedCategory == null) return allCards;
    if (selectedCategory == 'AI生成') {
      return allCards
          .where((c) => c.source == FlashcardSource.ai || c.category == 'AI生成')
          .toList();
    }
    return allCards.where((c) => c.category == selectedCategory).toList();
  }

  int get filteredTotalCount => filteredCards.length;
  int get filteredMasteredCount =>
      filteredCards.where((c) => c.status == FlashcardStatus.mastered).length;
  int get filteredLearningCount =>
      filteredCards.where((c) => c.status == FlashcardStatus.learning).length;
  int get filteredNewCount =>
      filteredCards.where((c) => c.status == FlashcardStatus.newCard).length;
  int get filteredUnlearnedCount =>
      filteredCards.where((c) => c.status != FlashcardStatus.mastered).length;

  double get filteredMasteredPercent =>
      filteredTotalCount > 0 ? filteredMasteredCount / filteredTotalCount : 0;
  double get filteredLearningPercent =>
      filteredTotalCount > 0 ? filteredLearningCount / filteredTotalCount : 0;
  double get filteredNewPercent =>
      filteredTotalCount > 0 ? filteredNewCount / filteredTotalCount : 0;

  double get masteredPercent => totalCards > 0 ? masteredCount / totalCards : 0;
  double get learningPercent => totalCards > 0 ? learningCount / totalCards : 0;
  double get newPercent => totalCards > 0 ? newCount / totalCards : 0;

  bool get isSessionComplete => sessionIndex >= sessionDeck.length;
  Flashcard? get currentCard =>
      sessionIndex < sessionDeck.length ? sessionDeck[sessionIndex] : null;

  List<String> get categories {
    final cats = allCards.map((c) => c.category).toSet().toList();
    if (allCards.any((c) => c.source == FlashcardSource.ai) && !cats.contains('AI生成')) {
      cats.add('AI生成');
    }
    cats.sort();
    return cats;
  }

  FlashcardState copyWith({
    List<Flashcard>? allCards,
    List<Flashcard>? sessionDeck,
    int? sessionIndex,
    bool? isLoading,
    bool? isGeneratingAi,
    String? Function()? selectedCategory,
    FlashcardSessionMode? mode,
    int? sessionKnownCount,
    int? sessionUnknownCount,
  }) {
    return FlashcardState(
      allCards: allCards ?? this.allCards,
      sessionDeck: sessionDeck ?? this.sessionDeck,
      sessionIndex: sessionIndex ?? this.sessionIndex,
      isLoading: isLoading ?? this.isLoading,
      isGeneratingAi: isGeneratingAi ?? this.isGeneratingAi,
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
      mode: mode ?? this.mode,
      sessionKnownCount: sessionKnownCount ?? this.sessionKnownCount,
      sessionUnknownCount: sessionUnknownCount ?? this.sessionUnknownCount,
    );
  }
}

enum FlashcardSessionMode { all, unlearned, ai }

// --- Provider ---

final flashcardControllerProvider =
    NotifierProvider<FlashcardController, FlashcardState>(() {
  return FlashcardController();
});

// --- Controller ---

class FlashcardController extends Notifier<FlashcardState> {
  final FlashcardRepository _repository = FlashcardRepository();

  @override
  FlashcardState build() {
    scheduleMicrotask(() => _loadCards());
    return const FlashcardState();
  }

  Future<void> _loadCards() async {
    // 1. Generate seed cards
    final seedCards = FlashcardSeedsData.generateFromDrillSeeds();

    // 2. Load user/AI cards from Hive
    final userCards = await _repository.loadUserCards();

    // 3. Load review states
    final reviewStates = await _repository.loadReviewStates();

    // 4. Merge: apply saved review state to seed cards
    final allCards = <Flashcard>[];
    for (final card in seedCards) {
      if (reviewStates.containsKey(card.id)) {
        final saved = reviewStates[card.id]!;
        allCards.add(card.copyWith(
          reviewCount: saved.reviewCount,
          correctCount: saved.correctCount,
          lastReviewedAt: saved.lastReviewedAt,
          status: saved.status,
        ));
      } else {
        allCards.add(card);
      }
    }

    // 5. Add user/AI cards (already have state embedded)
    for (final card in userCards) {
      if (reviewStates.containsKey(card.id)) {
        final saved = reviewStates[card.id]!;
        allCards.add(card.copyWith(
          reviewCount: saved.reviewCount,
          correctCount: saved.correctCount,
          lastReviewedAt: saved.lastReviewedAt,
          status: saved.status,
        ));
      } else {
        allCards.add(card);
      }
    }

    state = state.copyWith(allCards: allCards, isLoading: false);
  }

  /// Set category filter
  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: () => category);
  }

  /// Start a flashcard session
  void startSession(FlashcardSessionMode mode) {
    List<Flashcard> deck;

    switch (mode) {
      case FlashcardSessionMode.all:
        deck = _filteredCards();
        break;
      case FlashcardSessionMode.unlearned:
        deck = _filteredCards()
            .where((c) => c.status != FlashcardStatus.mastered)
            .toList();
        break;
      case FlashcardSessionMode.ai:
        // AI deck will be populated asynchronously
        deck = [];
        break;
    }

    deck.shuffle();

    state = state.copyWith(
      sessionDeck: deck,
      sessionIndex: 0,
      mode: mode,
      sessionKnownCount: 0,
      sessionUnknownCount: 0,
    );

    if (mode == FlashcardSessionMode.ai) {
      _generateAiCards();
    }
  }

  List<Flashcard> _filteredCards() {
    if (state.selectedCategory == null) {
      return List<Flashcard>.from(state.allCards);
    }
    if (state.selectedCategory == 'AI生成') {
      return state.allCards
          .where((c) => c.source == FlashcardSource.ai || c.category == 'AI生成')
          .toList();
    }
    return state.allCards
        .where((c) => c.category == state.selectedCategory)
        .toList();
  }

  /// Generate AI flashcards
  Future<void> _generateAiCards() async {
    state = state.copyWith(isGeneratingAi: true);

    try {
      final llmRepo = ref.read(llmEngineRepositoryProvider);
      final aiService = FlashcardAiService(llmRepo);
      final aiCards = await aiService.generateFlashcards(count: 5);

      if (aiCards.isNotEmpty) {
        // Save AI cards to repository
        for (final card in aiCards) {
          await _repository.saveCard(card);
        }

        // Update allCards and sessionDeck
        final updatedAll = [...state.allCards, ...aiCards];
        state = state.copyWith(
          allCards: updatedAll,
          sessionDeck: aiCards,
          isGeneratingAi: false,
        );
      } else {
        // Fallback: use seed cards
        final fallbackDeck = _filteredCards()..shuffle();
        state = state.copyWith(
          sessionDeck: fallbackDeck.take(10).toList(),
          isGeneratingAi: false,
        );
      }
    } catch (_) {
      final fallbackDeck = _filteredCards()..shuffle();
      state = state.copyWith(
        sessionDeck: fallbackDeck.take(10).toList(),
        isGeneratingAi: false,
      );
    }
  }

  /// Mark current card as known and advance
  Future<void> markCurrentKnown() async {
    if (state.isSessionComplete) return;

    final card = state.sessionDeck[state.sessionIndex];
    card.markKnown();

    // Update in allCards
    final updatedAll = state.allCards.map((c) {
      if (c.id == card.id) return card;
      return c;
    }).toList();

    await _repository.saveReviewState(card);

    state = state.copyWith(
      allCards: updatedAll,
      sessionIndex: state.sessionIndex + 1,
      sessionKnownCount: state.sessionKnownCount + 1,
    );
  }

  /// Mark current card as unknown and advance
  Future<void> markCurrentUnknown() async {
    if (state.isSessionComplete) return;

    final card = state.sessionDeck[state.sessionIndex];
    card.markUnknown();

    // Update in allCards
    final updatedAll = state.allCards.map((c) {
      if (c.id == card.id) return card;
      return c;
    }).toList();

    await _repository.saveReviewState(card);

    state = state.copyWith(
      allCards: updatedAll,
      sessionIndex: state.sessionIndex + 1,
      sessionUnknownCount: state.sessionUnknownCount + 1,
    );
  }

  /// Retry only unknown cards from last session
  void retryUnknownCards() {
    final unknownCards = state.sessionDeck
        .where((c) => c.status != FlashcardStatus.mastered)
        .toList()
      ..shuffle();

    state = state.copyWith(
      sessionDeck: unknownCards,
      sessionIndex: 0,
      sessionKnownCount: 0,
      sessionUnknownCount: 0,
    );
  }

  /// Add a user-created card
  Future<void> addUserCard({
    required String term,
    required String meaning,
    required String example,
    required String exampleTranslation,
    required String category,
    String hint = '',
  }) async {
    final card = Flashcard(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      term: term,
      hint: hint,
      meaning: meaning,
      example: example,
      exampleTranslation: exampleTranslation,
      category: category,
      source: FlashcardSource.user,
    );

    await _repository.saveCard(card);

    state = state.copyWith(allCards: [...state.allCards, card]);
  }

  /// Delete a user-created card
  Future<void> deleteUserCard(String id) async {
    await _repository.deleteCard(id);
    state = state.copyWith(
      allCards: state.allCards.where((c) => c.id != id).toList(),
    );
  }

  /// Reload cards from storage
  Future<void> reload() async {
    state = state.copyWith(isLoading: true);
    await _loadCards();
  }
}
