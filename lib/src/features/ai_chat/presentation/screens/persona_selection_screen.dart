import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../controllers/chat_controller.dart';

class PersonaSelectionScreen extends ConsumerWidget {
  const PersonaSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final personas = [
      _PersonaCardData(
        persona: ChatController.developerPersona,
        icon: Icons.code_rounded,
        color: Colors.blue,
        scenarioCount: 2,
        descriptionJa: 'アーキテクチャ・API設計・コード実装について議論',
      ),
      _PersonaCardData(
        persona: ChatController.testerPersona,
        icon: Icons.bug_report_rounded,
        color: Colors.amber.shade800,
        scenarioCount: 2,
        descriptionJa: 'テスト計画・バグ報告・リリース判定について議論',
      ),
      _PersonaCardData(
        persona: ChatController.pmPersona,
        icon: Icons.assignment_ind_outlined,
        color: Colors.teal,
        scenarioCount: 2,
        descriptionJa: 'スプリント計画・スコープ調整・進捗報告について議論',
      ),
      _PersonaCardData(
        persona: ChatController.uxDesignerPersona,
        icon: Icons.design_services_outlined,
        color: Colors.deepPurple,
        scenarioCount: 2,
        descriptionJa: 'UIレビュー・ユーザーフロー・デザインフィードバックについて議論',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat & Roleplay'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.people_alt_outlined,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
              const Gap(12),
              Text(
                'チャット相手を選んでください',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Gap(4),
              Text(
                'Select a team member to practice English roleplay',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const Gap(24),
              ...personas.map((data) => Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: _buildPersonaCard(context, theme, data),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonaCard(
    BuildContext context,
    ThemeData theme,
    _PersonaCardData data,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: data.color.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: () {
          context.push('/chat/${data.persona.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(data.icon, color: data.color, size: 30),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.persona.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      data.persona.roleDescription,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: data.color,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      data.descriptionJa,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Gap(6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${data.scenarioCount} scenarios',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonaCardData {
  final dynamic persona;
  final IconData icon;
  final Color color;
  final int scenarioCount;
  final String descriptionJa;

  const _PersonaCardData({
    required this.persona,
    required this.icon,
    required this.color,
    required this.scenarioCount,
    required this.descriptionJa,
  });
}
