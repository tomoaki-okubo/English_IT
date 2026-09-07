import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../controllers/flashcard_controller.dart';
import '../../domain/entities/flashcard.dart';

class FlashcardHomeScreen extends ConsumerWidget {
  const FlashcardHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flashcardControllerProvider);
    final controller = ref.read(flashcardControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IT英語単語カード'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '単語を追加',
            onPressed: () => context.push('/flashcards/add'),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Stats Card ---
                  _buildStatsCard(context, state),
                  const Gap(20),

                  // --- Category Filter ---
                  Text(
                    'カテゴリー選択',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  _buildCategoryFilter(context, state, controller),
                  const Gap(20),

                  // --- Session Modes ---
                  Text(
                    '学習モードを選択',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(12),

                  _buildModeCard(
                    context,
                    title: 'すべてのカードを復習',
                    subtitle: '${state.selectedCategory ?? "全カテゴリー"} (${state.filteredTotalCount}語)',
                    icon: Icons.style,
                    color: Colors.blue,
                    onTap: state.filteredTotalCount == 0
                        ? null
                        : () {
                            controller.startSession(FlashcardSessionMode.all);
                            context.push('/flashcards/session');
                          },
                  ),
                  const Gap(10),

                  _buildModeCard(
                    context,
                    title: '未習得単語の集中復習',
                    subtitle: '${state.selectedCategory != null ? "${state.selectedCategory}の" : ""}未習得カード (${state.filteredUnlearnedCount}語)',
                    icon: Icons.repeat_one,
                    color: Colors.orange,
                    onTap: state.filteredUnlearnedCount == 0
                        ? null
                        : () {
                            controller.startSession(FlashcardSessionMode.unlearned);
                            context.push('/flashcards/session');
                          },
                  ),
                  const Gap(10),

                  _buildModeCard(
                    context,
                    title: 'AIで新しいIT単語を自動生成',
                    subtitle: 'AIがIT実務単語5語をその場で生成して学習',
                    icon: Icons.auto_awesome,
                    color: Colors.purple,
                    onTap: () {
                      controller.startSession(FlashcardSessionMode.ai);
                      context.push('/flashcards/session');
                    },
                  ),
                  const Gap(24),

                  // --- User & AI Cards List Header ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '登録・AI生成単語一覧',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => context.push('/flashcards/add'),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('追加'),
                      ),
                    ],
                  ),
                  const Gap(8),
                  _buildUserCardsList(context, state, controller),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsCard(BuildContext context, FlashcardState state) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '学習進捗',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.selectedCategory != null
                      ? '${state.selectedCategory} (${state.filteredTotalCount} 語)'
                      : '全 ${state.filteredTotalCount} 語',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Gap(12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    if (state.filteredMasteredPercent > 0)
                      Expanded(
                        flex: (state.filteredMasteredPercent * 100).round(),
                        child: Container(color: Colors.green),
                      ),
                    if (state.filteredLearningPercent > 0)
                      Expanded(
                        flex: (state.filteredLearningPercent * 100).round(),
                        child: Container(color: Colors.orange),
                      ),
                    if (state.filteredNewPercent > 0)
                      Expanded(
                        flex: (state.filteredNewPercent * 100).round(),
                        child: Container(color: Colors.grey.shade300),
                      ),
                  ],
                ),
              ),
            ),
            const Gap(14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatBadge('習得済み', state.filteredMasteredCount, Colors.green),
                _buildStatBadge('学習中', state.filteredLearningCount, Colors.orange),
                _buildStatBadge('未着手', state.filteredNewCount, Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String label, int count, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const Gap(4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
        const Gap(2),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(
    BuildContext context,
    FlashcardState state,
    FlashcardController controller,
  ) {
    final categories = ['すべて', ...state.categories];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat == 'すべて'
              ? state.selectedCategory == null
              : state.selectedCategory == cat;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              selected: isSelected,
              label: Text(cat),
              onSelected: (_) {
                controller.setCategory(cat == 'すべて' ? null : cat);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        enabled: onTap != null,
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _buildUserCardsList(
    BuildContext context,
    FlashcardState state,
    FlashcardController controller,
  ) {
    final managedCards = state.allCards
        .where((c) => c.source == FlashcardSource.user || c.source == FlashcardSource.ai)
        .toList();

    if (managedCards.isEmpty) {
      return Card(
        color: Colors.grey.shade50,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              '追加した単語やAIで生成した単語カードはまだありません。\n「+」ボタンから単語を追加するか、「AIで新しいIT単語を自動生成」を試してみてください。',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: managedCards.length,
      separatorBuilder: (ctx, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final card = managedCards[index];
        return ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(
                  card.term,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Gap(8),
              _buildManagedCardBadge(card.source),
            ],
          ),
          subtitle: Text('${card.meaning} (${card.category})'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context, controller, card),
          ),
        );
      },
    );
  }

  Widget _buildManagedCardBadge(FlashcardSource source) {
    if (source == FlashcardSource.ai) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple.shade200),
        ),
        child: const Text(
          'AI生成',
          style: TextStyle(
            fontSize: 10,
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (source == FlashcardSource.user) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.teal.shade200),
        ),
        child: const Text(
          'カスタム',
          style: TextStyle(
            fontSize: 10,
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _confirmDelete(
    BuildContext context,
    FlashcardController controller,
    Flashcard card,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('単語の削除'),
        content: Text('「${card.term}」を削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteUserCard(card.id);
              Navigator.pop(ctx);
            },
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
