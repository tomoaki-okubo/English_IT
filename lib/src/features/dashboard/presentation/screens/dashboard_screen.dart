import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../exercises/presentation/controllers/saved_drills_controller.dart';
import '../widgets/training_calendar_card.dart';
import '../../../llm_engine/data/services/model_downloader_service.dart';


class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
  }

  void _checkAndShowDownloadDialog(ModelDownloadState downloadState) {
    if ((downloadState.status == ModelDownloadStatus.notDownloaded || downloadState.status == ModelDownloadStatus.error) && !_dialogShown) {
      _dialogShown = true;
      _showDownloadDialog();
    }
  }

  void _showDownloadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Consumer(
            builder: (context, ref, child) {
              final downloadState = ref.watch(modelDownloaderProvider);
              final theme = Theme.of(context);

              // Automatically dismiss the dialog once download completes successfully
              if (downloadState.status == ModelDownloadStatus.ready) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                  if (downloadState.justFinishedDownloading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AIモデルのダウンロードが完了しました！'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                });
              }

              final progressPercent = (downloadState.progress * 100).toStringAsFixed(0);
              final downloadedMb = (downloadState.downloadedBytes / (1024 * 1024)).toStringAsFixed(1);
              final totalMb = downloadState.totalBytes > 0 
                  ? (downloadState.totalBytes / (1024 * 1024)).toStringAsFixed(1)
                  : "398.0";

              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Row(
                  children: [
                    Icon(Icons.smart_toy_outlined, color: theme.colorScheme.primary),
                    const Gap(10),
                    const Flexible(
                      child: Text('AIモデルのダウンロード'),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'IT英語のAI ChatやDrills機能を使用するには、端末内 (On-Device) で動作するAIモデル (~398MB) のインストールが必要です。',
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                    const Gap(16),
                    if (downloadState.status == ModelDownloadStatus.downloading) ...[
                      LinearProgressIndicator(
                        value: downloadState.progress,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$progressPercent% 完了', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('$downloadedMb MB / $totalMb MB', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ] else if (downloadState.status == ModelDownloadStatus.error) ...[
                      Text(
                        'エラーが発生しました:\n${downloadState.errorMessage}',
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ] else ...[
                      Text(
                        'WiFi環境でのダウンロードを推奨します。',
                        style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
                actions: _buildDialogActions(context, ref, downloadState),
              );
            },
          ),
        );
      },
    ).then((_) {
      _dialogShown = false;
    });
  }

  List<Widget> _buildDialogActions(BuildContext context, WidgetRef ref, ModelDownloadState downloadState) {
    if (downloadState.status == ModelDownloadStatus.downloading) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Center(
            child: Text(
              'ダウンロード中... アプリを閉じずにお待ちください',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ];
    }

    return [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('スキップ'),
      ),
      FilledButton(
        onPressed: () {
          ref.read(modelDownloaderProvider.notifier).startDownload();
        },
        child: Text(downloadState.status == ModelDownloadStatus.error ? '再試行' : 'ダウンロード'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ModelDownloadState>(modelDownloaderProvider, (previous, next) {
      if ((next.status == ModelDownloadStatus.notDownloaded || next.status == ModelDownloadStatus.error) && !_dialogShown) {
        _checkAndShowDownloadDialog(next);
      }
    });

    final savedState = ref.watch(savedDrillsControllerProvider);
    final mistakeCount = savedState.mistakes.length;
    final totalSavedCount = savedState.items.length;
    final downloadState = ref.watch(modelDownloaderProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome, BrSE!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Gap(4),
              const Text('Ready to improve your IT English skills?'),
              const Gap(12),

              // Model Download Prompt Card (Accessible if user skipped dialog)
              if (downloadState.status != ModelDownloadStatus.ready)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.smart_toy_outlined, color: theme.colorScheme.primary, size: 24),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI Model をダウンロード',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const Gap(2),
                            Text(
                              'AI Chat と Drills を使うにはモデル (~398MB) が必要です',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            if (downloadState.status == ModelDownloadStatus.downloading) ...[
                              const Gap(6),
                              LinearProgressIndicator(
                                value: downloadState.progress,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Gap(8),
                      if (downloadState.status != ModelDownloadStatus.downloading)
                        ElevatedButton(
                          onPressed: () {
                            ref.read(modelDownloaderProvider.notifier).startDownload();
                          },
                          style: ElevatedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          child: const Text('Download', style: TextStyle(fontSize: 13)),
                        ),
                    ],
                  ),
                ),
              const Gap(4),

              // Training Activity Calendar & Streak Tracker
              const TrainingCalendarCard(),
              const Gap(20),

              const Text(
                'Training Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(12),

              _buildFeatureCard(
                context,
                title: 'AI Chat & Roleplay',
                subtitle: 'Practice real-world scenarios with virtual engineers',
                icon: Icons.chat_bubble_outline,
                color: Theme.of(context).colorScheme.primary,
                onTap: () => context.push('/chat'),
              ),
              const Gap(12),
              _buildFeatureCard(
                context,
                title: 'Drills',
                subtitle: 'Master the vocabulary and communication with AI',
                icon: Icons.school_outlined,
                color: Theme.of(context).colorScheme.secondary,
                onTap: () => context.push('/exercise'),
              ),
              const Gap(12),
              _buildFeatureCard(
                context,
                title: '復習・見返しノート',
                subtitle: mistakeCount > 0
                    ? '$mistakeCount 件の間違えた問題があります'
                    : '間違えた問題やブックマークした問題を復習',
                icon: Icons.auto_stories_outlined,
                color: Colors.deepOrange,
                badgeCount: totalSavedCount > 0 ? totalSavedCount : null,
                onTap: () => context.push('/saved-drills'),
              ),
              const Gap(12),
              _buildFeatureCard(
                context,
                title: 'IT英語単語カード (Flashcards)',
                subtitle: '実務必須単語の暗記・AI自動生成・自作単語管理',
                icon: Icons.style_outlined,
                color: Colors.teal,
                onTap: () => context.push('/flashcards'),
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    int? badgeCount,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        ),
                        if (badgeCount != null && badgeCount > 0) ...[
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$badgeCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Gap(4),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
