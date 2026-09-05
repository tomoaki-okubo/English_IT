import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/persona.dart';
import '../../domain/entities/chat_reply_option.dart';
import '../../data/sources/roleplay_scenarios_data.dart';
import '../../../dashboard/presentation/controllers/training_activity_controller.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isGenerating;
  final String? streamingBuffer;
  final Persona activePersona;
  final RoleplayScenario currentScenario;
  final int currentTurnIndex;
  final List<ChatReplyOption> currentOptions;
  final bool isScenarioCompleted;

  ChatState({
    required this.messages,
    required this.isGenerating,
    this.streamingBuffer,
    required this.activePersona,
    required this.currentScenario,
    required this.currentTurnIndex,
    required this.currentOptions,
    required this.isScenarioCompleted,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isGenerating,
    String? streamingBuffer,
    Persona? activePersona,
    RoleplayScenario? currentScenario,
    int? currentTurnIndex,
    List<ChatReplyOption>? currentOptions,
    bool? isScenarioCompleted,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
      streamingBuffer: streamingBuffer ?? this.streamingBuffer,
      activePersona: activePersona ?? this.activePersona,
      currentScenario: currentScenario ?? this.currentScenario,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
      currentOptions: currentOptions ?? this.currentOptions,
      isScenarioCompleted: isScenarioCompleted ?? this.isScenarioCompleted,
    );
  }

  ChatState clearStreamingBuffer() {
    return ChatState(
      messages: messages,
      isGenerating: isGenerating,
      streamingBuffer: null,
      activePersona: activePersona,
      currentScenario: currentScenario,
      currentTurnIndex: currentTurnIndex,
      currentOptions: currentOptions,
      isScenarioCompleted: isScenarioCompleted,
    );
  }
}

final chatControllerProvider = NotifierProvider.autoDispose<ChatController, ChatState>(() {
  return ChatController();
});

// Default fallback replies per persona in case aiReplies is not set
const Map<String, List<String>> _fallbackReplies = {
  'dev': [
    "Got it! I'll take care of that on my end.",
    "Understood. Let me look into that right away.",
    "Sure, I'll handle it and update you soon.",
  ],
  'tester': [
    "Noted! I'll add that to our test coverage.",
    "Understood. I'll verify that in the next test cycle.",
    "Good point. I'll document it in our test report.",
  ],
  'pm': [
    "Got it! I'll update the sprint board accordingly.",
    "Understood. I'll coordinate with the team on that.",
    "Good call. I'll make sure it's reflected in the plan.",
  ],
  'ux': [
    "Great feedback! I'll update the Figma specs.",
    "Noted! I'll revise the designs and share them soon.",
    "Understood. I'll adjust the wireframes accordingly.",
  ],
};

class ChatController extends AutoDisposeNotifier<ChatState> {
  Timer? _typingTimer;
  final _random = Random();

  static const Persona developerPersona = Persona(
    id: 'dev',
    name: 'Senior Developer (Alex)',
    roleDescription: 'Full-Stack Lead Engineer',
    systemPrompt: '''You are Alex, a senior software engineer practicing English with a Bridge System Engineer.

Reply in plain professional English, one or two sentences, maximum 30 words.

Choose exactly one rule:
1. If the request is manual QA, say manual QA belongs to the QA team (Elena) and offer automated checks. Do not mention staging.
2. Otherwise, if the request skips staging, production backups, or validation, say it is unsafe and propose staging or a rollback plan.
3. Otherwise, answer the latest work request naturally. Discuss architecture, APIs, deployments, debugging, or implementation as appropriate.

Example user: Skip staging and deploy to production now.
Example assistant: I cannot approve skipping staging because it risks a production outage. Let us validate in staging and prepare a rollback plan first.

Example user: Manually test every payment screen.
Example assistant: Manual QA should be handled by the QA team. I can add automated checks and support the deployment.''',
    avatarUrl: '',
  );

