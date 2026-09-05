import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../controllers/flashcard_controller.dart';
import '../../domain/entities/flashcard.dart';
import '../../../../core/services/ad_service.dart';

class FlashcardSessionScreen extends ConsumerStatefulWidget {
  const FlashcardSessionScreen({super.key});

  @override
  ConsumerState<FlashcardSessionScreen> createState() =>
      _FlashcardSessionScreenState();
}

class _FlashcardSessionScreenState
    extends ConsumerState<FlashcardSessionScreen> {
  bool _isFlipped = false;
  bool _showHint = false;

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _onAnswer(bool known) async {
    final controller = ref.read(flashcardControllerProvider.notifier);

    setState(() {
      _isFlipped = false;
      _showHint = false;
    });

    if (known) {
      await controller.markCurrentKnown();
    } else {
      await controller.markCurrentUnknown();
    }

    final state = ref.read(flashcardControllerProvider);
    if (state.isSessionComplete) {
      if (mounted) {
        AdService.instance.showInterstitialAd(
          onAdDismissed: () {
            if (mounted) {
              context.pushReplacement('/flashcards/result');
            }
          },
        );
      }
    }
  }

  void _exitSession() {
    AdService.instance.showInterstitialAd(
      onAdDismissed: () {
        if (mounted) {
          context.pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardControllerProvider);

    // AI Generation loading state
    if (state.isGeneratingAi) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AI単語カード生成中'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _exitSession,
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Gap(16),
              Text(
                'On-Device LLMがIT実務単語を生成しています...\n(数秒お待ちください)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }

    if (state.sessionDeck.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('単語カード')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inbox, size: 64, color: Colors.grey),
              const Gap(16),
              const Text('対象のカードが見つかりませんでした。'),
              const Gap(16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('戻る'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isSessionComplete) {
      return Scaffold(
        appBar: AppBar(
          title: Text('復習 (${state.sessionDeck.length}/${state.sessionDeck.length})'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _exitSession,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentCard = state.currentCard;
    final displayIndex = (state.sessionIndex + 1).clamp(1, state.sessionDeck.length);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _exitSession();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('復習 ($displayIndex/${state.sessionDeck.length})'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _exitSession,
          ),
        ),
        body: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: state.sessionDeck.isNotEmpty
                  ? (state.sessionIndex / state.sessionDeck.length).clamp(0.0, 1.0)
                  : 0.0,
              minHeight: 6,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: currentCard == null
                    ? const SizedBox.shrink()
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: _flipCard,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        final rotateAnimation =
                                            Tween(begin: pi, end: 0.0).animate(animation);
                                        return AnimatedBuilder(
                                          animation: rotateAnimation,
                                          child: child,
                                          builder: (context, child) {
                                            final isUnder =
                                                ValueKey(_isFlipped) != child?.key;
                                            var tilt =
                                                (animation.value - 0.5).abs() - 0.5;
                                            tilt *= -0.002;
                                            final value = isUnder
                                                ? min(rotateAnimation.value, pi / 2)
                                                : rotateAnimation.value;
                                            return Transform(
                                              transform: Matrix4.rotationY(value)
                                                ..setEntry(3, 0, tilt),
                                              alignment: Alignment.center,
                                              child: child,
                                            );
                                          },
                                        );
                                      },
                                      child: _isFlipped
                                          ? _buildBackCard(
                                              context, currentCard, constraints)
                                          : _buildFrontCard(
                                              context, currentCard, constraints),
                                    ),
                                  ),
                                  const Gap(16),
                                  Text(
                                    'タップして${_isFlipped ? "表" : "裏"}面を表示',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Action Buttons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _onAnswer(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.orange, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.close, color: Colors.orange),
                      label: const Text(
                        'まだ不安',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _onAnswer(true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text(
                        '覚えた！',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrontCard(
      BuildContext context, Flashcard card, BoxConstraints constraints) {
    final theme = Theme.of(context);

    return Container(
      key: const ValueKey(false),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 280),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 1.5),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(card.category, style: const TextStyle(fontSize: 12)),
                backgroundColor: theme.colorScheme.primaryContainer,
              ),
              _buildSourceBadge(card.source),
            ],
          ),
          const Gap(24),
          Text(
            card.term,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Gap(16),
          if (card.hint.isNotEmpty) ...[
            if (_showHint) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Text(
                  '💡 開発のヒント: ${card.hint}',
                  style: TextStyle(fontSize: 13, color: Colors.amber.shade900),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else ...[
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showHint = true;
                  });
                },
                icon: const Icon(Icons.lightbulb_outline, size: 18),
                label: const Text('ヒントを表示'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildBackCard(
      BuildContext context, Flashcard card, BoxConstraints constraints) {
    final theme = Theme.of(context);

    // Ensure we don't display English as Japanese translation
    final hasJapaneseTranslation = card.exampleTranslation.isNotEmpty &&
        card.exampleTranslation != card.example &&
        RegExp(r'[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff]').hasMatch(card.exampleTranslation);

    final displayTranslation = hasJapaneseTranslation
        ? card.exampleTranslation
        : card.meaning; // Fallback to Japanese meaning if exampleTranslation is English/missing

    return Container(
      key: const ValueKey(true),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 280),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.green.withValues(alpha: 0.5), width: 2),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              card.meaning,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(16),
          const Divider(),
          const Gap(10),
          Row(
            children: [
              Icon(Icons.description_outlined, size: 16, color: theme.colorScheme.primary),
              const Gap(6),
              Text(
                '実務例文 (English)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            card.example,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const Gap(12),
          const Row(
            children: [
              Icon(Icons.translate, size: 16, color: Colors.grey),
              Gap(6),
              Text(
                '日本語訳',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            displayTranslation,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceBadge(FlashcardSource source) {
    switch (source) {
      case FlashcardSource.seed:
        return const SizedBox.shrink();
      case FlashcardSource.ai:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple.shade200),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome, size: 12, color: Colors.purple),
              Gap(4),
              Text(
                'AI生成',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      case FlashcardSource.user:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.shade200),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person, size: 12, color: Colors.teal),
              Gap(4),
              Text(
                'カスタム',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
    }
  }
}
