import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import '../../../notifications/data/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';


// Notification settings state
class NotificationSettingsState {
  final bool isEnabled;
  final int hour;
  final int minute;
  final bool isPermissionGranted;
  final bool isLoading;

  const NotificationSettingsState({
    this.isEnabled = false,
    this.hour = 20,
    this.minute = 0,
    this.isPermissionGranted = false,
    this.isLoading = true,
  });

  NotificationSettingsState copyWith({
    bool? isEnabled,
    int? hour,
    int? minute,
    bool? isPermissionGranted,
    bool? isLoading,
  }) {
    return NotificationSettingsState(
      isEnabled: isEnabled ?? this.isEnabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);
}

// Provider
final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsController, NotificationSettingsState>(
        () => NotificationSettingsController());

class NotificationSettingsController
    extends Notifier<NotificationSettingsState> {
  static const String _boxName = 'notification_settings';
  final NotificationService _service = NotificationService();

  @override
  NotificationSettingsState build() {
    _loadSettings();
    return const NotificationSettingsState();
  }

  Future<void> _loadSettings() async {
    try {
      await _service.initialize();

      Box<String>? box;
      try {
        if (Hive.isBoxOpen(_boxName)) {
          box = Hive.box<String>(_boxName);
        } else {
          box = await Hive.openBox<String>(_boxName);
        }
      } catch (_) {
        box = null;
      }

      final isPermitted = await _service.isPermissionGranted();
      final enabled = box?.get('enabled', defaultValue: 'false') == 'true';
      final hour = int.tryParse(box?.get('hour', defaultValue: '20') ?? '20') ?? 20;
      final minute = int.tryParse(box?.get('minute', defaultValue: '0') ?? '0') ?? 0;

      state = state.copyWith(
        isEnabled: enabled && isPermitted,
        hour: hour,
        minute: minute,
        isPermissionGranted: isPermitted,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _saveSettings() async {
    try {
      Box<String>? box;
      try {
        if (Hive.isBoxOpen(_boxName)) {
          box = Hive.box<String>(_boxName);
        } else {
          box = await Hive.openBox<String>(_boxName);
        }
      } catch (_) {
        box = null;
      }
      if (box == null) return;

      await box.put('enabled', state.isEnabled.toString());
      await box.put('hour', state.hour.toString());
      await box.put('minute', state.minute.toString());
    } catch (_) {}
  }

  /// Toggle notification on/off. Returns false if permission was denied.
  Future<bool> toggleEnabled(bool value) async {
    if (value) {
      // Check permission first
      var isPermitted = await _service.isPermissionGranted();
      if (!isPermitted) {
        // Permission not granted – return false to show dialog
        state = state.copyWith(isPermissionGranted: false);
        return false;
      }
      state = state.copyWith(isEnabled: true, isPermissionGranted: true);
      await _service.scheduleDailyNotification(state.hour, state.minute);
    } else {
      state = state.copyWith(isEnabled: false);
      await _service.cancelNotifications();
    }
    await _saveSettings();
    return true;
  }

  Future<void> updateTime(int hour, int minute) async {
    state = state.copyWith(hour: hour, minute: minute);
    if (state.isEnabled) {
      await _service.scheduleDailyNotification(hour, minute);
    }
    await _saveSettings();
  }

  Future<void> openSystemSettings() async {
    await _service.openSettings();
  }

  /// Re-check permission status (call when returning from system settings)
  Future<void> refreshPermissionStatus() async {
    final isPermitted = await _service.isPermissionGranted();
    state = state.copyWith(isPermissionGranted: isPermitted);
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User returned from iOS Settings – refresh permission status
      ref.read(notificationSettingsProvider.notifier).refreshPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(notificationSettingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: settings.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // Section Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'トレーニング通知',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // Description card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: theme.colorScheme.primary, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          '毎日決まった時間に通知を受け取り、学習を習慣化しましょう。',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),

                // Notification Switch
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text(
                          'デイリー通知',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          settings.isEnabled
                              ? '毎日 ${_formatTime(settings.hour, settings.minute)} に通知します'
                              : '通知はオフです',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: settings.isEnabled
                                ? theme.colorScheme.primary
                                    .withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: settings.isEnabled
                                ? theme.colorScheme.primary
                                : Colors.grey,
                          ),
                        ),
                        value: settings.isEnabled,
                        onChanged: (value) => _onToggle(value),
                      ),

                      // Time Picker (only when enabled)
                      if (settings.isEnabled) ...[
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.access_time,
                                color: theme.colorScheme.secondary),
                          ),
                          title: const Text(
                            '通知時刻',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _formatTime(settings.hour, settings.minute),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          onTap: () => _showTimePicker(context, settings),
                        ),
                      ],
                    ],
                  ),
                ),

                // Permission warning (shown when permission is denied)
                if (!settings.isPermissionGranted && !settings.isLoading) ...[
                  const Gap(12),
                  _buildPermissionWarning(context, theme),
                ],

                const Gap(32),

                // App Info section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    'アプリ情報',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('バージョン'),
                        trailing: Text(
                          '1.0.0',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: const Text('オープンソースライセンス'),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                        onTap: () {
                          showLicensePage(
                            context: context,
                            applicationName: 'BrSE AI Coach',
                            applicationVersion: '1.0.0',
                            applicationLegalese: '© 2026 BrSE AI Coach\nAll rights reserved.',
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Gap(24),

                // AI Model Attribution section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    'AIモデル・ライセンス情報',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.smart_toy_outlined),
                        title: const Text('On-Device AI Model'),
                        subtitle: const Text(
                          'Qwen2.5-Coder-0.5B-Instruct (Q4_K_M)',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Apache 2.0',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.memory),
                        title: const Text('Inference Engine'),
                        subtitle: const Text(
                          'llama.cpp / llama_cpp_dart',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'MIT',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'このアプリはオンデバイスAIを使用しており、ユーザーのデータは外部サーバーに送信されません。',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      height: 1.4,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.open_in_browser_outlined),
                  title: const Text('他のアプリを見る'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () async {
                    final url = Uri.parse('https://t-okb-dev.github.io/');
                    if (!await launchUrl(url)) {
                      // Silently ignore if launch fails
                    }
                  },
                ),
                const Gap(24),
              ],
            ),
    );
  }

  Widget _buildPermissionWarning(BuildContext context, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.amber.shade700, size: 20),
              const Gap(8),
              Expanded(
                child: Text(
                  '通知の許可が必要です',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.amber.shade800,
                  ),
                ),
              ),
            ],
          ),
          const Gap(6),
          Text(
            'iOSの設定アプリからこのアプリの通知を許可してください。「設定を開く」をタップするとiOSの設定画面へ移動します。',
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const Gap(10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref
                    .read(notificationSettingsProvider.notifier)
                    .openSystemSettings();
              },
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('設定を開く'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.amber.shade800,
                side: BorderSide(color: Colors.amber.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onToggle(bool value) async {
    final controller = ref.read(notificationSettingsProvider.notifier);
    final success = await controller.toggleEnabled(value);

    if (!success && mounted) {
      // Permission denied – show dialog
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.notifications_off_outlined, size: 24),
            Gap(8),
            Expanded(child: Text('通知の許可が必要です', style: TextStyle(fontSize: 16))),
          ],
        ),
        content: const Text(
          'デイリー通知を有効にするには、iOSの設定からこのアプリの通知を許可してください。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('キャンセル'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref
                  .read(notificationSettingsProvider.notifier)
                  .openSystemSettings();
            },
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('設定を開く'),
          ),
        ],
      ),
    );
  }

  void _showTimePicker(
      BuildContext context, NotificationSettingsState settings) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        int selectedHour = settings.hour;
        int selectedMinute = settings.minute;
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('キャンセル'),
                    ),
                    const Text(
                      '通知時刻を選択',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(notificationSettingsProvider.notifier)
                            .updateTime(selectedHour, selectedMinute);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('完了',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: DateTime(
                      2024, 1, 1, settings.hour, settings.minute),
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime dateTime) {
                    selectedHour = dateTime.hour;
                    selectedMinute = dateTime.minute;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