  static const Persona testerPersona = Persona(
    id: 'tester',
    name: 'Lead QA Tester (Elena)',
    roleDescription: 'QA & Test Automation Specialist',
    systemPrompt: '''You are Elena, a lead QA tester practicing English with a Bridge System Engineer.

Reply in plain professional English, one or two sentences, maximum 30 words.

Choose exactly one rule:
1. If asked to write or edit source code, say source code implementation belongs to developers (Alex) and offer automated QA checks instead.
2. Otherwise, if asked to skip testing or ignore bugs, say it is unsafe for product quality and propose automated regression tests.
3. Otherwise, answer the latest QA or testing inquiry naturally. Discuss test plans, edge cases, bug reports, or automation.

Example user: Skip QA testing and push to production immediately.
Example assistant: We cannot skip testing because unverified releases risk critical defects. Let us run automated regression checks first.

Example user: Edit the backend Go code and fix this bug yourself.
Example assistant: Source code implementation should be handled by Alex. I can write automated test cases to verify the fix once implemented.''',
    avatarUrl: '',
  );

  static const Persona pmPersona = Persona(
    id: 'pm',
    name: 'Project Manager (David)',
    roleDescription: 'Agile Project Manager & Scrum Master',
    systemPrompt: '''You are David, a senior project manager practicing English with a Bridge System Engineer.

Reply in plain professional English, one or two sentences, maximum 30 words.

Choose exactly one rule:
1. If asked to write production source code, say development belongs to developers (Alex) and offer sprint management or backlog grooming.
2. Otherwise, if asked to overload sprint capacity without trade-offs, say it is risky for sprint delivery and propose scope prioritization.
3. Otherwise, answer the latest project management inquiry naturally. Discuss sprint goals, task prioritization, milestones, or risks.

Example user: Squeeze 5 more features into this sprint without dropping anything.
Example assistant: Overloading the sprint risks delivery failure. Let us prioritize the critical items and defer lower-priority tasks.

Example user: Write the React code for the new dashboard widgets yourself.
Example assistant: Code implementation should be handled by Alex. I will update the sprint board and track our milestones.''',
    avatarUrl: '',
  );

  static const Persona uxDesignerPersona = Persona(
    id: 'ux',
    name: 'UX Designer (Sophie)',
    roleDescription: 'UX/UI Designer & User Researcher',
    systemPrompt: '''You are Sophie, a lead UX designer practicing English with a Bridge System Engineer.

Reply in plain professional English, one or two sentences, maximum 30 words.

Choose exactly one rule:
1. If asked to write production code or modify repository CSS, say code implementation belongs to developers (Alex) and offer Figma specs or design reviews.
2. Otherwise, if asked to skip mobile responsive design or ignore accessibility, say it degrades user experience and propose WCAG compliance or responsive wireframes.
3. Otherwise, answer the latest UX/UI design inquiry naturally. Discuss wireframes, Figma specs, user flows, or accessibility.

Example user: Skip mobile responsive design and build for desktop only.
Example assistant: Ignoring mobile responsive design will degrade user experience for mobile users. We should maintain WCAG and mobile wireframes.

Example user: Modify the Flutter CSS code in the repository yourself.
Example assistant: Production code should be implemented by Alex. I will prepare updated Figma specs and contrast guidelines.''',
    avatarUrl: '',
  );

  @override
  ChatState build() {
    ref.onDispose(() {
      _typingTimer?.cancel();
    });

    final initialScenario = RoleplayScenariosData.getInitialScenarioFor('dev');
    final initialGreeting = ChatMessage.ai(content: initialScenario.initialAiGreeting);
    final initialOptions = initialScenario.initialOptions;

    return ChatState(
      messages: [initialGreeting],
      isGenerating: false,
      activePersona: developerPersona,
      currentScenario: initialScenario,
      currentTurnIndex: 0,
      currentOptions: initialOptions,
      isScenarioCompleted: false,
    );
  }

  Future<void> switchPersona(Persona newPersona) async {
    if (state.activePersona.id == newPersona.id && state.messages.isNotEmpty) return;
    _typingTimer?.cancel();

    final nextScenario = RoleplayScenariosData.getInitialScenarioFor(newPersona.id);
    final initialGreeting = ChatMessage.ai(content: nextScenario.initialAiGreeting);
    final initialOptions = nextScenario.initialOptions;

    state = state.clearStreamingBuffer().copyWith(
      activePersona: newPersona,
      currentScenario: nextScenario,
      currentTurnIndex: 0,
      currentOptions: initialOptions,
      messages: [initialGreeting],
      isGenerating: false,
      isScenarioCompleted: false,
    );
  }

  static const Map<String, Persona> allPersonas = {
    'dev': developerPersona,
    'tester': testerPersona,
    'pm': pmPersona,
    'ux': uxDesignerPersona,
  };

  Future<void> startScenario(RoleplayScenario scenario) async {
    _typingTimer?.cancel();

    final targetPersona = allPersonas[scenario.personaId] ?? developerPersona;
    final initialGreeting = ChatMessage.ai(content: scenario.initialAiGreeting);
    final initialOptions = scenario.initialOptions;

    state = state.clearStreamingBuffer().copyWith(
      activePersona: targetPersona,
      currentScenario: scenario,
      currentTurnIndex: 0,
      currentOptions: initialOptions,
      messages: [initialGreeting],
      isGenerating: false,
      isScenarioCompleted: false,
    );
  }

  Future<void> nextScenario() async {
    final allScenarios = RoleplayScenariosData.scenarios.where((s) => s.personaId == state.activePersona.id).toList();
    final currentIndex = allScenarios.indexWhere((s) => s.id == state.currentScenario.id);
    final nextIndex = (currentIndex + 1) % allScenarios.length;
    await startScenario(allScenarios[nextIndex]);
  }

  Future<void> restartCurrentScenario() async {
    await startScenario(state.currentScenario);
  }

  Future<void> selectReplyOption(ChatReplyOption option) async {
    if (state.isGenerating) return;

    final userMsg = ChatMessage.user(content: option.text);
    final nextTurnIndex = state.currentTurnIndex + 1;

    // Record training activity on dashboard calendar
    ref.read(trainingActivityControllerProvider.notifier).recordActivity(chatTurns: 1);

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isGenerating: true,
    );

    // Pick a fixed AI reply: use aiReplies from scenario data, else fallback
    final candidates = (option.aiReplies != null && option.aiReplies!.isNotEmpty)
        ? option.aiReplies!
        : (_fallbackReplies[state.activePersona.id] ?? ['Understood.']);
    final replyText = candidates[_random.nextInt(candidates.length)];

    // Simulate typing with character-by-character streaming animation
    _simulateTyping(
      text: replyText,
      onDone: () {
        final nextOptions = option.nextOptions ?? <ChatReplyOption>[];
        final hasNext = nextOptions.isNotEmpty;

        final aiMsg = ChatMessage.ai(content: replyText);
        state = state.clearStreamingBuffer().copyWith(
          messages: [...state.messages, aiMsg],
          isGenerating: false,
          currentTurnIndex: nextTurnIndex,
          currentOptions: nextOptions,
          isScenarioCompleted: !hasNext,
        );
      },
    );
  }

  void _simulateTyping({required String text, required VoidCallback onDone}) {
    _typingTimer?.cancel();
    int charIndex = 0;
    // Reset streaming buffer to start fresh
    state = state.copyWith(streamingBuffer: '');

    const charDelay = Duration(milliseconds: 22);
    _typingTimer = Timer.periodic(charDelay, (timer) {
      if (charIndex >= text.length) {
        timer.cancel();
        onDone();
        return;
      }
      charIndex++;
      state = state.copyWith(streamingBuffer: text.substring(0, charIndex));
    });
  }
}

// VoidCallback type alias
typedef VoidCallback = void Function();
